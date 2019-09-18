function next = create_ismrmrd_image(input)

    function image = create_image(image)
        image = ismrmrd.Image.from_data(image.data, image.acquisition);
        image.header.data_type = ismrmrd.Image.DOUBLE;
        image.header.image_type = ismrmrd.Image.MAGNITUDE;
    end

    next = @() create_image(input());
end
