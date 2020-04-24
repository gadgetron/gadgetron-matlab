function waveform = read_waveform(socket)

    header = gadgetron.external.readers.decode_waveform_headers(read(socket, 40, 'uint8'), 1);        
    data = read_data(socket, header);

    waveform = gadgetron.types.Waveform(header, data);
end

function data = read_data(socket, header)   
    N = header.number_of_samples * header.channels;
    data = reshape( ...
        read(socket, N, 'uint32'), ...
        header.number_of_samples, ...
        header.channels ...
    );
end

