classdef ByteStream < handle
    
    properties (GetAccess = public, Dependent)
        bytes
    end

    properties (Access = private)
        total_bytes     uint64
        segments        
    end
        
    
    methods
        function self = ByteStream()
            self.segments = gadgetron.lib.list(self.create_segment());            
            self.total_bytes = 0;
        end
        
        function write(self, data)
            self.push_bytes(typecast(reshape(data, 1, []), 'uint8'));
        end
    end
    
    methods
        function bytes = get.bytes(self)
            bytes = zeros(1, self.total_bytes, 'uint8');
            copied = 0;
 
            list = self.segments;
            
            while ~isempty(list)
                segment = head(list);

                bytes(copied + 1:copied + segment.written) = segment.bytes(1:segment.written);
                copied = copied + segment.written;
                
                list = tail(list);
            end
        end
    end
    
    methods (Access = private)
        
        function push_bytes(self, bytes)
            
            while ~isempty(bytes)
                
                nbytes = numel(bytes); current = head(self.segments);
                
                if nbytes <= current.available
                    self.total_bytes = self.total_bytes + current.push(bytes);
                    return;
                end

                push = bytes(1:current.available); bytes = bytes(current.available + 1:end);
                
                self.total_bytes = self.total_bytes + current.push(push);
                self.push_segment(self.create_segment());
            end
        end

        function push_segment(self, segment)
            self.segments = cons(self.segments, segment);
        end
        
        function segment = create_segment(~) 
            segment = gadgetron.external.writers.streams.Segment();
        end
    end
end

