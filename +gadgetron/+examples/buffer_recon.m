function buffer_recon(connection) % 'Buffer' is a colloquial name for Recon Data. 

    next = gadgetron.examples.steps.create_slice_from_recon_data(@connection.next);        
    next = gadgetron.examples.steps.basic_reconstruction(next);
    next = gadgetron.examples.steps.combine_channels(next);
    next = gadgetron.examples.steps.create_ismrmrd_image(next, connection.header);
    next = gadgetron.examples.steps.set_image_index(next);
    next = gadgetron.examples.steps.send_image_to_client(next, connection);

    tic; gadgetron.consume(next); toc
end
 