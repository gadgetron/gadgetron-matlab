function writer = write_image()
    writer.accepts = @(item) isa(item, 'ismrmrd.Image');
    writer.write = @write_image_header_and_data;
end

function write_image_header_and_data(socket, image)
    write(socket, ismrmrd.Constants.IMAGE);
    write_header(socket, image.header);
    write_attribute_string(socket);
    write_data(socket, image.data);
end

function write_header(socket, header)   
    write(socket, uint16(header.version));
    write(socket, uint16(header.data_type));
    write(socket, uint64(header.flags));
    write(socket, uint32(header.measurement_uid));
    write(socket, uint16(header.matrix_size));
    write(socket, single(header.field_of_view));
    write(socket, uint16(header.channels));
    write(socket, single(header.position));
    write(socket, single(header.read_dir));
    write(socket, single(header.phase_dir));
    write(socket, single(header.slice_dir));
    write(socket, single(header.patient_table_position));
    write(socket, uint16(header.average));
    write(socket, uint16(header.slice));
    write(socket, uint16(header.contrast));
    write(socket, uint16(header.phase));
    write(socket, uint16(header.repetition));
    write(socket, uint16(header.set));
    write(socket, uint32(header.acquisition_time_stamp));
    write(socket, uint32(header.physiology_time_stamp));
    write(socket, uint16(header.image_type));
    write(socket, uint16(header.image_index));
    write(socket, uint16(header.image_series_index));
    write(socket, int32(header.user_int));
    write(socket, single(header.user_float));
    write(socket, uint32(header.attribute_string_len));
end

function write_attribute_string(socket)
    % We don't support attribute strings at the moment.
    write(socket, uint64(0));
end

function write_data(socket, data)
    write(socket, reshape(data, 1, []));
end