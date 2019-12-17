function writer = write_waveform()
    writer.accepts = @(item) isa(item, 'gadgetron.types.Waveform');
    writer.write = @write_waveform_header_and_data;
end

function write_waveform_header_and_data(socket, waveform)
    write(socket, gadgetron.Constants.WAVEFORM);
    write_header(socket, waveform.header);
    write_data(socket, waveform.data);
end

function write_header(socket, header)
    write(socket, uint16(header.version));
    write(socket, uint8([0 0 0 0 0 0])); % C-struct is padded; six bytes.
    write(socket, uint64(header.flags));
    write(socket, uint32(header.measurement_uid));
    write(socket, uint32(header.scan_counter));
    write(socket, uint32(header.time_stamp));
    write(socket, uint16(header.number_of_samples));
    write(socket, uint16(header.channels));
    write(socket, single(header.sample_time_us));
    write(socket, uint16(header.waveform_id));
    write(socket, uint8([0 0])); % More padding.
end

function write_data(socket, data)
    write(socket, reshape(data, 1, []));
end
