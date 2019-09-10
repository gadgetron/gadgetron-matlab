function acquisition = read_acquisition(socket)
    header = parse_acquisition_headers(read(socket, 340, 'uint8'));
    trajectory = read_trajectory(socket, header); 
    data = read_data(socket, header);
    acquisition = ismrmrd.Acquisition(header, data, trajectory);
end

function trajectory = read_trajectory(socket, header)
    N = int32(header.number_of_samples) * int32(header.trajectory_dimensions);
    trajectory = reshape( ...
        read(socket, N, 'single'), ...
        header.number_of_samples, ...
        header.trajectory_dimensions ...
    );
end

function data = read_data(socket, header)
    N = int32(header.active_channels) * int32(header.number_of_samples) * 2;
    data = read(socket, N, 'single');
    data = reshape( ...
        complex(data(1:2:end), data(2:2:end)), ...
        header.number_of_samples, ...
        header.active_channels ...
    );
    data = transpose(data);
end

function header = read_header(socket)

    function out = read(varargin)
        out = socket.read(varargin{:});
    end

    header.version                  = read(1, 'uint16');
    header.flags                    = read(1, 'uint64');
    header.measurement_uid          = read(1, 'uint32');
    header.scan_counter             = read(1, 'uint32');
    header.acquisition_time_stamp   = read(1, 'uint32');
    header.physiology_time_stamp    = read(3, 'uint32');
    header.number_of_samples        = read(1, 'uint16');
    header.available_channels       = read(1, 'uint16');
    header.active_channels          = read(1, 'uint16');
    header.channel_mask             = read(16, 'uint64');
    header.discard_pre              = read(1, 'uint16');
    header.discard_post             = read(1, 'uint16');
    header.center_sample            = read(1, 'uint16');
    header.encoding_space_ref       = read(1, 'uint16');
    header.trajectory_dimensions    = read(1, 'uint16');
    header.sample_time_us           = read(1, 'single');
    header.position                 = read(3, 'single');
    header.read_dir                 = read(3, 'single');
    header.phase_dir                = read(3, 'single');
    header.slice_dir                = read(3, 'single');
    header.patient_table_position   = read(3, 'single');
    header.idx.kspace_encode_step_1 = read(1, 'uint16');
    header.idx.kspace_encode_step_2 = read(1, 'uint16');
    header.idx.average              = read(1, 'uint16');
    header.idx.slice                = read(1, 'uint16');
    header.idx.contrast             = read(1, 'uint16');
    header.idx.phase                = read(1, 'uint16');
    header.idx.repetition           = read(1, 'uint16');
    header.idx.set                  = read(1, 'uint16');
    header.idx.segment              = read(1, 'uint16');
    header.idx.user                 = read(8, 'uint16');
    header.user_int                 = read(8, 'int32');
    header.user_float               = read(8, 'single');   
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