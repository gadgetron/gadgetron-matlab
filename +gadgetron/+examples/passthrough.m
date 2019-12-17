function passthrough(connection)
    connection.filter(@(~, ~) false);
    tic, gadgetron.consume(@connection.next); toc
end

