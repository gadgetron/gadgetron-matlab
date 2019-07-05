function l = list(varargin)
    if isempty(varargin), l = gadgetron.util.Nil; return, end
    args = varargin(2:end);
    l = cons(gadgetron.util.list(args{:}), varargin{1});
end
