function bytes = encode_acquisition_headers(headers)

    nheaders = numel(headers.version);
    bytes = zeros(340, nheaders, 'int8');

    function bytes = byte_view(array, width)
        bytes = reshape( ...
            typecast(squeeze(reshape(array, 1, [])), 'int8'), ...
            width, [] ...
            );
    end
    
    bytes(  1:  2, :) = byte_view(headers.version,          2);
    bytes(  3:  10, :) = byte_view(headers.flags,           8);
    bytes( 11:  14, :) = byte_view(headers.measurement_uid, 4);
    bytes( 15:  18, :) = byte_view(headers.scan_counter,    4);
    bytes( 19:  22, :) = byte_view(headers.acquisition_time_stamp,    4);
    bytes( 23:  34, :) = byte_view(headers.physiology_time_stamp(:),    4*3);
    bytes( 35:  36, :) = byte_view(headers.number_of_samples,    2);
    bytes( 37:  38, :) = byte_view(headers.available_channels,    2);
    bytes( 39:  40, :) = byte_view(headers.active_channels,    2);
    bytes( 41:  168, :) = byte_view(headers.channel_mask,    8*16);
    bytes( 169:  170, :) = byte_view(headers.discard_pre,    2);
    bytes( 171:  172, :) = byte_view(headers.discard_post,    2);  
    bytes( 173:  174, :) = byte_view(headers.center_sample,    2);
    bytes( 175:  176, :) = byte_view(headers.encoding_space_ref,    2);
    bytes( 177:  178, :) = byte_view(headers.trajectory_dimensions,    2);
    bytes( 179:  182, :) = byte_view(headers.sample_time_us,    4);
    bytes( 183:  194, :) = byte_view(headers.position,    4*3);
    bytes( 195:  206, :) = byte_view(headers.read_dir,    4*3);
    bytes( 207:  218, :) = byte_view(headers.phase_dir,    4*3);
    bytes( 219:  230, :) = byte_view(headers.slice_dir,    4*3);
    bytes( 231:  242, :) = byte_view(headers.patient_table_position,    4*3);
    bytes( 243:  244, :) = byte_view(headers.kspace_encode_step_1,    2);
    bytes( 245:  246, :) = byte_view(headers.kspace_encode_step_2,    2);
    bytes( 247:  248, :) = byte_view(headers.average,    2);
    bytes( 249:  250, :) = byte_view(headers.slice,    2);
    bytes( 251:  252, :) = byte_view(headers.contrast,    2);
    bytes( 253:  254, :) = byte_view(headers.phase,    2);
    bytes( 255:  256, :) = byte_view(headers.repetition,    2);
    bytes( 257:  258, :) = byte_view(headers.set,    2);
    bytes( 259:  260, :) = byte_view(headers.segment,    2);
    bytes( 261:  276, :) = byte_view(headers.user,    2*8);
    bytes( 277:  308, :) = byte_view(headers.user_int,    4*8);
    bytes( 309:  340, :) = byte_view(headers.user_float,    4*8);
    
    bytes = reshape(bytes, 1, []);
end
