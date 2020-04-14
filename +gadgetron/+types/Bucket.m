classdef Bucket
    
    properties 
        data
        reference
        waveforms
    end
    
    properties (Dependent)
        ref
    end
    
    methods 
        function self = Bucket(data, reference, waveforms)
            self.data = data;
            self.reference = reference;
            self.waveforms = waveforms;
        end
    end    
    
    methods
        function reference = get.ref(self)
            reference = self.reference;
        end
        
        function self = set.ref(self, value)
            self.reference = value;
        end        
    end
end
