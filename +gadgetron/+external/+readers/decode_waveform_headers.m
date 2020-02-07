function headers = decode_waveform_headers(bytes, dims)

    bytes = reshape(bytes, 40, []);
    N = size(bytes, 2);            
    dims = num2cell(dims);
    
    headers.version =                  reshape(typecast(reshape(bytes(  1:   2, :), 1, 2 *      N), 'uint16'),  1, dims{:});
    % Following version there's 6 bytes of padding. 
    headers.flags =                    reshape(typecast(reshape(bytes(  9:  16, :), 1, 8 *      N), 'uint64'),  1, dims{:});
    headers.measurement_uid =          reshape(typecast(reshape(bytes(  17: 20, :), 1, 4 *      N), 'uint32'),  1, dims{:});
    headers.scan_counter =             reshape(typecast(reshape(bytes(  21: 24, :), 1, 4 *      N), 'uint32'),  1, dims{:});
    headers.time_stamp =               reshape(typecast(reshape(bytes(  25: 28, :), 1, 4 *      N), 'uint32'),  1, dims{:});
    headers.number_of_samples =        reshape(typecast(reshape(bytes(  29: 30, :), 1, 2 *      N), 'uint16'),  1, dims{:});
    headers.channels =                 reshape(typecast(reshape(bytes(  31: 32, :), 1, 2 *      N), 'uint16'),  1, dims{:});
    headers.sample_time_us =           reshape(typecast(reshape(bytes(  33: 36, :), 1, 4 *      N), 'single'),  1, dims{:});
    headers.waveform_id =              reshape(typecast(reshape(bytes(  37: 38, :), 1, 2 *      N), 'uint16'),  1, dims{:});
    % Following waveform id there's 2 bytes of padding.
end

