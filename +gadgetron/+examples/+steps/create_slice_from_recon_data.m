function next = create_slice_from_recon_data(input)

    function slice = create_slice(recon_data)
        slice.reference = structfun(@(arr) arr(:, 1)', recon_data.bits.buffer.headers, 'UniformOutput', false);
        slice.data = permute( ... 
            recon_data.bits.buffer.data, ...
            [4, 1, 2, 3] ...
        );
    end

    next = @() create_slice(input());
end

