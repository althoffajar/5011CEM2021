%% Automated Testing

StartLat = 1;
NumLat = 400;
StartLon = 1;
NumLon = 700;
tic
for CurrentData = DataOptions
  for currentPoolsize = PoolSizes
    for idxTime = 1:1

    %% 5: Load the data for each hour
    % Each hour we read the data from the required models, defined by the
    % index variable. Each model data are placed on a 'layer' of the 3D
    % array resulting in a 7 x 700 x 400 array.
    % We do this by indexing through the model names, then defining the
    % start position as the beginnning of the Lat, beginning of the Lon and
    % beginning of the new hour. We then define the number of elements
    % along each data dimension, so the total number of Lat, the total
    % number of Lon, but only 1 hour.
    % You can use these values to select a smaller sub-set of the data if
    % required to speed up testing o fthe functionality.
    
    DataLayer = 1;
    for idx = [1, 2, 4, 5, 6, 7, 8]
        
        HourlyData(DataLayer,:,:) = ncread(FileName, Contents.Variables(idx).Name,...
            [StartLon, StartLat, idxTime], [NumLon, NumLat, 1]);
        DataLayer = DataLayer + 1;
    end
    
    %% 6: Pre-process the data for parallel processing
    % This takes the 3D array of data [model, lat, lon] and generates the
    % data required to be processed at each location.
    % ## This process is defined by the customer ##
    % If you want to know the details, please ask, but this is not required
    % for the module or assessment.
    [Data2Process, LatLon] = PrepareData(HourlyData, Lat, Lon);
        
     %% 7: Create the parallel pool and attache files for use
    % This code is inside the loop for ease of reading by keeping all
    % parallel processing code together. The parallel pool need only be
    % created once, then this can be moved outside the idxTime loop.
    PoolSize = currentPoolsize; % define the number of threads to use in parallel
    
    maxNumCompThreads(PoolSize); % ~~~ NEW LINE ADDED FOR MATLAB ONLINE ~~~
    if isempty(gcp('nocreate'))
        parpool('threads'); % ~~~ CHANGE TO CODE FOR MATLAB ONLINE ~~~
    end
    poolobj = gcp;
    % attaching a file allows it to be available at each processor without
    % passing the file each time. This speeds up the process. For more
    % information, ask your tutor.
    addAttachedFiles(poolobj,{'EnsembleValue'});
%% Parallel Analysis

    
    
    %% 9: The actual parallel processing!
    % Ensemble value is a function defined by the customer to calculate the
    % ensemble value at each location. Understanding this function is not
    % required for the module or the assessment, but it is the reason for
    % this being a 'big data' project due to the processing time (not the
    % pure volume of raw data alone).
    T4 = toc;
    parfor idx = 1:CurrentData
        [EnsembleVectorPar(idx, idxTime)] = EnsembleValue(Data2Process(idx,:,:,:), LatLon, RadLat, RadLon, RadO3);
    end
   
    T3(idxTime) = toc - T4; % record the parallel processing time for this hour of data
    fprintf('Parallel processing time for hour %i : %.1f s\n', idxTime, T3(idxTime))
    
    %% if Statements to extract processing time
    if CurrentData == DataOptions(1) 
          Records1 = [Records1,T3(idxTime)]
          RecordPoolSize1 = [RecordPoolSize1, currentPoolsize]
    elseif CurrentData == DataOptions(2)
          Records2 = [Records2,T3(idxTime)]
          RecordPoolSize2 = [RecordPoolSize2, currentPoolsize]
    else
          Records3 = [Records3,T3(idxTime)]
          RecordPoolSize3 = [RecordPoolSize3, currentPoolsize]
    end
    end
    delete(gcp);
end % end time loop
T2 = toc;
end % end function