function data = cfft(data, dim)
    data = ifftshift(fft(fftshift(data, dim), [], dim), dim) ./ sqrt(size(data, dim));
end
