function headers = decode_waveform_headers(bytes, dims)

    bytes = reshape(bytes, 40, []);
    N = size(bytes, 2);            
    dims = num2cell(dims);

    headers.version =                  reshape(typecast(reshape(bytes(  1:   2, :), 1, 2 *      N), 'uint16'), dims{:},  1);
    % Following version there's 6 bytes of padding. 
    headers.flags =                    reshape(typecast(reshape(bytes(  9:  16, :), 1, 8 *      N), 'uint64'), dims{:},  1);
    headers.measurement_uid =          reshape(typecast(reshape(bytes(  17: 20, :), 1, 4 *      N), 'uint32'), dims{:},  1);
    headers.scan_counter =             reshape(typecast(reshape(bytes(  21: 24, :), 1, 4 *      N), 'uint32'), dims{:},  1);
    headers.time_stamp =               reshape(typecast(reshape(bytes(  25: 28, :), 1, 4 *      N), 'uint32'), dims{:},  1);
    headers.number_of_samples =        reshape(typecast(reshape(bytes(  29: 30, :), 1, 2 *      N), 'uint16'), dims{:},  1);
    headers.channels =                 reshape(typecast(reshape(bytes(  31: 32, :), 1, 2 *      N), 'uint16'), dims{:},  1);
    headers.sample_time_us =           reshape(typecast(reshape(bytes(  33: 36, :), 1, 4 *      N), 'single'), dims{:},  1);
    headers.waveform_id =              reshape(typecast(reshape(bytes(  37: 38, :), 1, 2 *      N), 'uint16'), dims{:},  1);
    % Following waveform id there's 2 bytes of padding.
end

