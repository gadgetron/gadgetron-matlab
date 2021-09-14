
function bucket_recon(connection)
    disp("Matlab bucket reconstruction running.") 

    next = gadgetron.examples.steps.create_slice_from_bucket(@connection.next, connection.header);        
    next = gadgetron.examples.steps.basic_reconstruction(next);
    next = gadgetron.examples.steps.combine_channels(next);
    next = gadgetron.examples.steps.create_ismrmrd_image(next, connection.header);
    next = gadgetron.examples.steps.set_image_index(next);
    next = gadgetron.examples.steps.send_image_to_client(next, connection);
    
    tic, gadgetron.consume(next); toc
end
