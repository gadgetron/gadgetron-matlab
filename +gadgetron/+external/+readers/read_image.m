function image = read_image(socket)
    header = gadgetron.external.readers.decode_image_headers(read(socket, 198, 'uint8'), 1);
    attribute_string = read_attribute_string(socket);
    data = read_data(socket, header);
    image = gadgetron.types.Image(header, attribute_string, data);
end

function attribute_string = read_attribute_string(socket)
    attribute_string = gadgetron.external.readers.read_string(socket, 'uint64');
end

function data = read_data(socket, header)
    [nelements, type, transformation] = examine_header(header);    
    data = reshape( ...
        transformation( ...
            read(socket, nelements, type) ...
        ), ...
        [header.channels transpose(header.matrix_size)] ...
    );
end


function [nelements, type, transformation] = examine_header(header)

    nelements = prod([header.channels transpose(header.matrix_size)]);
    transformation = @(i) i;

    switch header.data_type
        case gadgetron.types.Image.USHORT
            type = 'uint16';            
        case gadgetron.types.Image.SHORT
            type = 'int16';
        case gadgetron.types.Image.UINT
            type = 'uint32';
        case gadgetron.types.Image.INT
            type = 'int32';
        case gadgetron.types.Image.FLOAT
            type = 'single';            
        case gadgetron.types.Image.DOUBLE
            type = 'double';
        case gadgetron.types.Image.CXFLOAT
            nelements = 2 * nelements;
            type = 'single';
            transformation = @gadgetron.external.readers.as_interleaved_complex;
        case gadgetron.types.Image.CXDOUBLE
            nelements = 2 * nelements;
            type = 'double';
            transformation = @gadgetron.external.readers.as_interleaved_complex;
    end
end