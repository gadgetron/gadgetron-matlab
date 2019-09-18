function next = send_image_to_client(input, connection)

    function send_image(image)
        disp("Sending image to client.");
        connection.send(image);
    end

    next = @() send_image(input());
end
