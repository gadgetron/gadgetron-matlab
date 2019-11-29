function next = noise_adjust(input, header)

    noise_matrix        = [];
    noise_dwell_time    = single(1.0);
    
    try 
        noise_bandwidth = header.acquisitionSystemInformation.relativeReceiverNoiseBandwidth;
    catch
        noise_bandwidth = single(0.793);
    end

    function f = scale_factor(acquisition)
        f = sqrt(2 * acquisition.header.sample_time_us * noise_bandwidth / noise_dwell_time);
    end

    function transformation = calculate_whitening_transformation(data)
        covariance = (1.0 / (size(data, 1) - 1)) * (data' * data); 
        transformation = inv(chol(covariance, 'upper'));
    end

    function acquisition = apply_whitening_transformation(acquisition)
        if isempty(noise_matrix), return; end
        acquisition.data = scale_factor(acquisition) * acquisition.data * noise_matrix; 
    end

    function acquisition = handle_noise(acquisition)       
        if acquisition.is_flag_set(acquisition.ACQ_IS_NOISE_MEASUREMENT)
            noise_matrix = calculate_whitening_transformation(acquisition.data);
            noise_dwell_time = acquisition.header.sample_time_us;
            acquisition = handle_noise(input()); % Recursive call; we output the next item.
        else
            acquisition = apply_whitening_transformation(acquisition);
        end
    end

    next = @() handle_noise(input());
end
