classdef Segment < handle

    properties (Constant)
        size uint64 = 4096
    end

    properties (GetAccess = public, SetAccess = private)
        bytes uint8
        written uint64
    end
    
    properties (GetAccess = public, Dependent)
        available uint64
    end
    
    methods
        function self = Segment()
            self.bytes = zeros(1, self.size, 'uint8');
            self.written = 0;
        end       
        
        function nbytes = push(self, bytes)
            
            nbytes = numel(bytes);
            
            if nbytes > self.available
                throw(MException('Segment:notEnoughSpace', "Can't push %d bytes, only %d bytes of space available."));
            end
            
            self.bytes(self.written + 1:self.written + nbytes) = bytes;
            self.written = self.written + nbytes;
        end
    end
    
    methods
        function av = get.available(self)
            av = self.size - self.written;
        end
    end
end

