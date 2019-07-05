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
    write(socket, header.version);
    write(socket, header.data_type);
    write(socket, header.flags);
    write(socket, header.measurement_uid);
    write(socket, header.matrix_size);
    write(socket, header.field_of_view);
    write(socket, header.channels);
    write(socket, header.position);
    write(socket, header.read_dir);
    write(socket, header.phase_dir);
    write(socket, header.slice_dir);
    write(socket, header.patient_table_position);
    write(socket, header.average);
    write(socket, header.slice);
    write(socket, header.contrast);
    write(socket, header.phase);
    write(socket, header.repetition);
    write(socket, header.set);
    write(socket, header.acquisition_time_stamp);
    write(socket, header.physiology_time_stamp);
    write(socket, header.image_type);
    write(socket, header.image_index);
    write(socket, header.image_series_index);
    write(socket, header.user_int);
    write(socket, header.user_float);
    write(socket, header.attribute_string_len);
end

function write_attribute_string(socket)
    % We don't support attribute strings at the moment.
    write(socket, uint64(0));
end

function write_data(socket, data)
    write(socket, reshape(data, 1, []));
end