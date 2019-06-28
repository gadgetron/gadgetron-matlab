function acquisition = read_acquisition(socket)
    header = fromBytes(read(socket, 340)');

    acquisition = ismrmrd.Acquisition(header);
    acquisition.trajectory = read_trajectory(socket, header);
    acquisition.data = read_data(socket, header);
end

function trajectory = read_trajectory(socket, header)
    N = uint64(header.number_of_samples) * uint64(header.trajectory_dimensions);
    trajectory = reshape( ...
        read(socket, double(N), 'single'), ...
        header.number_of_samples, ...
        header.trajectory_dimensions ...
    );
end

function data = read_data(socket, header)
    N = uint64(header.active_channels) * uint64(header.number_of_samples) * 2;
    % Read explodes when provided N as uint64 input. 'cause of course it does.
    data = read(socket, double(N), 'single');
    data = reshape( ...
        data, ...
        header.active_channels, ...
        header.number_of_samples, ...
        2 ...
    );
    data = complex( ...
        data(:, :, 1), ...
        data(:, :, 2) ...
    );
end

function obj = fromBytes(bytes)
    % Convert from a byte array to an ISMRMRD AcquisitionHeader
    % This conforms to the memory layout of the C-struct

    if size(bytes,1) ~= 340
        error('Wrong number of bytes for AcquisitionHeader.')
    end
    N = size(bytes,2);
    
    obj.version =                  reshape(typecast(reshape(bytes(  1:   2, :), 1, 2 *      N), 'uint16'),  1, N);  % First unsigned int indicates the version %
    obj.flags =                    reshape(typecast(reshape(bytes(  3:  10, :), 1, 8 *      N), 'uint64'),  1, N);  % bit field with flags %
    obj.measurement_uid =          reshape(typecast(reshape(bytes(  11: 14, :), 1, 4 *      N), 'uint32'),  1, N);  % Unique ID for the measurement %
    obj.scan_counter =             reshape(typecast(reshape(bytes(  15: 18, :), 1, 4 *      N), 'uint32'),  1, N);  % Current acquisition number in the measurement %
    obj.acquisition_time_stamp =   reshape(typecast(reshape(bytes(  19: 22, :), 1, 4 *      N), 'uint32'),  1, N);  % Acquisition clock %
    obj.physiology_time_stamp =    reshape(typecast(reshape(bytes(  23: 34, :), 1, 4 *  3 * N), 'uint32'),  3, N);  % Physiology time stamps, e.g. ecg, breating, etc. %
    obj.number_of_samples =        reshape(typecast(reshape(bytes(  35: 36, :), 1, 2 *      N), 'uint16'),  1, N);  % Number of samples acquired %
    obj.available_channels =       reshape(typecast(reshape(bytes(  37: 38, :), 1, 2 *      N), 'uint16'),  1, N);  % Available coils %
    obj.active_channels =          reshape(typecast(reshape(bytes(  39: 40, :), 1, 2 *      N), 'uint16'),  1, N);  % Active coils on current acquisiton %
    obj.channel_mask =             reshape(typecast(reshape(bytes(  41:168, :), 1, 8 * 16 * N), 'uint64'), 16, N);  % Mask to indicate which channels are active. Support for 1024 channels %
    obj.discard_pre =              reshape(typecast(reshape(bytes( 169:170, :), 1, 2 *      N), 'uint16'),  1, N);  % Samples to be discarded at the beginning of acquisition %
    obj.discard_post =             reshape(typecast(reshape(bytes( 171:172, :), 1, 2 *      N), 'uint16'),  1, N);  % Samples to be discarded at the end of acquisition %
    obj.center_sample =            reshape(typecast(reshape(bytes( 173:174, :), 1, 2 *      N), 'uint16'),  1, N);  % Sample at the center of k-space %
    obj.encoding_space_ref =       reshape(typecast(reshape(bytes( 175:176, :), 1, 2 *      N), 'uint16'),  1, N);  % Reference to an encoding space, typically only one per acquisition %
    obj.trajectory_dimensions =    reshape(typecast(reshape(bytes( 177:178, :), 1, 2 *      N), 'uint16'),  1, N);  % Indicates the dimensionality of the trajectory vector (0 means no trajectory) %
    obj.sample_time_us =           reshape(typecast(reshape(bytes( 179:182, :), 1, 4 *      N), 'single'),  1, N);  % Time between samples in micro seconds, sampling BW %
    obj.position =                 reshape(typecast(reshape(bytes( 183:194, :), 1, 4 *  3 * N), 'single'),  3, N);  % Three-dimensional spatial offsets from isocenter %
    obj.read_dir =                 reshape(typecast(reshape(bytes( 195:206, :), 1, 4 *  3 * N), 'single'),  3, N);  % Directional cosines of the readout/frequency encoding %
    obj.phase_dir =                reshape(typecast(reshape(bytes( 207:218, :), 1, 4 *  3 * N), 'single'),  3, N);  % Directional cosines of the phase encoding %
    obj.slice_dir =                reshape(typecast(reshape(bytes( 219:230, :), 1, 4 *  3 * N), 'single'),  3, N);  % Directional cosines of the slice %
    obj.patient_table_position =   reshape(typecast(reshape(bytes( 231:242, :), 1, 4 *  3 * N), 'single'),  3, N);  % Patient table off-center %
    obj.idx.kspace_encode_step_1 = reshape(typecast(reshape(bytes( 243:244, :), 1, 2 *      N), 'uint16'),  1, N);  % phase encoding line number %
    obj.idx.kspace_encode_step_2 = reshape(typecast(reshape(bytes( 245:246, :), 1, 2 *      N), 'uint16'),  1, N);  % partition encodning number %
    obj.idx.average =              reshape(typecast(reshape(bytes( 247:248, :), 1, 2 *      N), 'uint16'),  1, N);  % signal average number %
    obj.idx.slice =                reshape(typecast(reshape(bytes( 249:250, :), 1, 2 *      N), 'uint16'),  1, N);  % imaging slice number %
    obj.idx.contrast =             reshape(typecast(reshape(bytes( 251:252, :), 1, 2 *      N), 'uint16'),  1, N);  % echo number in multi-echo %
    obj.idx.phase =                reshape(typecast(reshape(bytes( 253:254, :), 1, 2 *      N), 'uint16'),  1, N);  % cardiac phase number %
    obj.idx.repetition =           reshape(typecast(reshape(bytes( 255:256, :), 1, 2 *      N), 'uint16'),  1, N);  % dynamic number for dynamic scanning %
    obj.idx.set =                  reshape(typecast(reshape(bytes( 257:258, :), 1, 2 *      N), 'uint16'),  1, N);  % flow encoding set %
    obj.idx.segment =              reshape(typecast(reshape(bytes( 259:260, :), 1, 2 *      N), 'uint16'),  1, N);  % segment number for segmented acquisition %
    obj.idx.user =                 reshape(typecast(reshape(bytes( 261:276, :), 1, 2 *  8 * N), 'uint16'),  8, N);  % Free user parameters %
    obj.user_int =                 reshape(typecast(reshape(bytes( 277:308, :), 1, 4 *  8 * N), 'int32' ),  8, N);  % Free user parameters %
    obj.user_float =               reshape(typecast(reshape(bytes( 309:340, :), 1, 4 *  8 * N), 'single'),  8, N);  % Free user parameters %
end

function bytes = toBytes(obj)
    % Convert to an ISMRMRD AcquisitionHeader to a byte array
    % This conforms to the memory layout of the C-struct

    N = obj.getNumber;
    bytes = zeros(340,N,'uint8');
    for p = 1:N
        off = 1;
        bytes(off:off+1,p)   = typecast(obj.version(p)               ,'uint8'); off=off+2;
        bytes(off:off+7,p)   = typecast(obj.flags(p)                 ,'uint8'); off=off+8;
        bytes(off:off+3,p)   = typecast(obj.measurement_uid(p)       ,'uint8'); off=off+4;
        bytes(off:off+3,p)   = typecast(obj.scan_counter(p)          ,'uint8'); off=off+4;
        bytes(off:off+3,p)   = typecast(obj.acquisition_time_stamp(p),'uint8'); off=off+4;
        bytes(off:off+11,p)  = typecast(obj.physiology_time_stamp(:,p) ,'uint8'); off=off+12;
        bytes(off:off+1,p)   = typecast(obj.number_of_samples(p)     ,'uint8'); off=off+2;
        bytes(off:off+1,p)   = typecast(obj.available_channels(p)    ,'uint8'); off=off+2;
        bytes(off:off+1,p)   = typecast(obj.active_channels(p)       ,'uint8'); off=off+2;
        bytes(off:off+127,p) = typecast(obj.channel_mask(:,p)        ,'uint8'); off=off+128;
        bytes(off:off+1,p)   = typecast(obj.discard_pre(p)           ,'uint8'); off=off+2;
        bytes(off:off+1,p)   = typecast(obj.discard_post(p)          ,'uint8'); off=off+2;
        bytes(off:off+1,p)   = typecast(obj.center_sample(p)         ,'uint8'); off=off+2;
        bytes(off:off+1,p)   = typecast(obj.encoding_space_ref(p)    ,'uint8'); off=off+2;
        bytes(off:off+1,p)   = typecast(obj.trajectory_dimensions(p) ,'uint8'); off=off+2;
        bytes(off:off+3,p)   = typecast(obj.sample_time_us(p)        ,'uint8'); off=off+4;
        bytes(off:off+11,p)  = typecast(obj.position(:,p)            ,'uint8'); off=off+12;
        bytes(off:off+11,p)  = typecast(obj.read_dir(:,p)            ,'uint8'); off=off+12;
        bytes(off:off+11,p)  = typecast(obj.phase_dir(:,p)           ,'uint8'); off=off+12;
        bytes(off:off+11,p)  = typecast(obj.slice_dir(:,p)           ,'uint8'); off=off+12;
        bytes(off:off+11,p)  = typecast(obj.patient_table_position(:,p),'uint8'); off=off+12;
        bytes(off:off+1,p)   = typecast(obj.idx.kspace_encode_step_1(p),'uint8'); off=off+2;
        bytes(off:off+1,p)   = typecast(obj.idx.kspace_encode_step_2(p),'uint8'); off=off+2;
        bytes(off:off+1,p)   = typecast(obj.idx.average(p)           ,'uint8'); off=off+2;
        bytes(off:off+1,p)   = typecast(obj.idx.slice(p)             ,'uint8'); off=off+2;
        bytes(off:off+1,p)   = typecast(obj.idx.contrast(p)          ,'uint8'); off=off+2;
        bytes(off:off+1,p)   = typecast(obj.idx.phase(p)             ,'uint8'); off=off+2;
        bytes(off:off+1,p)   = typecast(obj.idx.repetition(p)        ,'uint8'); off=off+2;
        bytes(off:off+1,p)   = typecast(obj.idx.set(p)               ,'uint8'); off=off+2;
        bytes(off:off+1,p)   = typecast(obj.idx.segment(p)           ,'uint8'); off=off+2;
        bytes(off:off+15,p)  = typecast(obj.idx.user(:,p)            ,'uint8'); off=off+16;
        bytes(off:off+31,p)  = typecast(obj.user_int(:,p)            ,'uint8'); off=off+32;
        bytes(off:off+31,p)  = typecast(obj.user_float(:,p)          ,'uint8');
    end
end