
classdef Constants   
    properties (Access = public, Constant)
        % Message identifiers
        
        FILENAME      = uint16(1);
        CONFIG        = uint16(2);
        HEADER        = uint16(3);
        CLOSE         = uint16(4);
        TEXT          = uint16(5);
        QUERY         = uint16(6);
        RESPONSE      = uint16(7);
        ERROR         = uint16(8);

        ACQUISITION   = uint16(1008);
        IMAGE         = uint16(1022);

        RECON_DATA    = uint16(1023);
        IMAGE_ARRAY   = uint16(1024);

        WAVEFORM      = uint16(1026);

        BUCKET        = uint16(1050);
        BUNDLE        = uint16(1051);
    end
end
