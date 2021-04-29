%% This script allows you to open and explore the data in a *.nc file
clear all
close all

FileName = '5011CEM/Model/o3_surface_20180701000000.nc';


Contents = ncinfo(FileName);

Lat = ncread(FileName, 'lat'); % load the latitude locations
Lon = ncread(FileName, 'lon'); % loadthe longitude locations

%% Processing parameters provided by customer
RadLat = 30.2016; % cluster radius value for latitude
RadLon = 24.8032; % cluster radius value for longitude
RadO3 = 4.2653986e-08; % cluster radius value for the ozone data

%% Cycle through the hours and load all the models for each hour and record memory use
% We use an index named 'NumHour' in our loop
% The section 'sequential processing' will process the data location one
% after the other, reporting on the time involved.

StartLat = 1; % latitude location to start laoding
NumLat = 400; % number of latitude locations ot load
StartLon = 1; % longitude location to start loading
NumLon = 700; % number of longitude locations ot load
tic
%% Arrays for storage are created
    %% Automated Testing
idxTime = 1:1; %Customer can change the hours
plot = []
DataOptions = [100,500,400]; %Determines Option Sizes, maximum ammount -> 2
PoolSizes = [1,2,3,4];
% Stored the recorded processing time
Result1Parallel = []
Result2Parallel = []
Result3Parallel = []
Result1Sequential = []
Result2Sequential = []
Result3Sequential = []
% Stored Parallel Processes
RecordPoolSize1 = []
RecordPoolSize2 = []
RecordPoolSize3 = []

%% Sequential Processing
for CurrentData = DataOptions
   %% Cycle through the hours and load all the models for each hour and record memory use
   for NumHour = 1:1 %task 1
   %NumHour = 1:3  %Task 3
   % #Task 2 : for NumHour = 1:3 %loop through 1 hour every one hour
   CurrentHour = NumHour; %To store number of hour
   fprintf('Data size %i\n', CurrentData)
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
    for idx = 1:CurrentData
        [EnsembleVector(idx, NumHour)] = EnsembleValue(Data2Process(idx,:,:,:), LatLon, RadLat, RadLon, RadO3);
        
        % To monitor the progress we will print out the status after every
        % 50 processes.
        if idx/50 == ceil(idx/50)
            tt = toc-t2;
            fprintf('Total %i of %i, last 50 in %.2f s  predicted time for all data %.1f s\n',...
                idx, size(Data2Process,1), tt, size(Data2Process,1)/50*25*tt)
            t2 = toc;
        end
    end 
    T2(NumHour) = toc - t1; % record the total processing time for this hour
    fprintf('Processing hour %i - %.2f s\n\n', NumHour, sum(T2));
    
    if CurrentData == DataOptions(1)
       Result1Sequential = [Result1Sequential,t2]
    elseif CurrentData == DataOptions(2)
       Result2Sequential = [Result2Sequential,t2]
    else
       Result3Sequential = [Result3Sequential,t2]
    end
  end
end



%% Parallel Processing

 %% Cycle through the hours and load all the models for each hour and record memory use
 % We use an index named 'idxTime' in our loop
 % The section 'parallel processing' will process the data location one
 % after the other, reporting on the time involved.
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
    delete(gcp);
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
          Result1Parallel = [Result1Parallel,T3(idxTime)]
          RecordPoolSize1 = [RecordPoolSize1, currentPoolsize]
    elseif CurrentData == DataOptions(2)
          Result2Parallel  = [Result2Parallel,T3(idxTime)]
          RecordPoolSize2 = [RecordPoolSize2, currentPoolsize]
    else
          Result3Parallel  = [Result3Parallel,T3(idxTime)]
          RecordPoolSize3 = [RecordPoolSize3, currentPoolsize]
    end
    end
    delete(gcp);
end % end time loop
T2 = toc;
end % end function   


      
%% Automated Plotting

x1Vals = Result1Parallel;
y1Vals = RecordPoolSize1;
y1seq = Result1Parallel;
x1seq = [1];
figure(1)
yyaxis left
hold on
plot(x1Vals, y1Vals, '-bo')
plot(x1seq, y1seq, 'p','MarkerSize',10,...
    'MarkerEdgeColor','blue')
xlabel('Number of Processors')
ylabel('Processing time (s)')
title('Processing time vs number of processors')

x2Vals = Result2Parallel ;
y2Vals = RecordPoolSize2;
y2seq = Result2sequential;
x2seq = [1];
figure(1)
yyaxis right
hold on
plot(x2Vals, y2Vals, '-rs')
plot(x2seq, y2seq, '-s','MarkerSize',10,...
    'MarkerEdgeColor','red',...
    'MarkerFaceColor',[1 .6 .6])
xlabel('Number of Processors')
ylabel('Processing time (s)')
title('Processing time vs number of processors')

x3Vals = Result3Parallel ;
y3Vals = RecordPoolSize3;
y3seq = Result3sequential;
x3seq = [1];
figure(1)
yyaxis right
hold on
plot(x3Vals, y3Vals, '-g*')
plot(x3seq, y3seq, 'v', 'MarkerSize',10,...
    'MarkerEdgeColor','green')
xlabel('Number of Processors')
ylabel('Processing time (s)')
title('Processing time vs number of processors')


legend('40,000 Data','40,000 Data sequential','80,000 Data', '80,000 Data sequential',...
'10,000 Data','10,000 Data sequential')


% Mean processing time
y1MeanVals = y1Vals / 40000;
y2MeanVals = y2Vals / 80000;
y3MeanVals = y3Vals / 10000;

figure(2)
plot(x1Vals, y1MeanVals, '-bd')
plot(x1Vals, y1MeanVals, 'MarkerSize',10,...
    'MarkerEdgeColor','blue')
hold on
plot(x2Vals, y2MeanVals, '-rx')
plot(x2Vals, y2MeanVals, '-s','MarkerSize',10,...
    'MarkerEdgeColor','red',...
    'MarkerFaceColor',[1 .6 .6])
hold on
plot(x3Vals, y3MeanVals, 'm')
plot(x3Vals, y3MeanVals, 'v', 'MarkerSize',10,...
    'MarkerEdgeColor','magenta')

xlabel('Number of Processors')
ylabel('Processing time (s)')
title('Mean Processing time vs number of processors')
legend('40,000 Data','40,000 Data plot','80,000 Data', '80,000 Data Plot',...
'10,000 Data','10,000 Data Plot')

%% Fugure 2
y1MeanVals = y1Vals / DataOptions(1);
y2MeanVals = y2Vals / DataOptions(2);
y3MeanVals = y3Vals / DataOptions(3);
figure(2)
hold on
plot(x1Vals, y1MeanVals, '-bd')
plot(x2Vals, y2MeanVals, '-rx')
plot(x3Vals, y3MeanVals,'m')
xlabel('Number of Processors')
ylabel('Processing time (s)')
title('Mean Processing time vs number of processors')
legendtext1 = sprintf('% data',DataOptions(1));
legendtext2 = sprintf('% data',DataOptions(1));
legendtext3 = sprintf('% data',DataOptions(3));
legend(legendtext1,legendtext2,legendtext3);