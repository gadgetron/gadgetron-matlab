function next = create_ismrmrd_image(input)

    function image = create_image(image)
        image = gadgetron.types.Image.from_data(image.data, image.reference);
        image.header.image_type = gadgetron.types.Image.MAGNITUDE;
    end

    next = @() create_image(input());
end
