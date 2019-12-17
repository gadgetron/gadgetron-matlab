function writer = write_recon_data()
    writer.accepts = @(item) isa(item, 'gadgetron.types.ReconData');
    writer.write = @write_recondata_to_socket;
end

function write_recon_data_to_socket(socket, recon_data)

end
