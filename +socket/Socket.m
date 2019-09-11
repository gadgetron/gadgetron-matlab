classdef Socket < handle
    properties (Access = private)
        sock 
    end
    
    properties (Access = private, Constant)
        sizes = containers.Map( ...
            {'int8', 'uint8', 'int16', 'uint16', 'int32', 'uint32', ...
             'int64', 'uint64', 'single', 'double'}, ...
            [1, 1, 2, 2, 4, 4, 8, 8, 4, 8] ...
        );
    end
    
    methods
        function self = Socket(sock)
            self.sock = javaObject('gadgetron.external.SocketWrapper', sock);
        end
        
        function delete(self)
            close(self.sock);
        end
        
        function out = read(self, n, type)
            nbytes = n * self.sizes(type);
            out = typecast(read(self.sock, nbytes), type);
        end
        
        function write(self, data)
            write(self.sock, typecast(data, 'uint8'));
        end
    end
end

