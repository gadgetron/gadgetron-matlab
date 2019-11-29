function writer = write_image_array()
    writer.accepts = @(item) isa(item, 'gadgetron.types.ImageArray');
    writer.write = @write_image_array_to_socket;
end

function write_image_array_to_socket(socket, image_array)

    write(socket, gadgetron.Constants.IMAGE_ARRAY);

    write_data(socket, image_array.data);
    write_headers(socket, image_array.headers);
    write_meta(socket, image_array.meta);
    write_optional_waveform(socket, image_array.waveform);
    write_optional_acq_headers(socket, image_array.acq_headers);
end

function write_data(socket, data)
    gadgetron.external.writers.write_array(socket, data, 'complex64');
end

function write_headers(socket, headers)
    gadgetron.external.writers.write_header_array(socket, headers);
end

function write_meta(socket, meta)
    size = uint64(numel(meta));

    write(socket, size);
    
    for s = meta
        gadgetron.external.writers.write_string(socket, s, 'uint64');
    end
end

function write_optional_waveform(socket, waveforms)
    gadgetron.external.writers.write_optional( ... 
        socket, ...
        waveforms, ...
        @write_waveforms ...
    );
end

function write_waveforms(socket, waveforms)
    write(socket, uint64(numel(waveforms)));
    
    for waveform = waveforms
        gadgetron.external.writers.write_waveform(socket, waveform);
    end
end

function write_optional_acq_headers(socket, acq_headers)
    gadgetron.external.writers.write_optional( ...
        socket, ...
        acq_headers, ...
        @write_acq_headers ...
    );
end

function write_acq_headers(socket, acq_headers)
    gadgetron.external.writers.write_header_array(socket, acq_headers);
end