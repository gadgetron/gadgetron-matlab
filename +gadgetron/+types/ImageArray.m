classdef ImageArray
    
    properties
        data
        headers
        meta
        waveform
        acq_headers
    end
    
    methods
        function self = ImageArray(data, headers, meta, waveform, acq_headers)
            self.data = data;
            self.headers = headers;
            self.meta = meta;
            self.waveform = waveform;
            self.acq_headers = acq_headers;            
        end        
    end
end
