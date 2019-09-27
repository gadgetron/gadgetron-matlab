function data = cfft(data, dim)
    data = fftshift(fft(ifftshift(data, dim), [], dim), dim) ./ sqrt(size(data, dim));
end
