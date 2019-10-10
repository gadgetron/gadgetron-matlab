function config = read_config(socket)
    config = gadgetron.external.readers.read_string(socket, 'uint32');
end
