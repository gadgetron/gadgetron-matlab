function waveform = create_random_waveform(seed)
    old_seed = rng(); rng(seed);
    
    parameters.channels = 32;
    parameters.number_of_samples = 256;
    
    waveform = ismrmrd.Waveform( ...
        create_random_waveform_header(parameters), ...
        create_random_waveform_data(parameters) ...
    );
    
    rng(old_seed);
end

function header = create_random_waveform_header(parameters)    
    header.version                  = uint16(1);
    header.flags                    = random('uint64', 1);
    header.measurement_uid          = random('uint32', 1);
    header.scan_counter             = random('uint32', 1);
    header.time_stamp               = random('uint32', 1);
    header.number_of_samples        = uint16(parameters.number_of_samples);
    header.channels                 = uint16(parameters.channels);
    header.sample_time_us           = random('single', 1);
    header.waveform_id              = random('uint16', 1);
end

function data = create_random_waveform_data(parameters)
    data = random('uint32', parameters.number_of_samples, parameters.channels);
end
