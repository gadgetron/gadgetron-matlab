
function bytes = encode_image_headers(headers)

    nheaders = numel(headers.version);
    bytes = zeros(198, nheaders, 'int8');

    function bytes = byte_view(array, width)
        bytes = reshape( ...
            typecast(squeeze(reshape(array, 1, [])), 'int8'), ...
            width, [] ...
        );
    end
    
    bytes(  1:  2, :) = byte_view(headers.version, 1 * 2);
    bytes(  3:  4, :) = byte_view(headers.data_type, 1 * 2);
    bytes(  5: 12, :) = byte_view(headers.flags, 1 * 8);
    bytes( 13: 16, :) = byte_view(headers.measurement_uid, 1 * 4);
    bytes( 17: 22, :) = byte_view(headers.matrix_size, 3 * 2);
    bytes( 23: 34, :) = byte_view(headers.field_of_view, 3 * 4);
    bytes( 35: 36, :) = byte_view(headers.channels, 1 * 2);
    bytes( 37: 48, :) = byte_view(headers.position, 3 * 4);
    bytes( 49: 60, :) = byte_view(headers.read_dir, 3 * 4);
    bytes( 61: 72, :) = byte_view(headers.phase_dir, 3 * 4);
    bytes( 73: 84, :) = byte_view(headers.slice_dir, 3 * 4);
    bytes( 85: 96, :) = byte_view(headers.patient_table_position, 3 * 4);
    bytes( 97: 98, :) = byte_view(headers.average, 1 * 2);
    bytes( 99:100, :) = byte_view(headers.slice, 1 * 2);
    bytes(101:102, :) = byte_view(headers.contrast, 1 * 2);
    bytes(103:104, :) = byte_view(headers.phase, 1 * 2);
    bytes(105:106, :) = byte_view(headers.repetition, 1 * 2);
    bytes(107:108, :) = byte_view(headers.set, 1 * 2);
    bytes(109:112, :) = byte_view(headers.acquisition_time_stamp, 1 * 4);
    bytes(113:124, :) = byte_view(headers.physiology_time_stamp, 3 * 4);
    bytes(125:126, :) = byte_view(headers.image_type, 1 * 2);
    bytes(127:128, :) = byte_view(headers.image_index, 1 * 2);
    bytes(129:130, :) = byte_view(headers.image_series_index, 1 * 2);
    bytes(131:162, :) = byte_view(headers.user_int, 8 * 4);
    bytes(163:194, :) = byte_view(headers.user_float, 8 * 4);    
    bytes(195:198, :) = byte_view(headers.attribute_string_len, 1 * 4);
    
    bytes = reshape(bytes, 1, []);
end
