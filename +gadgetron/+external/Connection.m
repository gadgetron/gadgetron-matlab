classdef Connection < handle
    
    properties (GetAccess = public, SetAccess = private)
        config 
        header
    end
   
    properties (Access = private)
        socket

        readers 
        writers
    end
    
    properties (Access = private)
        filter_predicate = @gadgetron.external.Connection.always_accept;
    end
    
    methods (Access = public)
        function self = Connection(socket)
            self.socket = socket;
 
            self.readers = gadgetron.external.Connection.build_reader_map();
            self.writers = gadgetron.external.Connection.build_writer_list();

            self.config = self.read_config();
            self.header = self.read_header();
        end
        
        function delete(self)
            self.socket.write(ismrmrd.Constants.CLOSE);
        end
        
        function [item, mid] = next(self)
            [item, mid] = self.read_next();
            
            while ~self.filter_predicate(mid, item)
                fprintf("Bypassing item: %s\n", class(item));
                self.send(item);
                [item, mid] = self.read_next();
            end
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
            if isa(f, 'char') || isa(f, 'string')
                self.filter_predicate = @(~, item) isa(item, f);
            else
                self.filter_predicate = f;
            end
        end
        
        function add_reader(self, slot, reader)
            self.readers(uint32(slot)) = reader;
        end
        
        function add_writer(self, writer)
            self.writers = cons(self.writers, writer);
        end
    end    
   
    methods (Access = private)
        function [item, mid] = read_next(self)
            mid = gadgetron.external.readers.read_message_id(self.socket);
            
            if mid == ismrmrd.Constants.CLOSE
                throw(MException('Connection:noNextItem', 'No `next` item; connection is closed.'));
            end
            
            reader = self.readers(mid);
            item = reader(self.socket);
        end

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
            readers(uint32(ismrmrd.Constants.CONFIG))      = @gadgetron.external.readers.read_config;
            readers(uint32(ismrmrd.Constants.HEADER))      = @gadgetron.external.readers.read_header;
            readers(uint32(ismrmrd.Constants.ACQUISITION)) = @gadgetron.external.readers.read_acquisition;
            readers(uint32(ismrmrd.Constants.WAVEFORM))    = @gadgetron.external.readers.read_waveform;
            readers(uint32(ismrmrd.Constants.RECON_DATA))  = @gadgetron.external.readers.read_recon_data;
            readers(uint32(ismrmrd.Constants.IMAGE))       = @gadgetron.external.readers.read_image;
            readers(uint32(ismrmrd.Constants.BUCKET))      = @gadgetron.external.readers.read_bucket;
        end
        
        function writers = build_writer_list()
            writers = gadgetron.lib.list( ...
                gadgetron.external.writers.write_image, ...
                gadgetron.external.writers.write_acquisition, ...
                gadgetron.external.writers.write_waveform ...
            );
        end
        
        function tf = always_accept(~, ~), tf = true; end
    end
end
