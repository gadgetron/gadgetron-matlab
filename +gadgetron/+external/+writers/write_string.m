function write_string(socket, string, size)
    length = cast(strlength(string), size);

    write(socket, length);
    
    if length == 0, return; end
    
    write(socket, unicode2native(string, 'UTF-8'));
end

