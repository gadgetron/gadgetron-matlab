
classdef Constants   
    properties (Access = public, Constant)
        FILENAME      = uint16(1);
        CONFIG        = uint16(2);
        HEADER        = uint16(3);
        CLOSE         = uint16(4);
        TEXT          = uint16(5);
        QUERY         = uint16(6);
        RESPONSE      = uint16(7);
        ERROR         = uint16(8);

        ACQUISITION   = uint16(1008);
        WAVEFORM      = uint16(1026);
        IMAGE         = uint16(1022);

        BUFFER        = uint16(1020);
        IMAGE_ARRAY   = uint16(1021);
    end
end
