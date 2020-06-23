classdef Connection < handle
    % CONNECTION Represents a connection to an ISMRMRD client.
    % 
    %   CONNECTION objects are created by the Gadgetron External Language
    %   Interface, representing communication with the ISMRMRD client.
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
    % Each connection maintains a set of readers (each consuming ISMRMRD 
    % binary data, producung a workable item), and a set of writers 
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
            % NEXT  Provide the next item.
            %   Calling NEXT will produce the next item available on a
            %   connection. When next is called, and ISMRMRD Message ID
            %   (MID) is read from the connection. This MID is used to
            %   select an appropriate reader, which in turn reads the 
            %   item from the connection. The item is returned to the
            %   caller. Calling next when no more items are available 
            %   throws a Connection:noNextItem exception.
            %
            %   item = connection.NEXT() produces the next available item. 
            %   If no item is ready, next will block until an item becomes
            %   available.
            %
            %   [item, MID] = connection.NEXT() provides the next item, 
            %   along with the ISMRMRD Message ID associated with the item.
            % 
            %   If the connection is filtered, only items satisfying the
            %   supplied predicate is returned. Any items not satisfying
            %   the predicate is returned to the client unchanged.
            
            [item, mid] = self.read_next();
            
            while ~self.filter_predicate(mid, item)
                fprintf("Bypassing item: %s\n", class(item));
                self.send(item);
                [item, mid] = self.read_next();
            end
        end
        
        function send(self, item)
            % SEND  Send an item to the client.
            %   
            %   connection.SEND(item) causes the connection to examine the
            %   item, select an appropriate writer, and use the writer to 
            %   serialize the item back to the client.
            
            for writer = self.writers.asarray
                if writer.accepts(item), writer.write(self.socket, item); return, end
            end
            throw(MException("Connection:noAppropriateWriter", ...
                             "No appropriate writer found for type '%s'", ...
                             class(item)));
        end
        
        function filter(self, f)
            % FILTER  Set the connection filter.
            %   Setting a filter limits which items can be returned from
            %   subsequent calls to next.
            %
            %   connection.FILTER(@predicate) ensures that next will only
            %   ever return items for which predicate(item) returns true.
            %
            %   Example:
            %   connection.FILTER(@(item) isprop(item, 'header')) ensures
            %   that only items with a 'header' property are ever returned
            %   by subsequent calls to connection.next.
            %
            %   Besides predicates (functions), filter also accepts char 
            %   arrays (and strings). These serve as shorthand for an 'isa' 
            %   predicate.
            %
            %   Example:
            %   connection.FILTER('foo.bar.Baz') is equivalent to
            %   connection.FILTER(@(item) isa(item, 'foo.bar.Baz')
            
            if isa(f, 'char') || isa(f, 'string')
                self.filter_predicate = @(~, item) isa(item, f);
            else
                self.filter_predicate = f;
            end
        end
        
        function add_reader(self, slot, reader)
            % ADD_READER  Add a user-defined reader to the connection's
            % reader set.
            %
            %   connection.ADD_READER(slot, @reader_function) registers a
            %   reader function with the connection. Whenever an ISMRMRD
            %   message with MID==slot is received, reader_function will be
            %   invoked to read and deserialize the ISMRMRD binary data.
            
            self.readers(uint32(slot)) = reader;
        end
        
        function add_writer(self, writer)
            % ADD_WRITER  Add a user-defined writer to the connection's
            % writer set.
            %
            %   connection.ADD_WRITER(writer) adds a writer to the
            %   connection's writer-set. The writer is expected to be a 
            %   struct (or object) featuring an 'accepts' and a 'write'
            %   method, such that 
            %       writer.write(socket, item) is called when
            %       writer.accepts(item) returns true.
            
            self.writers = cons(self.writers, writer);
        end
    end    
   
    methods (Access = private)
        function [item, mid] = read_next(self)
            mid = gadgetron.external.readers.read_message_id(self.socket);
            
            if ~self.readers.isKey(mid)
                throw(MException('Connection:noAppropriateReader', ...
                                 'No appropriate reader found for message with id: %d', ...
                                 mid));
            end
            
            reader = self.readers(mid);
            item = reader(self.socket);
        end

        function config = read_config(self) 
            [config, mid] = self.next();
            assert(mid == gadgetron.Constants.CONFIG || ...
                   mid == gadgetron.Constants.FILENAME);
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
            readers(uint32(gadgetron.Constants.CLOSE))       = @gadgetron.external.Connection.close_handler;
            readers(uint32(gadgetron.Constants.FILENAME))    = @gadgetron.external.readers.read_config_file;
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
                
        function item = close_handler(~)
            throw(MException('Connection:noNextItem', 'No `next` item; connection is closed.'));
        end
        
        function tf = always_accept(~, ~), tf = true; end
    end
end
