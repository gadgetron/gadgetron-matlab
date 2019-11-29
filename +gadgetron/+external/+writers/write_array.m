function write_array(socket, array, type)
    dimensions = size(array);
    gadgetron.external.writers.write_vector(socket, dimensions);
    
    switch type
        case 'complex64'
            write_complex_array(socket, array, 'single');
        case 'complex128'
            write_complex_array(socket, array, 'double');
        otherwise
            write_simple_array(socket, array, type);
    end    
end

function write_simple_array(socket, array, type)
    write(socket, cast(array, type));
end

function write_complex_array(socket, array, type)
    output = zeros([2, size(array)], type);
        
    output(1, :) = real(array(:));
    output(2, :) = imag(array(:));
    
    write(socket, reshape(output, 1, []));
end
