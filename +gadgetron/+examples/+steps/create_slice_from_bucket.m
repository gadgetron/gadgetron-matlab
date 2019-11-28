function next = create_slice_from_bucket(input, header)

    matrix_size = header.encoding.encodedSpace.matrixSize;

    function slice = slice_from_bucket(bucket)
        disp("Assembling buffer from bucket containing " + num2str(bucket.data.count) + " acquisitions");
        
        slice.reference = structfun(@(arr) arr(:, 1)', bucket.data.header, 'UniformOutput', false);
        slice.data = complex(zeros( ...
            size(bucket.data.data, 2), ...
            size(bucket.data.data, 1), ...
            matrix_size.y, ...
            matrix_size.z, ...
            'single' ...
        ));
    
        for i = 1:bucket.data.count
            encode_step_1 = bucket.data.header.kspace_encode_step_1(i);
            encode_step_2 = bucket.data.header.kspace_encode_step_2(i);
            slice.data(:, :, encode_step_1 + 1, encode_step_2 + 1) = ...
                transpose(squeeze(bucket.data.data(:, :, i)));            
        end
    end

    next = @() slice_from_bucket(input());
end

