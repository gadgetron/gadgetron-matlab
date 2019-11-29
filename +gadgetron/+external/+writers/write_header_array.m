function write_header_array(socket, headers)
    gadgetron.external.writers.write_vector(socket, size(headers.version));
    write(socket, gadgetron.external.writers.encode_image_headers(headers));
end

