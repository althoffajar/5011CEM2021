for NumHour = 1:1 % loop through each hour
%for NumHour = 1:25  %Task 3
% #Task 2 : for NumHour = 1:3 %loop through 1 hour every one hour
    fprintf('Processing hour %i\n', NumHour)
    DataLayer = 1; % which 'layer' of the array to load the model data into
    for idx = [1, 2, 4, 5, 6, 7, 8] % model data to load
        % load the model data
        HourlyData(DataLayer,:,:) = ncread(FileName, Contents.Variables(idx).Name,...
            [StartLon, StartLat, NumHour], [NumLon, NumLat, 1]);
        DataLayer = DataLayer + 1; % step to the next 'layer'
    end
    % We need to prepare our data for processing. This method is defined by
    % our customer. You are not required to understand this method, but you
    % can ask your module leader for more information if you wish.
    [Data2Process, LatLon] = PrepareData(HourlyData, Lat, Lon);
       %% Sequential analysis    
    t1 = toc;
    t2 = t1;
    for idx = 1:200 % step through each data location to process the data
    % Original -> for idx = 1: size(Data2Process, 1) % step through each data location to process the data    
        % The analysis of the data creates an 'ensemble value' for each
        % location. This method is defined by
        % our customer. You are not required to understand this method, but you
        % can ask your module leader for more information if you wish.
        [EnsembleVector(idx, NumHour)] = EnsembleValue(Data2Process(idx,:,:,:), LatLon, RadLat, RadLon, RadO3);
        
        % To monitor the progress we will print out the status after every
        % 50 processes.
        if idx/50 == ceil( idx/50)
            tt = toc-t2;
            fprintf('Total %i of %i, last 50 in %.2f s  predicted time for all data %.1f s\n',...
                idx, size(Data2Process,1), tt, size(Data2Process,1)/50*25*tt)
            t2 = toc;
        end
    end
    T2(NumHour) = toc - t1; % record the total processing time for this hour
    fprintf('Processing hour %i - %.2f s\n\n', NumHour, sum(T2));
    
    end
tSeq = toc;

fprintf('Total time for sequential processing = %.2f s\n\n', tSeq)
