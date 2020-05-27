function next = create_ismrmrd_image(input)
    n=1;
    s=1;
    function imageout = create_image(image)
        %init
        imageout(1,1)=gadgetron.types.Image.from_data(zeros(128),ismrmrd.ImageHeader());
        for n=1:size(image.reference,1)         
            for s=1:size(image.reference,2)
        imageout(n,s) = gadgetron.types.Image.from_data(image.data(:,:,:,:,n,s), image.reference(n,s));
        imageout(n,s).header.image_type = gadgetron.types.Image.MAGNITUDE;
            end
        end
    end

    next = @() create_image(input());
end
