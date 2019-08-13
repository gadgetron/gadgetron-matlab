function string = read_string(socket, size)
    length = read(socket, 1, size);
    string = native2unicode(read(socket, length, 'uint8')', 'UTF-8');
end
