function config = read_config_file(socket)
    filename = read(socket, 1024, 'int8');

    filename = filename(filename ~= 0);
    filename = char(filename');
    
    warning( ...
        "gadgetron:external:config_filename", ...
        "[Unsupported] Client referenced config file by name: %s", ...
        filename ...
    );
    
    config = filename;
end

