function recon_data = read_recon_data(socket)
    recon_data = gadgetron.types.ReconData(read_recon_bits(socket));
end

function recon_bits = read_recon_bits(socket)
    n_recon_bits = read(socket, 1, 'uint64');
    recon_bits = arrayfun(@(~) read_recon_bit(socket), 1:n_recon_bits);
end

function recon_bit = read_recon_bit(socket)
    recon_bit.buffer = read_recon_buffer(socket);
    recon_bit.reference = gadgetron.external.readers.read_optional(socket, @read_recon_buffer);
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
