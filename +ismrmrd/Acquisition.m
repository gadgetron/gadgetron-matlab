classdef Acquisition
    
    properties (Access = public)
        header
        data 
        trajectory 
    end
    
    methods
        function self = Acquisition(header)
            self.header = header;
        end
        
        function tf = is_flag_set(self, flag)
            tf = bitand(self.header.flags, flag);
        end
    end
end

