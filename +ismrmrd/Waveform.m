classdef Waveform
    
    properties
        header
        data
    end
    
    methods
        function self = Waveform(header, data)
            self.header = header;
            self.data = data;
        end
        
        function tf = isequal(self, other)
            tf = ...
                isequal(self.header, other.header) && ...
                isequal(self.data, other.data);
        end
        
        function tf = is_flag_set(self, flag)
            tf = bitand(self.header.flags, flag);
        end        
    end
end

