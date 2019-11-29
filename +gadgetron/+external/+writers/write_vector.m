function write_vector(socket, vector)   
    size = uint64(numel(vector));

    write(socket, size);
    write(socket, vector);
end