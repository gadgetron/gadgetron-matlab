function tests = read_write_tests()
    tests = functiontests(localfunctions);
end

function setup(state)

    acquisition.mid         = ismrmrd.Constants.ACQUISITION;
    acquisition.type        = 'ismrmrd.Acquisition';
    acquisition.generator   = @create_random_acquisition;
    acquisition.reader      = @gadgetron.external.readers.read_acquisition;
    acquisition.writer      = gadgetron.external.writers.write_acquisition;

    waveform.mid            = ismrmrd.Constants.WAVEFORM;
    waveform.type           = 'ismrmrd.Waveform';
    waveform.generator      = @create_random_waveform;
    waveform.reader         = @gadgetron.external.readers.read_waveform;
    waveform.writer         = gadgetron.external.writers.write_waveform;
    
    state.TestData.socket = gadgetron.tests.SocketMockup();    
    state.TestData.parameters = [acquisition, waveform];
end

function single_read_write_test(state)

    function test_single_read_write(parameters)
        item = parameters.generator(42);

        parameters.writer.write(state.TestData.socket, item);    
        assert_next_item_equals(state.TestData.socket, item, parameters);
    end

    for parameters = state.TestData.parameters
        test_single_read_write(parameters);
    end
end

function multiple_read_write_test(state)

    function test_multiple_read_write(parameters)
        for item = arrayfun(parameters.generator, 1:10)       
            parameters.writer.write(state.TestData.socket, item);
            assert_next_item_equals(state.TestData.socket, item, parameters);
        end
    end

    for parameters = state.TestData.parameters
        test_multiple_read_write(parameters);
    end
end

function assert_next_item_equals(socket, item, parameters) 

    mid = read(socket, 1, 'uint16');

    assert( ...
        parameters.mid == mid, ...
        sprintf("Writer did not preface %s with appropriate message id. (%d ~= %d)", ...
                parameters.type, parameters.mid, mid) ...
    );
    assert( ...
        isequal(item, parameters.reader(socket)), ...
        sprintf("%s differs after write/read cycle.", ...
                parameters.type) ...
    );
end
