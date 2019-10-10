function acquisition = create_random_acquisition(seed)
    old_seed = rng(); rng(seed);
    
    parameters.channels = 32;
    parameters.number_of_samples = 256;
    parameters.trajectory_dimensions = 2;
    
    acquisition = ismrmrd.Acquisition( ...
        create_random_acquisition_header(parameters), ...
        create_random_acquisition_data(parameters), ...
        create_random_acquisition_trajectory(parameters) ...
    );
    
    rng(old_seed);
end

function header = create_random_acquisition_header(parameters) 

    header.version                  = uint16(1);
    header.flags                    = random('uint64', 1);
    header.measurement_uid          = random('uint32', 1);
    header.scan_counter             = random('uint32', 1);
    header.acquisition_time_stamp   = random('uint32', 1);
    header.physiology_time_stamp    = random('uint32', 1, 3);
    header.number_of_samples        = uint16(parameters.number_of_samples);
    header.available_channels       = uint16(parameters.channels);
    header.active_channels          = uint16(parameters.channels);
    header.channel_mask             = random('uint64', 1, 16);
    header.discard_pre              = random('uint16', 1);
    header.discard_post             = random('uint16', 1);
    header.center_sample            = random('uint16', 1);
    header.encoding_space_ref       = random('uint16', 1);
    header.trajectory_dimensions    = uint16(parameters.trajectory_dimensions);
    header.sample_time_us           = random('single', 1);
    header.position                 = random('single', 1, 3);
    header.read_dir                 = random('single', 1, 3);
    header.phase_dir                = random('single', 1, 3);
    header.slice_dir                = random('single', 1, 3);
    header.patient_table_position   = random('single', 1, 3);

    header.kspace_encode_step_1     = random('uint16', 1);
    header.kspace_encode_step_2     = random('uint16', 1);
    header.average                  = random('uint16', 1);
    header.slice                    = random('uint16', 1);
    header.contrast                 = random('uint16', 1);
    header.phase                    = random('uint16', 1);
    header.repetition               = random('uint16', 1);
    header.set                      = random('uint16', 1);
    header.segment                  = random('uint16', 1);
    header.user                     = random('uint16', 1, 8);
    
    header.user_int                 = random('int32', 1, 8);
    header.user_float               = random('single', 1, 8);    
end

function data = create_random_acquisition_data(parameters)
    data = complex( ...
        rand(parameters.number_of_samples, parameters.channels, 'single'), ...
        rand(parameters.number_of_samples, parameters.channels, 'single') ...
    );
end

function trajectory = create_random_acquisition_trajectory(parameters)
    trajectory = ...
        rand(parameters.trajectory_dimensions, parameters.number_of_samples, 'single');
end

