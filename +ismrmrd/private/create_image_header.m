function header = create_image_header(data, reference)
    header.version = uint16(1);
    header.flags = uint64(0);

    header.matrix_size = uint16([size(data, 2) size(data, 3) size(data, 4)]);
    header.channels = uint16(size(data, 1));
    
    header.measurement_uid = reference.measurement_uid;
    header.position = reference.position;
    header.read_dir = reference.read_dir;
    header.phase_dir = reference.phase_dir;
    header.slice_dir = reference.slice_dir;
    header.patient_table_position = reference.patient_table_position;
    header.slice = reference.idx.slice;
    header.acquisition_time_stamp = reference.acquisition_time_stamp;
    header.physiology_time_stamp = reference.physiology_time_stamp;
    header.user_int = reference.user_int;
    header.user_float = reference.user_float;

    header.field_of_view = single([0 0 0]);
    header.average = uint16(0);
    header.contrast = uint16(0);
    header.phase = uint16(0);
    header.repetition = uint16(0);
    header.set = uint16(0);
    
    header.data_type = uint16(0);
    header.image_type = uint16(0);

    header.image_index = uint16(0);
    header.image_series_index = uint16(0);
    
    header.attribute_string_len = uint32(0);
end
