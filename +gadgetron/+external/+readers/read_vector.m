function v = read_vector(socket, type)
    n_elm = read(socket, 1, 'uint64');
    v = read(socket, n_elm, type)';
end
