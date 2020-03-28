function listen(port, handler, varargin)
    % LISTEN Wait for a connection from Gadgetron (or other client).
    % 
    %   LISTEN(PORT, HANDLER, ...) 
    % 
    % LISTEN will listen for incoming connections on the specified port.
    % When a connection is ready, HANDLER is called with a Connection 
    % object as the first argument. 
    % 
    % Any additional arguments provided to listen will be forwarded to
    % HANDLER, when a connection is ready.
    % 
    % Example: 
    %   LISTEN(18000, @(~, a, b) disp([a, ', ', b]), 'Hello', 'World')
    % 
    % Will print 'Hello, World' when a connection is established.  
    %
    % For more information, see <a href="https://github.com/gadgetron/gadgetron/wiki">the Gadgetron Wiki</a>. 

    fprintf("Starting ISMRMRD server with handler '%s' in state: [PASSIVE]\n", func2str(handler))
    fprintf("Waiting for connection from client on port: %d\n", port)
    
    sock = socket.listen(port);
    connection = gadgetron.external.Connection(sock);
    
    handler(connection, varargin{:});
end

