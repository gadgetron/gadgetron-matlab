function consume(next, handler, varargin)
    try
        while true
            handler(next(), varargin{:});
        end
    catch ME
        if ~strcmp(ME.identifier, 'Connection:noNextItem'), rethrow(ME); end
    end
end

