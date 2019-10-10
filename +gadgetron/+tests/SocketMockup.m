classdef SocketMockup < handle
    
    properties (Access = private)
        bytes uint8 = []      
    end

    properties (Access = private, Constant)
        sizes = containers.Map( ...
            {'int8', 'uint8', 'int16', 'uint16', 'int32', 'uint32', ...
             'int64', 'uint64', 'single', 'double'}, ...
            [1, 1, 2, 2, 4, 4, 8, 8, 4, 8] ...
        );
    end

    methods
        function out = read(self, n, type)
            nbytes = n * self.sizes(type);
            out = typecast(self.take(nbytes), type);
        end
        
        function write(self, data)
            self.push(typecast(data, 'uint8'));
        end
    end
    
    methods (Access = private)
        function bs = take(self, nbytes)
            if nbytes == 0, bs = uint8([]); return, end
            bs = self.bytes(1:nbytes);
            self.bytes(1:nbytes) = [];
        end
        
        function push(self, bs)
            self.bytes = [self.bytes, reshape(bs, 1, [])];
        end
    end
end

