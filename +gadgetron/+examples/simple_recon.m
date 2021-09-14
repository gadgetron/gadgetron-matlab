
function simple_recon(connection)

    disp("Matlab reconstruction running.") 
    
    next = gadgetron.examples.steps.noise_adjust(@connection.next, connection.header);
    next = gadgetron.examples.steps.remove_oversampling(next, connection.header);
    next = gadgetron.examples.steps.accumulate_slice(next, connection.header);
    next = gadgetron.examples.steps.basic_reconstruction(next);
    next = gadgetron.examples.steps.combine_channels(next);
    next = gadgetron.examples.steps.create_ismrmrd_image(next, connection.header);
    next = gadgetron.examples.steps.set_image_index(next);
    next = gadgetron.examples.steps.send_image_to_client(next, connection);
    
    connection.filter('gadgetron.types.Acquisition')

    tic, gadgetron.consume(next); toc
end
