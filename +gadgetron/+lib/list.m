function l = list(varargin)
    if isempty(varargin), l = gadgetron.lib.Nil; return, end
    args = varargin(2:end);
    l = cons(gadgetron.lib.list(args{:}), varargin{1});
end
