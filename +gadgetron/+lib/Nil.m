classdef Nil
    methods (Access=public)
        function list = cons(nil, element)
            list = gadgetron.lib.LinkedList(nil, element);
        end
        
        function nil = head(nil), end
        function nil = nth(nil, ~), end
        function nil = tail(nil), end
        function nil = take(nil, ~), end
        function nil = drop(nil, ~), end 
        function N = length(~), N = 0; end
        function tf = isempty(~), tf = true; end
        
        function cell = ascell(~), cell = {}; end
        function array = asarray(~), array = []; end
    end
end

