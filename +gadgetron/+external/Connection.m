classdef Connection < handle
    
    properties (GetAccess = public, SetAccess = private)
        config 
        header
    end
   
    properties (Access = private)
        socket

        readers 
        writers
        
        next_mid
    end
    
    methods (Access = public)
        function self = Connection(socket)
            self.socket = socket;
            self.next_mid = read_message_id(self.socket);

            self.readers = gadgetron.external.Connection.build_reader_map();
            self.writers = gadgetron.external.Connection.build_writer_list();

            self.config = self.read_config();
            self.header = self.read_header();
        end
        
        function [item, mid] = next(self)
            
            if self.next_mid == ismrmrd.Constants.CLOSE
                throw(MException('Connection:noNextItem', 'No `next` item; connection is closed.'));
            end
            
            mid = self.next_mid;
            reader = self.readers(mid);
            item = reader(self.socket);
            
            self.next_mid = read_message_id(self.socket);
        end
        
        function status = has_next(self)
            status = self.next_mid ~= ismrmrd.Constants.CLOSE;
        end
        
        function send(self, item)
            for writer = self.writers.asarray
                if writer.accepts(item), writer.write(self.socket, item); return, end
            end
            throw(MException("Connection:send", ...
                             "No appropriate writer found for type '%s'", ...
                             class(item)));
        end
        
        function filter(self, f)
            
        end
    end    
   
    methods (Access = private)
        function config = read_config(self) 
            [config, mid] = self.next();
            assert(mid == ismrmrd.Constants.CONFIG);
        end
        
        function header = read_header(self)
            [raw, mid] = self.next();
            assert(mid == ismrmrd.Constants.HEADER);
            header = ismrmrd.xml.deserialize(raw);
        end
    end
    
    methods (Access = private, Static)
        function readers = build_reader_map()
            % Maps do not support a wide range of key types. We're forced
            % to use uint32, as uint16 is not supported.
            readers = containers.Map('KeyType', 'uint32', 'ValueType', 'any');
            readers(uint32(ismrmrd.Constants.CONFIG))      = @read_config;
            readers(uint32(ismrmrd.Constants.HEADER))      = @read_header;
            readers(uint32(ismrmrd.Constants.ACQUISITION)) = @read_acquisition;
            readers(uint32(ismrmrd.Constants.WAVEFORM))    = @read_waveform;
            readers(uint32(ismrmrd.Constants.IMAGE))       = @read_image;
        end
        
        function writers = build_writer_list()
            writers = gadgetron.util.list(  ...
                write_image                 ...
            );
        end
    end
end
