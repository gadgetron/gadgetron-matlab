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
            total_bytes_to_read = double(n) * self.sizes(type);
                        
            % Java can only have around 2^31 elements in an array. If we're
            % reading something larger, we need to read it in chunks. 
            array_size_limit = double(intmax('int32')) - 8; % Java uses a few words for array header stuff.            
            bytes = zeros(total_bytes_to_read, 1, 'int8');
                        
            current_index = 0;
            
            while current_index < total_bytes_to_read
                nbytes = min(total_bytes_to_read - current_index, array_size_limit);
                next_index = current_index + nbytes;
                bytes(current_index + 1:next_index) = read(self.sock, int32(nbytes));
                current_index = next_index;
            end
            
            out = typecast(bytes, type);
        end
        
        function write(self, data)
            write(self.sock, typecast(data, 'int8'));
        end
    end
end

