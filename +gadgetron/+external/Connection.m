classdef Connection < handle
    % CONNECTION Represents a connection to an ISMRMRD client.
    % 
    %   CONNECTION objects are created by the Gadgetron Foreign Interface, 
    %   representing communication with the ISMRMRD client.
    %
    % CONNECTION Properties:
    %
    %   config - Configuration sent by the ISMRMRD client.
    %   header - ISMRMRD data header describing the current dataset.
    %
    % CONNECTION Methods:
    %
    %   next - Retrieve the next item from the client.
    %   send - Send an item to the client. 
    %
    %   filter - Filter incoming items, based a provided predicate.
    % 
    %   add_reader - Add (or overwrite) a registered reader. 
    %   add_writer - Add (or overwrite) a registered writer.
    %
    % A CONNECTION object is created to handle a connection to an ISMRMRD
    % client.
    %
    % A CONNECTION object exposes the data flowing to and from the client
    % through the 'next' and 'send' methods. Configuration and ISMRMRD
    % Header metadata is exposed thorugh properties.
    % 
    % Each connection maintains a set of readers (each consuming an 
    % ISMRMRD binary data, producung a workable item), and a set of writers 
    % (each consuming items, producing ISMRMRD binary data). 
    % 
    % Applying a filter causes next to only return suitable items. Should
    % an item be read that doesn't satisfy the filter predicate, the item
    % is returned to the client unchanged. 
    
        
    properties (GetAccess = public, SetAccess = private)
        config % CONFIG is the requested configuration, as sent by the client.         
        header % HEADER is the ISMRMRD header describing the current data. 
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
            self.socket.write(gadgetron.Constants.CLOSE);
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
            
            if mid == gadgetron.Constants.CLOSE
                throw(MException('Connection:noNextItem', 'No `next` item; connection is closed.'));
            end
            
            reader = self.readers(mid);
            item = reader(self.socket);
        end

        function config = read_config(self) 
            [config, mid] = self.next();
            assert(mid == gadgetron.Constants.CONFIG);
        end
        
        function header = read_header(self)
            [raw, mid] = self.next();
            assert(mid == gadgetron.Constants.HEADER);
            header = gadgetron.types.xml.deserialize(raw);
        end
    end
    
    methods (Access = private, Static)
        function readers = build_reader_map()
            % Maps do not support a wide range of key types. We're forced
            % to use uint32, as uint16 is not supported.
            readers = containers.Map('KeyType', 'uint32', 'ValueType', 'any');
            readers(uint32(gadgetron.Constants.CONFIG))      = @gadgetron.external.readers.read_config;
            readers(uint32(gadgetron.Constants.HEADER))      = @gadgetron.external.readers.read_header;
            readers(uint32(gadgetron.Constants.ACQUISITION)) = @gadgetron.external.readers.read_acquisition;
            readers(uint32(gadgetron.Constants.WAVEFORM))    = @gadgetron.external.readers.read_waveform;
            readers(uint32(gadgetron.Constants.RECON_DATA))  = @gadgetron.external.readers.read_recon_data;
            readers(uint32(gadgetron.Constants.IMAGE_ARRAY)) = @gadgetron.external.readers.read_image_array;
            readers(uint32(gadgetron.Constants.IMAGE))       = @gadgetron.external.readers.read_image;
            readers(uint32(gadgetron.Constants.BUCKET))      = @gadgetron.external.readers.read_bucket;
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
