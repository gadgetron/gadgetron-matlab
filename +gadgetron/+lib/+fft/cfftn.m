function data = cfftn(data, dims)
    for dim = dims, data = gadgetron.lib.fft.cfft(data, dim); end
end
