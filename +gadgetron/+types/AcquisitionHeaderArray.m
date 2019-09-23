classdef AcquisitionHeaderArray < handle
    
    properties (Access = private)
        headers
    end
    
    methods
        function self = AcquisitionHeaderArray(raw, dims)
            self.headers = ...
                gadgetron.types.AcquisitionHeaderArray.parse( ...
                    reshape(raw, 340, []), ...
                    dims ...
                );
        end
        
        function varargout = subsref(self, s)

            head = s(1); tail = s(2:end);

            switch head.type
                case '{}'
                    error("Brace indexing is not supported for variables of this type.")
                case '()'
                    varargout{1} = self.select(head.subs);
                    if ~isempty(tail), varargout{1} = arrayfun(@(h) subsref(h, tail), varargout{1}); end
                otherwise
                    [varargout{1:nargout}] = subsref(self.headers, s);
            end
        end
        
        function varargout = size(self, varargin)
            [varargout(1:nargout)] = size(self.cached, varargin{:});
        end
    end    
    
    methods (Access = private)
        function headers = select(self, indices)
            
            function out = select_indices(arr)
                out = arr(:, indices{:});
            end
            
            headers = structfun(@select_indices, rmfield(self.headers, 'idx'), 'UniformOutput', false);
            headers.idx = structfun(@select_indices, self.headers.idx, 'UniformOutput', false);
        end
    end
    
    methods (Static)
              
        function headers = parse(bytes, dims)
            % Convert from a byte array to a ISMRMRD AcquisitionHeaders
            % This conforms to the memory layout of the C-struct

            if size(bytes, 1) ~= 340
                error('Wrong number of bytes for AcquisitionHeader: %d', size(bytes, 1))
            end
            N = size(bytes, 2);            
            dims = num2cell(dims);

            headers.version =                  reshape(typecast(reshape(bytes(  1:   2, :), 1, 2 *      N), 'uint16'),  1, dims{:});  % First unsigned int indicates the version %
            headers.flags =                    reshape(typecast(reshape(bytes(  3:  10, :), 1, 8 *      N), 'uint64'),  1, dims{:});  % bit field with flags %
            headers.measurement_uid =          reshape(typecast(reshape(bytes(  11: 14, :), 1, 4 *      N), 'uint32'),  1, dims{:});  % Unique ID for the measurement %
            headers.scan_counter =             reshape(typecast(reshape(bytes(  15: 18, :), 1, 4 *      N), 'uint32'),  1, dims{:});  % Current acquisition number in the measurement %
            headers.acquisition_time_stamp =   reshape(typecast(reshape(bytes(  19: 22, :), 1, 4 *      N), 'uint32'),  1, dims{:});  % Acquisition clock %
            headers.physiology_time_stamp =    reshape(typecast(reshape(bytes(  23: 34, :), 1, 4 *  3 * N), 'uint32'),  3, dims{:});  % Physiology time stamps, e.g. ecg, breating, etc. %
            headers.number_of_samples =        reshape(typecast(reshape(bytes(  35: 36, :), 1, 2 *      N), 'uint16'),  1, dims{:});  % Number of samples acquired %
            headers.available_channels =       reshape(typecast(reshape(bytes(  37: 38, :), 1, 2 *      N), 'uint16'),  1, dims{:});  % Available coils %
            headers.active_channels =          reshape(typecast(reshape(bytes(  39: 40, :), 1, 2 *      N), 'uint16'),  1, dims{:});  % Active coils on current acquisiton %
            headers.channel_mask =             reshape(typecast(reshape(bytes(  41:168, :), 1, 8 * 16 * N), 'uint64'), 16, dims{:});  % Mask to indicate which channels are active. Support for 1024 channels %
            headers.discard_pre =              reshape(typecast(reshape(bytes( 169:170, :), 1, 2 *      N), 'uint16'),  1, dims{:});  % Samples to be discarded at the beginning of acquisition %
            headers.discard_post =             reshape(typecast(reshape(bytes( 171:172, :), 1, 2 *      N), 'uint16'),  1, dims{:});  % Samples to be discarded at the end of acquisition %
            headers.center_sample =            reshape(typecast(reshape(bytes( 173:174, :), 1, 2 *      N), 'uint16'),  1, dims{:});  % Sample at the center of k-space %
            headers.encoding_space_ref =       reshape(typecast(reshape(bytes( 175:176, :), 1, 2 *      N), 'uint16'),  1, dims{:});  % Reference to an encoding space, typically only one per acquisition %
            headers.trajectory_dimensions =    reshape(typecast(reshape(bytes( 177:178, :), 1, 2 *      N), 'uint16'),  1, dims{:});  % Indicates the dimensionality of the trajectory vector (0 means no trajectory) %
            headers.sample_time_us =           reshape(typecast(reshape(bytes( 179:182, :), 1, 4 *      N), 'single'),  1, dims{:});  % Time between samples in micro seconds, sampling BW %
            headers.position =                 reshape(typecast(reshape(bytes( 183:194, :), 1, 4 *  3 * N), 'single'),  3, dims{:});  % Three-dimensional spatial offsets from isocenter %
            headers.read_dir =                 reshape(typecast(reshape(bytes( 195:206, :), 1, 4 *  3 * N), 'single'),  3, dims{:});  % Directional cosines of the readout/frequency encoding %
            headers.phase_dir =                reshape(typecast(reshape(bytes( 207:218, :), 1, 4 *  3 * N), 'single'),  3, dims{:});  % Directional cosines of the phase encoding %
            headers.slice_dir =                reshape(typecast(reshape(bytes( 219:230, :), 1, 4 *  3 * N), 'single'),  3, dims{:});  % Directional cosines of the slice %
            headers.patient_table_position =   reshape(typecast(reshape(bytes( 231:242, :), 1, 4 *  3 * N), 'single'),  3, dims{:});  % Patient table off-center %
            headers.idx.kspace_encode_step_1 = reshape(typecast(reshape(bytes( 243:244, :), 1, 2 *      N), 'uint16'),  1, dims{:});  % phase encoding line number %
            headers.idx.kspace_encode_step_2 = reshape(typecast(reshape(bytes( 245:246, :), 1, 2 *      N), 'uint16'),  1, dims{:});  % partition encodning number %
            headers.idx.average =              reshape(typecast(reshape(bytes( 247:248, :), 1, 2 *      N), 'uint16'),  1, dims{:});  % signal average number %
            headers.idx.slice =                reshape(typecast(reshape(bytes( 249:250, :), 1, 2 *      N), 'uint16'),  1, dims{:});  % imaging slice number %
            headers.idx.contrast =             reshape(typecast(reshape(bytes( 251:252, :), 1, 2 *      N), 'uint16'),  1, dims{:});  % echo number in multi-echo %
            headers.idx.phase =                reshape(typecast(reshape(bytes( 253:254, :), 1, 2 *      N), 'uint16'),  1, dims{:});  % cardiac phase number %
            headers.idx.repetition =           reshape(typecast(reshape(bytes( 255:256, :), 1, 2 *      N), 'uint16'),  1, dims{:});  % dynamic number for dynamic scanning %
            headers.idx.set =                  reshape(typecast(reshape(bytes( 257:258, :), 1, 2 *      N), 'uint16'),  1, dims{:});  % flow encoding set %
            headers.idx.segment =              reshape(typecast(reshape(bytes( 259:260, :), 1, 2 *      N), 'uint16'),  1, dims{:});  % segment number for segmented acquisition %
            headers.idx.user =                 reshape(typecast(reshape(bytes( 261:276, :), 1, 2 *  8 * N), 'uint16'),  8, dims{:});  % Free user parameters %
            headers.user_int =                 reshape(typecast(reshape(bytes( 277:308, :), 1, 4 *  8 * N), 'int32' ),  8, dims{:});  % Free user parameters %
            headers.user_float =               reshape(typecast(reshape(bytes( 309:340, :), 1, 4 *  8 * N), 'single'),  8, dims{:});  % Free user parameters %
        end
    end
end
