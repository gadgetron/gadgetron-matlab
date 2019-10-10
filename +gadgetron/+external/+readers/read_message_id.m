function mid = read_message_id(socket)
    mid = read(socket, 1, 'uint16');
end
