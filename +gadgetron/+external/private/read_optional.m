function opt = read_optional(socket, handler, varargin)
    is_present = read(socket, 1, 'uint8') ~= uint8(0);
    if (is_present)
        opt = handler(socket, varargin{:});
    else
        opt = [];
    end
end

