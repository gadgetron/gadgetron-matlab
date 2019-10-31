function waveform = read_waveform(socket)

    header = gadgetron.external.readers.parse_waveform_headers(read(socket, 40, 'uint8'), 1);        
    data = read_data(socket, header);

    waveform = ismrmrd.Waveform(header, data);
end

function data = read_data(socket, header)   
    N = int32(header.number_of_samples) * int32(header.channels);
    data = reshape( ...
        read(socket, N, 'uint32'), ...
        header.number_of_samples, ...
        header.channels ...
    );
end

