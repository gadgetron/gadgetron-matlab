
function headers = decode_image_headers(bytes, dims)

    bytes = reshape(bytes, 198, []);
    N = size(bytes, 2);            
    dims = num2cell(dims);

    headers.version =                  reshape(typecast(reshape(bytes(  1:   2, :), 1, 2 *      N), 'uint16'),  1, dims{:});
    headers.data_type =                reshape(typecast(reshape(bytes(  3:   4, :), 1, 2 *      N), 'uint16'),  1, dims{:});
    headers.flags =                    reshape(typecast(reshape(bytes(  5:  12, :), 1, 8 *      N), 'uint64'),  1, dims{:});
    headers.measurement_uid =          reshape(typecast(reshape(bytes(  13: 16, :), 1, 4 *      N), 'uint32'),  1, dims{:});
    
    headers.matrix_size =              reshape(typecast(reshape(bytes(  17: 22, :), 1, 2 *  3 * N), 'uint16'),  3, dims{:});
    headers.field_of_view =            reshape(typecast(reshape(bytes(  23: 34, :), 1, 4 *  3 * N), 'single'),  3, dims{:});

    headers.channels =                 reshape(typecast(reshape(bytes(  35: 36, :), 1, 2 *      N), 'uint16'),  1, dims{:});
    
    headers.position =                 reshape(typecast(reshape(bytes(  37: 48, :), 1, 4 *  3 * N), 'single'),  3, dims{:});
    headers.read_dir =                 reshape(typecast(reshape(bytes(  49: 60, :), 1, 4 *  3 * N), 'single'),  3, dims{:});
    headers.phase_dir =                reshape(typecast(reshape(bytes(  61: 72, :), 1, 4 *  3 * N), 'single'),  3, dims{:});
    headers.slice_dir =                reshape(typecast(reshape(bytes(  73: 84, :), 1, 4 *  3 * N), 'single'),  3, dims{:});
    headers.patient_table_position =   reshape(typecast(reshape(bytes(  85: 96, :), 1, 4 *  3 * N), 'single'),  3, dims{:});
    
    headers.average =                  reshape(typecast(reshape(bytes(  97: 98, :), 1, 2 *      N), 'uint16'),  1, dims{:});
    headers.slice =                    reshape(typecast(reshape(bytes(  99:100, :), 1, 2 *      N), 'uint16'),  1, dims{:});
    headers.contrast =                 reshape(typecast(reshape(bytes( 101:102, :), 1, 2 *      N), 'uint16'),  1, dims{:});
    headers.phase =                    reshape(typecast(reshape(bytes( 103:104, :), 1, 2 *      N), 'uint16'),  1, dims{:});
    headers.repetition =               reshape(typecast(reshape(bytes( 105:106, :), 1, 2 *      N), 'uint16'),  1, dims{:});
    headers.set =                      reshape(typecast(reshape(bytes( 107:108, :), 1, 2 *      N), 'uint16'),  1, dims{:});

    headers.acquisition_time_stamp =   reshape(typecast(reshape(bytes( 109:112, :), 1, 4 *      N), 'uint32'),  1, dims{:});
    headers.physiology_time_stamp =    reshape(typecast(reshape(bytes( 113:124, :), 1, 4 *  3 * N), 'uint32'),  3, dims{:});

    headers.image_type =               reshape(typecast(reshape(bytes( 125:126, :), 1, 2 *      N), 'uint16'),  1, dims{:});
    headers.image_index =              reshape(typecast(reshape(bytes( 127:128, :), 1, 2 *      N), 'uint16'),  1, dims{:});
    headers.image_series_index =       reshape(typecast(reshape(bytes( 129:130, :), 1, 2 *      N), 'uint16'),  1, dims{:});

    headers.user_int =                 reshape(typecast(reshape(bytes( 131:162, :), 1, 4 *  8 * N), 'int32' ),  8, dims{:});
    headers.user_float =               reshape(typecast(reshape(bytes( 163:194, :), 1, 4 *  8 * N), 'single'),  8, dims{:});
    
    headers.attribute_string_len =     reshape(typecast(reshape(bytes( 195:198, :), 1, 4 *      N), 'uint32'),  1, dims{:});
end
