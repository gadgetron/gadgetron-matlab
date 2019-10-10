function writer = write_recon_data()
    writer.accepts = @(item) isa(item, 'ismrmrd.Image');
    writer.write = @write_recondata_to_socket;
end

function write_recon_data_to_socket(socket, recon_data)

end
