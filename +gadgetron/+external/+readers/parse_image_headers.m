
function headers = parse_image_headers(bytes, dims)

    

    % All right, 198 bytes in a header. Let's see- what's this?
    

end



function fromBytes(obj, bytearray)
    % Convert from a byte array to an ISMRMRD ImageHeader
    % This conforms to the memory layout of the C-struct
    if size(bytearray,1) ~= 198
        error('Wrong number of bytes for ImageHeader.')
    end
    N = size(bytearray,2);
    for p = 1:N
        obj.version(p)                  = typecast(bytearray(1:2,p),     'uint16');
        obj.data_type(p)                = typecast(bytearray(3:4,p),     'uint16');
        obj.flags(p)                    = typecast(bytearray(5:12,p),    'uint64');
        obj.measurement_uid(p)          = typecast(bytearray(13:16,p),   'uint32');
        obj.matrix_size(:,p)            = typecast(bytearray(17:22,p),   'uint16');
        obj.field_of_view(:,p)          = typecast(bytearray(23:34,p),   'single');
        obj.channels(p)                 = typecast(bytearray(35:36,p),   'uint16');
        obj.position(:,p)               = typecast(bytearray(37:48,p),   'single');
        obj.read_dir(:,p)               = typecast(bytearray(49:60,p),   'single');
        obj.phase_dir(:,p)              = typecast(bytearray(61:72,p),   'single');
        obj.slice_dir(:,p)              = typecast(bytearray(73:84,p),   'single');
        obj.patient_table_position(:,p) = typecast(bytearray(85:96,p),   'single');
        obj.average(p)                  = typecast(bytearray(97:98,p),   'uint16');
        obj.slice(p)                    = typecast(bytearray(99:100,p),  'uint16');
        obj.contrast(p)                 = typecast(bytearray(101:102,p), 'uint16');
        obj.phase(p)                    = typecast(bytearray(103:104,p), 'uint16');
        obj.repetition(p)               = typecast(bytearray(105:106,p), 'uint16');
        obj.set(p)                      = typecast(bytearray(107:108,p), 'uint16');
        obj.acquisition_time_stamp(p)   = typecast(bytearray(109:112,p), 'uint32');
        obj.physiology_time_stamp(:,p)  = typecast(bytearray(113:124,p), 'uint32');                                                          
        obj.image_type(p)               = typecast(bytearray(125:126,p), 'uint16');
        obj.image_index(p)              = typecast(bytearray(127:128,p), 'uint16');
        obj.image_series_index(p)       = typecast(bytearray(129:130,p), 'uint16');
        obj.user_int(:,p)               = typecast(bytearray(131:162,p), 'uint32');
        obj.user_float(:,p)             = typecast(bytearray(163:194,p), 'single');
        obj.attribute_string_len        = typecast(bytearray(195:198,p), 'uint32');

    end              
end