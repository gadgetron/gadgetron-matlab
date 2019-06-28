
function main()
    port = getenv('GADGETRON_EXTERNAL_PORT');
    module = getenv('GADGETRON_EXTERNAL_MODULE');

    if isempty(port) || isempty(module)
        fprintf("Gadgetron External MATLAB Module v. %s\n", gadgetron.version);
        return
    end
    
    fprintf("Starting external MATLAB module '%s' in state: [ACTIVE]\n", module)
    fprintf("Connecting to parent on port %s\n", port)
    
    socket = tcpclient('localhost', str2num(port), 'ConnectTimeout', 10);
    connection = gadgetron.external.Connection(socket);
    
    feval(module, connection);
    write(socket, ismrmrd.Constants.CLOSE);
end

