function sock = listen(port)
    server = java.net.ServerSocket(port);
    sock = socket.Socket(server.accept());
end

