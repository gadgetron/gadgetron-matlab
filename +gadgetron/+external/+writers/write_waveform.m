function writer = write_waveform()
    writer.accepts = @(item) isa(item, 'ismrmrd.Waveform');
    writer.write = @write_acquisition_header_and_data;
end

function write_acquisition_header_and_data(socket, waveform)
    write(socket, ismrmrd.Constants.WAVEFORM);
    write_header(socket, waveform.header);
    write_data(socket, waveform.data);
end

function write_data(socket, data)
    write(socket, reshape(data, 1, []));
end

function write_header(socket, header)
    write(socket, uint16(header.version));
    write(socket, uint64(header.flags));
    write(socket, uint32(header.measurement_uid));
    write(socket, uint32(header.scan_counter));
    write(socket, uint32(header.time_stamp));
    write(socket, uint16(header.number_of_samples));
    write(socket, uint16(header.channels));
    write(socket, single(header.sample_time_us));
    write(socket, uint16(header.waveform_id));
    write(socket, uint8([0 0])); % C-struct is padded; two bytes.
end
