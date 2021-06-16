classdef Image
    
    properties (Access = public, Hidden, Constant)
       % Image constants
       USHORT       = uint16(1);
       SHORT        = uint16(2);
       UINT         = uint16(3);
       INT          = uint16(4);
       FLOAT        = uint16(5);
       DOUBLE       = uint16(6);
       CXFLOAT      = uint16(7);
       CXDOUBLE     = uint16(8);
       
       MAGNITUDE    = uint16(1);
       PHASE        = uint16(2);
       REAL         = uint16(3);
       IMAG         = uint16(4);
       COMPLEX      = uint16(5);
    end
    
    properties 
        header
        meta
        data
    end
    
    properties (Dependent, Hidden)
        attribute_string
    end
        
    
    methods
        function self = Image(header, attribute_string, data)
            self.header = header;
            self.attribute_string = attribute_string;
            self.data = data;
        end
    end
    
    methods (Static)
        function image = from_data(data, reference)
            header = create_image_header(data, reference);
            image = gadgetron.types.Image(header, "", data);
        end
    end
    
    methods
        function str = get.attribute_string(self)
            str = gadgetron.types.Meta.to_string(self.meta);
        end
        
        function self = set.attribute_string(self, value)
            self.meta = gadgetron.types.Meta.from_string(value);
        end        
    end
end
