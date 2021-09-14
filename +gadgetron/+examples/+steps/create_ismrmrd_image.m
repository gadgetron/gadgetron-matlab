function next = create_ismrmrd_image(input, header)

    function image = create_image(image)        
        image = gadgetron.types.Image.from_data(image.data, image.reference);
        image.header.image_type = gadgetron.types.Image.MAGNITUDE;
        image.header.field_of_view = [ ...
            header.encoding.reconSpace.fieldOfView_mm.x, ...
            header.encoding.reconSpace.fieldOfView_mm.y, ...
            header.encoding.reconSpace.fieldOfView_mm.z  ...
        ];
    end

    next = @() create_image(input());
end
