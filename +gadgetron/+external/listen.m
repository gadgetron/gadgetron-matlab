function listen(port, handler)

    path = fileparts(mfilename('fullpath'));
    javaaddpath(path);

    fprintf("Starting external MATLAB module '%s' in state: [PASSIVE]\n", func2str(handler))
    fprintf("Waiting for connection from client on port: %d\n", port)
    
    sock = socket.listen(port);
    connection = gadgetron.external.Connection(sock);
   
    handler(connection);
    sock.write(ismrmrd.Constants.CLOSE);
end

