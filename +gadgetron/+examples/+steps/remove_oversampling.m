function next = remove_oversampling(input, header)

    encoding_space = header.encoding.encodedSpace.matrixSize;
    recon_space = header.encoding.reconSpace.matrixSize;

    if encoding_space.x == recon_space.x, next = input; return, end

    x0 = (encoding_space.x - recon_space.x) / 2 + 1;
    x1 = (encoding_space.x - recon_space.x) / 2 + recon_space.x;
    along_x_dimension = 1;
    
    function acquisition = remove_oversampling(acquisition)
        x_space = gadgetron.lib.fft.cifft(acquisition.data, along_x_dimension); 
        x_space = x_space(x0:x1, :);
        acquisition.header.number_of_samples = recon_space.x;
        acquisition.header.center_sample = recon_space.x / 2;
        acquisition.data = gadgetron.lib.fft.cfft(x_space, along_x_dimension);
    end

    next = @() remove_oversampling(input());
end
