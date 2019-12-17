function tiny_recon(connection)
    
    tic;

    try
        % Once the connection is consumed, calling next will throw an
        % exception. We wrap the loop in a try here to avoid printing an
        % error. 
        
        while true
            recon_data = connection.next();

            data = permute( ... 
                recon_data.bits.buffer.data, ...
                [4, 1, 2, 3] ...
            );

            data = gadgetron.lib.fft.cifftn(data, [2, 3, 4]);
            data = sqrt(sum(square(abs(data)), 1));

            image = gadgetron.types.Image.from_data(data, reference_header(recon_data));
            image.header.image_type = gadgetron.types.Image.MAGNITUDE;

            disp("Sending image to client.");
            connection.send(image);
        end
    end
    
    toc;
end

function reference = reference_header(recon_data)
    % We pick the first header from the header arrays - we need it to initialize the image meta data.    
    reference = structfun(@(arr) arr(:, 1)', recon_data.bits.buffer.headers, 'UniformOutput', false);
end

function x = square(x), x = x .^ 2; end
