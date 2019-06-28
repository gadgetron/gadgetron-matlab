function config = read_config(socket)
    config = read_string(socket, 'uint32');
end
