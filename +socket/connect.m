function sock = connect(address, port)
    sock = socket.Socket(java.net.Socket(address, port));
end

