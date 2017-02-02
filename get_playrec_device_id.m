function devID = get_playrec_device_id(varargin)
    
    name = 'Hammerfall';
    host_api = 'ASIO';
    
    dev = playrec('getDevices');
    
    if ~isempty(varargin) && strcmpi(varargin{1}, 'list')
        
        fprintf('\n');
        
        fprintf('  possible device names\n');
        fprintf('=========================\n');
        names = unique({dev.name}.');
        fprintf('%s\n', names{:})
        fprintf('\n');
        
        fprintf('  possible host APIs\n');
        fprintf('======================\n');
        apis = unique({dev.hostAPI}.');
        fprintf('%s\n', apis{:})
        fprintf('\n');
        
    elseif length(varargin) == 2
        
        name = varargin{1};
        host_api = varargin{2};
        
    else
        
        idx = true(1, length(dev));
        
        idx = idx & ~cellfun(@isempty,regexp({dev.name},['.*' name '.*']));
        idx = idx & ~cellfun(@isempty,regexp({dev.hostAPI},['.*' host_api '.*']));
        
        idx = find(idx);
        
        if ~isempty(idx)
            
            devID = dev(idx).deviceID;
            
            fprintf('\n');
            fprintf('  possible devices:\n');
            fprintf('=====================\n');
            fprintf('\n');
            for k = 1:length(idx)
                fprintf('device ID: %1.0f\n', dev(idx(k)).deviceID);
                fprintf('device name: %s\n', dev(idx(k)).name);
                fprintf('host API: %s\n', dev(idx(k)).hostAPI);
                fprintf('max # input channels: %1.0f\n', dev(idx(k)).inputChans);
                fprintf('max # output channels: %1.0f\n', dev(idx(k)).outputChans);
                fprintf('\n');
            end
            
        else
            
            devID = [];
            fprintf('no matching devices found.\n');
            fprintf('\n');
            
        end
        
    end

