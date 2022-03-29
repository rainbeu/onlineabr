classdef ABRRawData < handle
    
    properties (GetAccess = public)
        datetime
        fs
        channels
        buffer_size
        time_offset
        scaling_factor
        file_name
        time
    end
    
    properties (Access = public) %protected)
        fileID = -1
        data_start
        frame_skip
        file_size
        max_frame_number
        current_frame = -1
        buffer
    end
    
    properties (Access = private)
    end
    
    properties (Access = private, Constant)
        data_type = 'float32'
        byte_size = 4
    end
    
    methods (Access = public)
        
        function obj = ABRRawData(file_name, varargin)
            
            assert(isfile(file_name));
            
            obj.open_file(file_name);
            obj.read_header;
            
        end
        
        function delete(obj)
            if obj.fileID > 0
                fclose(obj.fileID);
            end
        end
        
        function frame = get_frame(self, frame_number)
            if self.current_frame < 0 || frame_number ~= self.current_frame
                self.read_frame(frame_number);
            end
            frame = self.buffer;
        end

        function frame = get_channel(self, frame_number, channel)
            assert(channel <= self.channels, 'channel %1.0f does not exist');
            self.get_frame(frame_number);
            frame = self.buffer(:, channel);
        end
        
        
    end
    
    methods (Access = protected)
        
        function open_file(self, file_name)
            if isempty(file_name)
                file_name = self.file_name;
            end
            assert(self.fileID < 0, 'file %s already open!', self.file_name);
            fid = fopen(file_name, 'r');
            assert(fid > 0, 'could open file %s!', file_name);
            self.fileID = fid;
            self.file_name = file_name;
        end
        
        function close_file(self)
            assert(self.fileID > 0, 'no file open!');
            fclose(self.fileID);
            self.fileID = -1;
        end
        
        function read_header(self)
            assert(self.fileID > 0, 'no file open!');
            fseek(self.fileID, 0, 'bof');
            
            % check validity
            assert(strcmp(fread(self.fileID,7,'char=>char').','ABRdata'), 'not an ABR data file'); 

            self.datetime = fread(self.fileID,19,'char=>char').';    %  recording date and time

            % read file attributes
            self.fs = fread(self.fileID,1,'uint32'); % sampling frequency
            self.channels = fread(self.fileID,1,'uint16'); % number of recorded channels
            self.buffer_size = fread(self.fileID,1,'uint32'); % size in samples of one channel buffer
            self.time_offset = fread(self.fileID,1,'double'); % stimulus timeoffset within buffer
            self.scaling_factor = fread(self.fileID,1,'double'); % scaling factor from digital full scale (0-1) to µV
            
            % set markers for random access
            self.data_start = ftell(self.fileID);
            self.frame_skip = (self.buffer_size * self.channels) * self.byte_size;
            
            % find out file size
            fseek(self.fileID, 0, 'eof');
            self.file_size = ftell(self.fileID);
            fseek(self.fileID, self.data_start, 'bof');
            
            % calculate number of frames
            self.max_frame_number = (self.file_size - self.data_start) / self.frame_skip;
            
            % create time vector
            self.time = (0:self.buffer_size-1).'/self.fs;
            self.time = self.time - self.time_offset;
        end
        
        function read_frame(self, frame_number)
            assert(frame_number <= self.max_frame_number, 'frame number %1.0f does not exist', frame_number);
            byte_position = self.data_start + (frame_number - 1) * self.frame_skip;
            assert(byte_position <= self.file_size)
            fseek(self.fileID, byte_position, 'bof');
            self.buffer = reshape(fread(self.fileID, self.buffer_size*self.channels, ...
                                        sprintf('%s=>double', self.data_type)), ...
                                  self.channels, []).'; 
            self.current_frame = frame_number;
        end
        
    end
    
end
