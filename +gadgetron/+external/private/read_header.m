function header = read_header(socket)
    header = read_string(socket, 'uint32');
end
