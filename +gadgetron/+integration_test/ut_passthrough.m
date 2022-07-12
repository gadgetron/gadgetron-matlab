function ut_passthrough(connection)
disp('ut_passthrough')

    function send_data(connection)
        disp("Sending data to client.");
        connection.send(connection.next());
    end

next = @() send_data(connection);

tic, gadgetron.consume(next); toc
end

