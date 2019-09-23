function IDEAL(connection)

    next = transform_recon_data(@connection.next, connection.header);
    next = send_recon_data_to_client(next);
    
    tic; gadgetron.consume(next); toc
end

function outdata = unwrap(buffer, frequencies)

    [nzf, nte, nslices, ncoils, ntimes] = size(buffer.data);

    A = pinv(exp(-1i * 2 * pi * transpose(0:nte-2) * g.dte * frequencies));
    tt = (0:nzf-1) / g.bw;

    nfreqs = length(frequencies);
    outdata = zeros(nzf, nfreqs, nslices, ncoils, ntimes);

    for ls=1:nslices
        for lc=1:ncoils
            for lt=1:ntimes
                outdata(:, :, ls, lc, lt) =  ...
                    reshape( ...
                        transpose( ...
                            transpose(A * squeeze(buffer.data(:, 2:end, ls, lc, lt))) .* ...
                            exp(1i * 2 * pi * frequencies' * tt) ...
                        ), ...
                        [nzf, nfreqs] ...
                    );
            end
        end
    end
end

function p_freq = pyruvate_frequency(buffer)

    nf = max(8192, size(buffer.data, 1));

    spec = fftshift(fft(buffer.data(:,1,:,:,:,:), nf, 1), 1);
    scale = -g.bw * (-nf/2:nf/2-1) / nf;

    absspec = sum(abs(spec), [2 3 4 5]);
    [~, i_max] = max(absspec);
    i_width = ceil(max([2, 20 / (g.bw / nf)])); % width at least +-20Hz or +-2pts
    indices = (i_max - i_width):(i_max + i_width);

    p_freq = sum(scale(indices) * absspec(indices, 1)) / sum(absspec(indices, 1));

    fprintf('Pyruvate frequency = %g [Hz]\n', p_freq);        
end

function next = transform_recon_data(input, header)



    function do_something(recon_data)

        % Only one recon space supported, and we have no interest in the
        % reference data.
        buffer = recon_data.bits.data; 

        frequencies = g.frequencies + pyruvate_frequency(buffer);
        outdata = unwrap(buffer, frequencies);
        
        % Create headers

        nheaders = nslices*ntimes;
        headers = ismrmrd.AcquisitionHeader(nheaders);

        old_headers = buffer.headers;
        headers.version(:) = old_headers.version(1);
        headers.number_of_samples(:) = old_headers.number_of_samples(1);
        headers.center_sample(:) = old_headers.center_sample(1);
        headers.active_channels(:) = ncoils;

        headers.read_dir  = repmat(single([1 0 0]'), [1 nheaders]);
        headers.phase_dir = repmat(single([0 1 0]'), [1 nheaders]);
        headers.slice_dir = repmat(single([0 0 1]'), [1 nheaders]);

        for rep = 1:ntimes
            acqno = rep;

            headers.scan_counter(acqno) = 0;
            headers.idx.kspace_encode_step_1(acqno) = acqno-1;
            headers.idx.repetition(acqno) = 0;


            % Set the flags
            headers.flagClearAll(acqno);
            if rep == 1

                headers.flagSet(headers.FLAGS.ACQ_FIRST_IN_ENCODE_STEP1, acqno);
                headers.flagSet(headers.FLAGS.ACQ_FIRST_IN_SLICE, acqno);
                headers.flagSet(headers.FLAGS.ACQ_FIRST_IN_REPETITION, acqno);
            end
            if rep==ntimes
                headers.flagSet(headers.FLAGS.ACQ_LAST_IN_ENCODE_STEP1, acqno);
                headers.flagSet(headers.FLAGS.ACQ_LAST_IN_SLICE, acqno);
                headers.flagSet(headers.FLAGS.ACQ_LAST_IN_REPETITION, acqno);
            end
            headers.trajectory_dimensions(acqno) = old_headers.trajectory_dimensions(acqno);


        end

        buffer.headers = headers;
        buffer.trajectory = buffer.trajectory(:,:,1,:,:); %Only include the first spirals

        % Create reference data to use for coil sensitivity maps
        reference = struct(buffer); %Hope Matlab does a deep copy
        reference.data = reference.data(:,4,:,:,:); %Only get Pyrovate, which is number 4
        reference.trajectory = reference.trajectory(:,:,1,:,:); %Just get a single spiral
        reference.headers = headers.select(1:ntimes); %Include first header only. Hope it works

        for f = 1:nfreqs
            buffer =struct(buffer);
            buffer.data=outdata(:,f,:,:,:);
            g.putBufferQ(buffer,reference);
        end        
    end

    
    next = @() input();
end

function g = do_things_with_the_header(header)
    g.frequencies = [ 392.0   267.0   177.0     0.0  -324.0];
    g.bw = header.userParameters.userParameterDouble(1).value; % bandwidth
    g.dte = header.userParameters.userParameterDouble(2).value; % ? time echo
end