function next = create_slice_from_bucket(input, header)

    matrix_size = header.encoding.encodedSpace.matrixSize;

    function slice = slice_from_bucket(bucket)
        disp("Assembling buffer from bucket containing " + num2str(bucket.data.count) + " acquisitions");
        
        slice.acquisition = ismrmrd.Acquisition(        ...
            single_header(bucket.data.header, 1),       ...
            squeeze(bucket.data.data(:, :, 1)),         ...
            squeeze(bucket.data.trajectory(:, :, 1))    ...
        );
    
        slice.data = complex(zeros( ...
            size(slice.acquisition.data, 2), ...
            size(slice.acquisition.data, 1), ...
            matrix_size.y, ...
            matrix_size.z  ...
        ));
    
        for i = 1:bucket.data.count
            encode_step_1 = bucket.data.header.idx.kspace_encode_step_1(i);
            encode_step_2 = bucket.data.header.idx.kspace_encode_step_2(i);
            slice.data(:, :, encode_step_1 + 1, encode_step_2 + 1) = ...
                transpose(squeeze(bucket.data.data(:, :, i)));            
        end
    end

    next = @() slice_from_bucket(input());
end

function header = single_header(header, index)
    take = @(arr) arr(:, index);
    header = structfun(take, header, 'UniformOutput', false);
    header.idx = structfun(take, header.idx, 'UniformOutput', false);
end
