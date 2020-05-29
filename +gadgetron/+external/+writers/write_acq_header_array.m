function write_acq_header_array(socket, headers)
    gadgetron.external.writers.write_vector(socket, size(headers.version));
    write(socket, gadgetron.external.writers.encode_acquisition_headers(headers));
end

