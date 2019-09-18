function next = basic_reconstruction(input)
    
    function slice = reconstruct(slice)
        slice.data = gadgetron.lib.fft.cifftn(slice.data, [2, 3, 4]);
    end

    next = @() reconstruct(input());
end

