function writer = write_acquisition()
    writer.accepts = @(item) isa(item, 'gadgetron.types.Acquisition');
    writer.write = @write_acquisition_header_and_data;
end

function write_acquisition_header_and_data(socket, acquisition)
    write(socket, gadgetron.Constants.ACQUISITION);
    write_header(socket, acquisition.header);
    write_trajectory(socket, acquisition.trajectory);
    write_data(socket, acquisition.data);
end

function write_trajectory(socket, trajectory)
    if isempty(trajectory), return; end
    write(socket, reshape(trajectory, 1, []));
end

function write_data(socket, data)
    
    output = zeros([2, size(data)], 'single');
    output(1, :, :) = real(data);
    output(2, :, :) = imag(data);
    
    write(socket, reshape(output, 1, []));
end

function write_header(socket, header)
    write(socket, uint16(header.version));
    write(socket, uint64(header.flags));
    write(socket, uint32(header.measurement_uid));
    write(socket, uint32(header.scan_counter));
    write(socket, uint32(header.acquisition_time_stamp));
    write(socket, uint32(header.physiology_time_stamp));
    write(socket, uint16(header.number_of_samples));
    write(socket, uint16(header.available_channels));
    write(socket, uint16(header.active_channels));
    write(socket, uint64(header.channel_mask));
    write(socket, uint16(header.discard_pre));
    write(socket, uint16(header.discard_post));
    write(socket, uint16(header.center_sample));
    write(socket, uint16(header.encoding_space_ref));
    write(socket, uint16(header.trajectory_dimensions));
    
    write(socket, single(header.sample_time_us));
    write(socket, single(header.position));
    write(socket, single(header.read_dir));
    write(socket, single(header.phase_dir));
    write(socket, single(header.slice_dir));
    write(socket, single(header.patient_table_position));

    write(socket, uint16(header.kspace_encode_step_1));
    write(socket, uint16(header.kspace_encode_step_2));
    write(socket, uint16(header.average));
    write(socket, uint16(header.slice));
    write(socket, uint16(header.contrast));
    write(socket, uint16(header.phase));
    write(socket, uint16(header.repetition));
    write(socket, uint16(header.set));
    write(socket, uint16(header.segment));
    write(socket, uint16(header.user));
        
    write(socket, int32(header.user_int));
    write(socket, single(header.user_float));
end
