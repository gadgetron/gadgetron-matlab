function data = cifft(data, dim)
    data = fftshift(ifft(ifftshift(data, dim), [], dim), dim) .* sqrt(size(data, dim));
end
