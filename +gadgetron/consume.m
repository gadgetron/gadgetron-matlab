function consume(next)
    try
        while true
            next();
        end
    catch ME
        if ~strcmp(ME.identifier, 'Connection:noNextItem'), rethrow(ME); end
    end
end

