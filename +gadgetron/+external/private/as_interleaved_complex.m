function cplx = as_interleaved_complex(raw)
    cplx = complex(raw(1:2:end), raw(2:2:end));
end
