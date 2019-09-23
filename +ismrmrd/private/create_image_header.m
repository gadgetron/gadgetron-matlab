function header = create_image_header(data, reference)
    header.version                  = uint16(1);
    header.data_type                = uint16(select_data_type(data));
    header.flags                    = uint64(0);
    header.measurement_uid          = uint32(reference.measurement_uid);
    header.matrix_size              = uint16([size(data, 2) size(data, 3) size(data, 4)]);
    header.field_of_view            = single([0 0 0]);
    header.channels                 = uint16(size(data, 1));
    
    header.position                 = single(reference.position);
    header.read_dir                 = single(reference.read_dir);
    header.phase_dir                = single(reference.phase_dir);
    header.slice_dir                = single(reference.slice_dir);
    header.patient_table_position   = single(reference.patient_table_position);

    header.average                  = uint16(0);
    header.slice                    = uint16(reference.idx.slice);
    header.contrast                 = uint16(0);
    header.phase                    = uint16(0);
    header.repetition               = uint16(0);
    header.set                      = uint16(0);

    header.acquisition_time_stamp   = uint32(reference.acquisition_time_stamp);
    header.physiology_time_stamp    = uint32(reference.physiology_time_stamp);

    header.image_type               = uint16(0);
    header.image_index              = uint16(0);
    header.image_series_index       = uint16(0);

    header.user_int                 = int32(reference.user_int);
    header.user_float               = single(reference.user_float);

    header.attribute_string_len     = uint32(0);
end

function out = select_data_type(data)
    switch class(data)
        case 'int16'
            out = ismrmrd.Image.SHORT;
        case 'uint16'
            out = ismrmrd.Image.USHORT;
        case 'int32'
            out = ismrmrd.Image.INT;
        case 'uint32'
            out = ismrmrd.Image.UINT;
        case 'single'
            if isreal(data)
                out = ismrmrd.Image.FLOAT;
            else
                out = ismrmrd.Image.CXFLOAT;
            end
        case 'double'
            if isreal(data)
                out = ismrmrd.Image.DOUBLE;
            else
                out = ismrmrd.Image.CXDOUBLE;
            end
        otherwise
            error("Unsupported image data type: %s", class(data))
    end
end


    