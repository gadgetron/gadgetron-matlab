function data = cifftn(data, dims)
    for dim = dims, data = gadgetron.lib.fft.cifft(data, dim); end
end
