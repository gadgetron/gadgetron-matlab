function data = cifft(data, dim)
    data = ifftshift(ifft(fftshift(data, dim), [], dim), dim) .* sqrt(size(data, dim));
end
