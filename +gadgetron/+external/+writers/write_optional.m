function write_optional(socket, item, write_handler, varargin)
    if isempty(item)
        write(socket, uint8(0));
    else
        write(socket, uint8(1));
        write_handler(socket, item, varargin{:});
    end
end

