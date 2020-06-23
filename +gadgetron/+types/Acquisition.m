classdef Acquisition

        properties (Access = public, Hidden, Constant)
        % Acquisition flags
        ACQ_FIRST_IN_ENCODE_STEP1               = bitshift(uint64(1), 0)
        ACQ_LAST_IN_ENCODE_STEP1                = bitshift(uint64(1), 1)
        ACQ_FIRST_IN_ENCODE_STEP2               = bitshift(uint64(1), 2)
        ACQ_LAST_IN_ENCODE_STEP2                = bitshift(uint64(1), 3)
        ACQ_FIRST_IN_AVERAGE                    = bitshift(uint64(1), 4)
        ACQ_LAST_IN_AVERAGE                     = bitshift(uint64(1), 5)
        ACQ_FIRST_IN_SLICE                      = bitshift(uint64(1), 6)
        ACQ_LAST_IN_SLICE                       = bitshift(uint64(1), 7)
        ACQ_FIRST_IN_CONTRAST                   = bitshift(uint64(1), 8)
        ACQ_LAST_IN_CONTRAST                    = bitshift(uint64(1), 9)
        ACQ_FIRST_IN_PHASE                      = bitshift(uint64(1), 10)
        ACQ_LAST_IN_PHASE                       = bitshift(uint64(1), 11)
        ACQ_FIRST_IN_REPETITION                 = bitshift(uint64(1), 12)
        ACQ_LAST_IN_REPETITION                  = bitshift(uint64(1), 13)
        ACQ_FIRST_IN_SET                        = bitshift(uint64(1), 14)
        ACQ_LAST_IN_SET                         = bitshift(uint64(1), 15)
        ACQ_FIRST_IN_SEGMENT                    = bitshift(uint64(1), 16)
        ACQ_LAST_IN_SEGMENT                     = bitshift(uint64(1), 17)
        ACQ_IS_NOISE_MEASUREMENT                = bitshift(uint64(1), 18)
        ACQ_IS_PARALLEL_CALIBRATION             = bitshift(uint64(1), 19)
        ACQ_IS_PARALLEL_CALIBRATION_AND_IMAGING = bitshift(uint64(1), 20)
        ACQ_IS_REVERSE                          = bitshift(uint64(1), 21)
        ACQ_IS_NAVIGATION_DATA                  = bitshift(uint64(1), 22)
        ACQ_IS_PHASECORR_DATA                   = bitshift(uint64(1), 23)
        ACQ_LAST_IN_MEASUREMENT                 = bitshift(uint64(1), 24)
        ACQ_IS_HPFEEDBACK_DATA                  = bitshift(uint64(1), 25)
        ACQ_IS_DUMMYSCAN_DATA                   = bitshift(uint64(1), 26)
        ACQ_IS_RTFEEDBACK_DATA                  = bitshift(uint64(1), 27)
        ACQ_IS_SURFACECOILCORRECTIONSCAN_DATA   = bitshift(uint64(1), 28)
        ACQ_COMPRESSION1                        = bitshift(uint64(1), 52)
        ACQ_COMPRESSION2                        = bitshift(uint64(1), 53)
        ACQ_COMPRESSION3                        = bitshift(uint64(1), 54)
        ACQ_COMPRESSION4                        = bitshift(uint64(1), 55)
        ACQ_USER1                               = bitshift(uint64(1), 56)
        ACQ_USER2                               = bitshift(uint64(1), 57)
        ACQ_USER3                               = bitshift(uint64(1), 58)
        ACQ_USER4                               = bitshift(uint64(1), 59)
        ACQ_USER5                               = bitshift(uint64(1), 60)
        ACQ_USER6                               = bitshift(uint64(1), 61)
        ACQ_USER7                               = bitshift(uint64(1), 62)
        ACQ_USER8                               = bitshift(uint64(1), 63)
    end   
    
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

