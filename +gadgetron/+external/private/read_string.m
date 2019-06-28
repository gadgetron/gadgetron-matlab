function string = read_string(socket, size)
    length = read(socket, 1, size);
    string = native2unicode(read(socket, length), 'UTF-8');
end
