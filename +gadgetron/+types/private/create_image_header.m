function header = create_image_header(data, reference)
    header.version                  = 1;
    header.data_type                = select_data_type(data);
    header.flags                    = 0;
    header.measurement_uid          = reference.measurement_uid;
    header.matrix_size              = [size(data, 2) size(data, 3) size(data, 4)];
    header.field_of_view            = [0 0 0];
    header.channels                 = size(data, 1);

    header.position                 = reference.position;
    header.read_dir                 = reference.read_dir;
    header.phase_dir                = reference.phase_dir;
    header.slice_dir                = reference.slice_dir;
    header.patient_table_position   = reference.patient_table_position;
    
    header.average                  = reference.average;
    header.slice                    = reference.slice;
    header.contrast                 = reference.contrast;
    header.phase                    = reference.phase;
    header.repetition               = reference.repetition;
    header.set                      = reference.set;
    
    header.acquisition_time_stamp   = reference.acquisition_time_stamp;
    header.physiology_time_stamp    = reference.physiology_time_stamp;

    header.image_type               = 0;
    header.image_index              = 0;
    header.image_series_index       = 0;
    
    header.user_int                 = reference.user_int;
    header.user_float               = reference.user_float;

    header.attribute_string_len     = 0;
end

function out = select_data_type(data)
    switch class(data)
        case 'int16'
            out = gadgetron.types.Image.SHORT;
        case 'uint16'
            out = gadgetron.types.Image.USHORT;
        case 'int32'
            out = gadgetron.types.Image.INT;
        case 'uint32'
            out = gadgetron.types.Image.UINT;
        case 'single'
            if isreal(data)
                out = gadgetron.types.Image.FLOAT;
            else
                out = gadgetron.types.Image.CXFLOAT;
            end
        case 'double'
            if isreal(data)
                out = gadgetron.types.Image.DOUBLE;
            else
                out = gadgetron.types.Image.CXDOUBLE;
            end
        otherwise
            error("Unsupported image data type: %s", class(data))
    end
end


    