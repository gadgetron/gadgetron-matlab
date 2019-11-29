
function main()
    
    port = getenv('GADGETRON_EXTERNAL_PORT');
    module = getenv('GADGETRON_EXTERNAL_MODULE');
    
    if isempty(port) || isempty(module)
        fprintf("Gadgetron External MATLAB Module\n");
        return
    end
    
    fprintf("Starting external MATLAB module '%s' in state: [ACTIVE]\n", module)
    fprintf("Connecting to parent on port %s\n", port)
    
    sock = socket.connect('localhost', str2num(port));
    connection = gadgetron.external.Connection(sock);
    
    feval(module, connection);
end

