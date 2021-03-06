function acquisition = read_acquisition(socket)
    header = gadgetron.external.readers.decode_acquisition_headers(read(socket, 340, 'uint8'), 1);
    trajectory = read_trajectory(socket, header); 
    data = read_data(socket, header);
    acquisition = gadgetron.types.Acquisition(header, data, trajectory);
end

function trajectory = read_trajectory(socket, header)
    N = double(header.number_of_samples) * double(header.trajectory_dimensions);
    trajectory = reshape( ...
        read(socket, N, 'single'), ...
        header.trajectory_dimensions, ...
        header.number_of_samples ...
    );
end

function data = read_data(socket, header)
    N = double(header.active_channels) * double(header.number_of_samples) * 2;
    data = read(socket, N, 'single');
    data = reshape( ...
        complex(data(1:2:end), data(2:2:end)), ...
        header.number_of_samples, ...
        header.active_channels ...
    );
end
