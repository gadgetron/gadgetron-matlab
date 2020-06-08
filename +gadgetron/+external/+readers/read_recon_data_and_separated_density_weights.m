function recon_data = read_recon_data_and_separated_density_weights(socket)
    recon_data = gadgetron.types.ReconData(read_recon_bits(socket));
end

function recon_bits = read_recon_bits(socket)
    n_recon_bits = read(socket, 1, 'uint64');
    recon_bits = arrayfun(@(~) read_recon_bit(socket), 1:n_recon_bits);
end

function recon_bit = read_recon_bit(socket)
    recon_bit.buffer = read_recon_buffer(socket);
    recon_bit.buffer = separate_traj_and_dcw(recon_bit.buffer);
    recon_bit.reference = gadgetron.external.readers.read_optional(socket, @read_recon_buffer);
    recon_bit.reference = separate_traj_and_dcw(recon_bit.reference);
end

function buffer = read_recon_buffer(socket)
    buffer.data = gadgetron.external.readers.read_array(socket, 'complex64');
    buffer.trajectory = gadgetron.external.readers.read_optional(socket, @gadgetron.external.readers.read_array, 'single');
    buffer.density = gadgetron.external.readers.read_optional(socket, @gadgetron.external.readers.read_array, 'single');
    buffer.headers = read_header_array(socket);
    buffer.sampling_description = read_sampling_description(socket);       
end

function headers = read_header_array(socket)
    dims = gadgetron.external.readers.read_vector(socket, 'uint64');
    n_bytes = 340 * prod(dims); % 340 bytes in an Acquisition header.
    headers = gadgetron.external.readers.decode_acquisition_headers( ...
        read(socket, n_bytes, 'uint8'), ...
        dims ...
    );
end

function sampling_description = read_sampling_description(socket)
    sampling_description.encoded_fov = read(socket, 3, 'single');
    sampling_description.recon_fov = read(socket, 3, 'single');
    sampling_description.encoded_matrix = read(socket, 3, 'uint16');
    sampling_description.recon_matrix = read(socket, 3, 'uint16');
    sampling_description.sampling_limits = read_sampling_limits(socket);

    % Sampling description C-struct has two bytes of padding.
    read(socket, 2, 'uint8'); 
end

function sampling_limits = read_sampling_limits(socket)
    raw = read(socket, 9, 'uint16');
    sampling_limits.min = raw(1:3:end);
    sampling_limits.center = raw(2:3:end);
    sampling_limits.max = raw(3:3:end);
end

function buffer = separate_traj_and_dcw(buffer) % retrocompatibility
    if(~isempty(buffer) && isempty(buffer.density) && ~isempty(buffer.trajectory))
        if(buffer.headers.trajectory_dimensions(1) == 3)
            buffer.density = buffer.trajectory(3,:,:);
            buffer.trajectory(3,:,:)=[];
            buffer.headers.trajectory_dimensions=2*ones(size(buffer.headers.trajectory_dimensions));
        end
    end
end