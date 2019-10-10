function header = read_header(socket)
    header = gadgetron.external.readers.read_string(socket, 'uint32');
end
