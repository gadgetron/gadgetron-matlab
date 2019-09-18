function next = accumulate_slice(input, header)

    matrix_size = header.encoding.encodedSpace.matrixSize;

    function [slice, acquisition] = slice_from_acquisitions(acquisitions)
        disp("Assembling buffer from " + num2str(length(acquisitions)) + " acquisitions");

        acquisition = head(acquisitions);
        
        slice = complex(zeros( ...
            size(acquisition.data, 2), ...
            size(acquisition.data, 1), ...
            matrix_size.y,             ...
            matrix_size.z              ...
        ));
    
        for acq = acquisitions.asarray
            slice(:, :, acq.header.idx.kspace_encode_step_1 + 1, acq.header.idx.kspace_encode_step_2 + 1) = ...
                transpose(acq.data);
        end
    end

    function slice = accumulate()
        
        acquisitions = gadgetron.lib.list();
        
        while true
            acquisition = input();
            acquisitions = cons(acquisitions, acquisition);
            if acquisition.is_flag_set(ismrmrd.Flags.ACQ_LAST_IN_SLICE), break; end
        end
        
        [slice.data, slice.acquisition] = slice_from_acquisitions(acquisitions);
    end

    next = @accumulate;
end
