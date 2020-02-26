classdef Bucket
    
    properties 
        data
        reference
        waveforms
    end
    
    methods 
        function self = Bucket(data, reference, waveforms)
            self.data = data;
            self.reference = reference;
            self.waveforms = waveforms;
        end
    end    
end
