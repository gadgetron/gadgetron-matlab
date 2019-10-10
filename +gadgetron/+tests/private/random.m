function out = random(type, varargin)
    switch type
        case 'single'
            out = rand(varargin{:}, type);
        case 'double'
            out = rand(varargin{:}, type);
        case 'int64'
            out = rand_bigint(type, varargin{:});
        case 'uint64'
            out = rand_bigint(type, varargin{:});
        otherwise
            out = rand_int(type, varargin{:});
    end
end

function rnd = rand_int(type, varargin)
    rnd = randi(intmax(type), varargin{:}, type);
end

function rnd = rand_bigint(type, varargin)
    % I don't have words for how unpleasant this is. randi doesn't
    % recognize 'uint64' (or 'int64'), and will not create them.
    raw = rand_int('uint32', 2, varargin{:});
    rnd = typecast(reshape(raw, 1, []), type);
end
