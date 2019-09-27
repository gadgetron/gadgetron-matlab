function IDEAL(connection)

    % These could potentially be read from connection.config, but I'm
    % pretty lazy.
    frequencies = [392.0 267.0 177.0 0.0 -324.0];

    next = gadgetron.examples.steps.separate_chemical_species(@connection.next, connection.header, frequencies);
    next = gadgetron.examples.steps.send_recon_data_to_client(next, connection);
    
    connection.filter('gadgetron.types.ReconData');
    
    tic; gadgetron.consume(next); toc
end
