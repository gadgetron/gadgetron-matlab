function bytes = encode_acquisition_headers(headers)

    nheaders = numel(headers.version);

    bytes = zeros(340, nheaders, 'int8');

    function bytes = byte_view(array)
        bytes = typecast(reshape(array, 1, nheaders, []), 'int8');
    end
    
    bytes(  1:  2, :) = byte_view(headers.version);
end



function headers = decode_acquisition_headers(bytes, dims)
    % Convert from a byte array to a ISMRMRD AcquisitionHeaders
    % This conforms to the memory layout of the C-struct

    bytes = reshape(bytes, 340, []);
    N = size(bytes, 2);            
    dims = num2cell(dims);

    headers.version =                  reshape(typecast(reshape(bytes(  1:   2, :), 1, 2 *      N), 'uint16'), dims{:},  1);  % First unsigned int indicates the version %
    headers.flags =                    reshape(typecast(reshape(bytes(  3:  10, :), 1, 8 *      N), 'uint64'), dims{:},  1);  % bit field with flags %
    headers.measurement_uid =          reshape(typecast(reshape(bytes(  11: 14, :), 1, 4 *      N), 'uint32'), dims{:},  1);  % Unique ID for the measurement %
    headers.scan_counter =             reshape(typecast(reshape(bytes(  15: 18, :), 1, 4 *      N), 'uint32'), dims{:},  1);  % Current acquisition number in the measurement %
    headers.acquisition_time_stamp =   reshape(typecast(reshape(bytes(  19: 22, :), 1, 4 *      N), 'uint32'), dims{:},  1);  % Acquisition clock %
    headers.physiology_time_stamp =    reshape(typecast(reshape(bytes(  23: 34, :), 1, 4 *  3 * N), 'uint32'), dims{:},  3);  % Physiology time stamps, e.g. ecg, breating, etc. %
    headers.number_of_samples =        reshape(typecast(reshape(bytes(  35: 36, :), 1, 2 *      N), 'uint16'), dims{:},  1);  % Number of samples acquired %
    headers.available_channels =       reshape(typecast(reshape(bytes(  37: 38, :), 1, 2 *      N), 'uint16'), dims{:},  1);  % Available coils %
    headers.active_channels =          reshape(typecast(reshape(bytes(  39: 40, :), 1, 2 *      N), 'uint16'), dims{:},  1);  % Active coils on current acquisiton %
    headers.channel_mask =             reshape(typecast(reshape(bytes(  41:168, :), 1, 8 * 16 * N), 'uint64'), dims{:}, 16);  % Mask to indicate which channels are active. Support for 1024 channels %
    headers.discard_pre =              reshape(typecast(reshape(bytes( 169:170, :), 1, 2 *      N), 'uint16'), dims{:},  1);  % Samples to be discarded at the beginning of acquisition %
    headers.discard_post =             reshape(typecast(reshape(bytes( 171:172, :), 1, 2 *      N), 'uint16'), dims{:},  1);  % Samples to be discarded at the end of acquisition %
    headers.center_sample =            reshape(typecast(reshape(bytes( 173:174, :), 1, 2 *      N), 'uint16'), dims{:},  1);  % Sample at the center of k-space %
    headers.encoding_space_ref =       reshape(typecast(reshape(bytes( 175:176, :), 1, 2 *      N), 'uint16'), dims{:},  1);  % Reference to an encoding space, typically only one per acquisition %
    headers.trajectory_dimensions =    reshape(typecast(reshape(bytes( 177:178, :), 1, 2 *      N), 'uint16'), dims{:},  1);  % Indicates the dimensionality of the trajectory vector (0 means no trajectory) %
    headers.sample_time_us =           reshape(typecast(reshape(bytes( 179:182, :), 1, 4 *      N), 'single'), dims{:},  1);  % Time between samples in micro seconds, sampling BW %
    headers.position =                 reshape(typecast(reshape(bytes( 183:194, :), 1, 4 *  3 * N), 'single'), dims{:},  3);  % Three-dimensional spatial offsets from isocenter %
    headers.read_dir =                 reshape(typecast(reshape(bytes( 195:206, :), 1, 4 *  3 * N), 'single'), dims{:},  3);  % Directional cosines of the readout/frequency encoding %
    headers.phase_dir =                reshape(typecast(reshape(bytes( 207:218, :), 1, 4 *  3 * N), 'single'), dims{:},  3);  % Directional cosines of the phase encoding %
    headers.slice_dir =                reshape(typecast(reshape(bytes( 219:230, :), 1, 4 *  3 * N), 'single'), dims{:},  3);  % Directional cosines of the slice %
    headers.patient_table_position =   reshape(typecast(reshape(bytes( 231:242, :), 1, 4 *  3 * N), 'single'), dims{:},  3);  % Patient table off-center %
    headers.kspace_encode_step_1 =     reshape(typecast(reshape(bytes( 243:244, :), 1, 2 *      N), 'uint16'), dims{:},  1);  % phase encoding line number %
    headers.kspace_encode_step_2 =     reshape(typecast(reshape(bytes( 245:246, :), 1, 2 *      N), 'uint16'), dims{:},  1);  % partition encodning number %
    headers.average =                  reshape(typecast(reshape(bytes( 247:248, :), 1, 2 *      N), 'uint16'), dims{:},  1);  % signal average number %
    headers.slice =                    reshape(typecast(reshape(bytes( 249:250, :), 1, 2 *      N), 'uint16'), dims{:},  1);  % imaging slice number %
    headers.contrast =                 reshape(typecast(reshape(bytes( 251:252, :), 1, 2 *      N), 'uint16'), dims{:},  1);  % echo number in multi-echo %
    headers.phase =                    reshape(typecast(reshape(bytes( 253:254, :), 1, 2 *      N), 'uint16'), dims{:},  1);  % cardiac phase number %
    headers.repetition =               reshape(typecast(reshape(bytes( 255:256, :), 1, 2 *      N), 'uint16'), dims{:},  1);  % dynamic number for dynamic scanning %
    headers.set =                      reshape(typecast(reshape(bytes( 257:258, :), 1, 2 *      N), 'uint16'), dims{:},  1);  % flow encoding set %
    headers.segment =                  reshape(typecast(reshape(bytes( 259:260, :), 1, 2 *      N), 'uint16'), dims{:},  1);  % segment number for segmented acquisition %
    headers.user =                     reshape(typecast(reshape(bytes( 261:276, :), 1, 2 *  8 * N), 'uint16'), dims{:},  8);  % Free user parameters %
    headers.user_int =                 reshape(typecast(reshape(bytes( 277:308, :), 1, 4 *  8 * N), 'int32' ), dims{:},  8);  % Free user parameters %
    headers.user_float =               reshape(typecast(reshape(bytes( 309:340, :), 1, 4 *  8 * N), 'single'), dims{:},  8);  % Free user parameters %
end
