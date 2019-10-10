classdef Acquisition

    properties (Access = public)
        header
        data 
        trajectory 
    end
    
    methods
        function self = Acquisition(header, data, trajectory)
            self.header = header;
            self.data = data;
            self.trajectory = trajectory;
        end
        
        function tf = isequal(self, other)
            tf = ...
                isequal(self.header, other.header) && ...
                isequal(self.data, other.data) && ...
                isequal(self.trajectory, other.trajectory);
        end
        
        function tf = is_flag_set(self, flag)
            tf = bitand(self.header.flags, flag);
        end
    end
end

