%% Section 4: Cycle through the hours and load all the models for each hour and record memory use
% We use an index named 'StartHour' in our loop
HourMem = 0; % storage variable for the maximum memory in use by our data variable
StartLat = 1; % starting latitude
NumLat = 400; % number of latitude positions
StartLon = 1; % starying longitude
NumLon = 700; % number of lingitude positions
StartHour = 1; % starting time for analyises
NumHour = 1; % Number of hours of data to load

% loop through the hours loading one at a time
for StartHour = 1:25
    Models2Load = [1, 2, 4, 5, 6, 7, 8]; % list of models to load
    idxModel = 0; % current model
    for idx = 1:7
        idxModel = idxModel + 1; % move to next model index
        LoadModel = Models2Load(idx);% which model to load
        HourlyData(idxModel,:,:,:) = ncread(FileName, Contents.Variables(LoadModel).Name,...
            [StartLon, StartLat, StartHour], [NumLon, NumLat, NumHour]);
        fprintf('Loading %s\n', Contents.Variables(LoadModel).Name); % display loading information
    end
    
    % Record the maximum memory used by the data variable so far
    HourMem = max( [ HourMem, whos('HourlyData').bytes/1000000 ] );
    fprintf('Loaded Hour %i, memory used: %.3f MB\n', StartHour, HourMem); % display loading information
end
