classdef LinkedList

    properties (Access = private)
        nxt;
        elm;
    end
    
    methods (Access = public, Static)
        function nil = empty()
            nil = gadgetron.lib.Nil;
        end
    end
        
    
    methods (Access = public)
        
        function list = LinkedList(tail, elm)
            list.nxt = tail;
            list.elm = elm;
        end
        
        function list = cons(list, element)
            list = gadgetron.lib.LinkedList(list, element);
        end
        
        function element = head(list)
            element = list.elm;
        end
        
        function element = nth(list, N)
            list = drop(list, N);
            element = head(list);
        end
        
        function tail = tail(list)
            tail = list.nxt;
        end
        
        function list = take(list, N)
            if N == 0, list = gadgetron.lib.Nil; end
            list = cons(take(tail(list), N - 1), head(list));
        end
        
        function list = drop(list, N)
            if N == 0, return, end
            list = drop(tail(list), N - 1);
        end
        
        function N = length(list)
            N = 1 + length(tail(list));
        end
        
        function tf = isempty(~), tf = false; end
        
        function cell = ascell(list)
            cell = horzcat({head(list)}, ascell(tail(list)));
        end
        
        function array = asarray(list)
            array = horzcat(head(list), asarray(tail(list)));
        end
    end
end

