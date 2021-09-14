function next = set_image_index(input)

    indices = containers.Map('KeyType', 'uint32', 'ValueType', 'uint32');
    
    function index = produce_index(series)
        if indices.isKey(series)        
            index = indices(series) + 1;
        else
            index = 1;
        end
        
        indices(series) = index;
    end
    
    function image = set_image_index(image)
        image.header.image_index = produce_index(image.header.image_series_index);
    end

    next = @() set_image_index(input());
end
