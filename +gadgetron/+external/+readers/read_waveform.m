function waveform = read_waveform(socket)

    
    header = gadgetron.external.readers.parse_waveform_headers(read(socket, 340, 'uint8'), 1);
    
    
    trajectory = read_trajectory(socket, header); 
    data = read_data(socket, header);
    acquisition = ismrmrd.Acquisition(header, data, trajectory);


end

