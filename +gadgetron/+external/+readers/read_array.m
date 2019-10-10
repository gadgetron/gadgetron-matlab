function arr = read_array(socket, type)
    switch type
        case 'complex64'
            arr = read_complex_array(socket, 'single');
        case 'complex128'
            arr = read_complex_array(socket, 'double');
        otherwise
            arr = read_simple_array(socket, type);
    end
end

function arr = read_simple_array(socket, type)
    dims = gadgetron.external.readers.read_vector(socket, 'uint64');
    arr = reshape(read(socket, prod(dims), type), dims);
end

function arr = read_complex_array(socket, type)
    dims = gadgetron.external.readers.read_vector(socket, 'uint64');
    arr = reshape( ...
        gadgetron.external.readers.as_interleaved_complex(read(socket, 2 * prod(dims), type)), ...
        dims ...
    );
end
