function headers = read_header_array(socket, size, parse_fn)
    dimensions = gadgetron.external.readers.read_vector(socket, 'uint64');
    nbytes = prod(dimensions) * size;
    headers = parse_fn(read(socket, nbytes, 'uint8'), dimensions);
end
