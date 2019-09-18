function next = combine_channels(input)

    function x = square(x), x = x .^ 2; end
    function image = combine_channels(image)
        image.data = sqrt(sum(square(abs(image.data)), 1));
    end

    next = @() combine_channels(input());
end

