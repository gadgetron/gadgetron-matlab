function sock = listen(port)
    server = java.net.ServerSocket(port);
    server.setReuseAddress(true);
    server.setSoTimeout(1000); 

    % Accept would block forever in previous versions, leaving Matlab
    % unresponsive (process was blocked, so Ctrl+C was ignored). 
    % We set a timeout, ignoring the exception, to give the user a 
    % chance to interrupt the listen call. 
    
    while true
        try
            sock = socket.Socket(server.accept());
            break        
        end
    end
end

