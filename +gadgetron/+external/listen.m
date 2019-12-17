function listen(port, handler, varargin)
    % LISTEN Wait for a connection from Gadgetron (or other ISMRMRD client).
    % 
    %   LISTEN(PORT, HANDLER, ...) 
    % 
    % For more information, see <a href="">the Gadgetron Wiki</a>. 

    fprintf("Starting external MATLAB module '%s' in state: [PASSIVE]\n", func2str(handler))
    fprintf("Waiting for connection from client on port: %d\n", port)
    
    sock = socket.listen(port);
    connection = gadgetron.external.Connection(sock);
   
    handler(connection, varargin{:});
end

