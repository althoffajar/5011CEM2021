%% 1: Load Data
clear all
close all

FileName = '5011CEM/Model/o3_surface_20180701000000.nc';

Contents = ncinfo(FileName);

Lat = ncread(FileName, 'lat');
Lon = ncread(FileName, 'lon');
NumHours = 25;

%% 2: Processing parameters
% ##  provided by customer  ##
RadLat = 30.2016;
RadLon = 24.8032;
RadO3 = 4.2653986e-08;

StartLat = 1;
NumLat = 400;
StartLon = 1;
NumLon = 700;

%% 3: Pre-allocate output array memory
% the '-4' value is due to the analysis method resulting in fewer output
% values than the input array.
NumLocations = (NumLon - 4) * (NumLat - 4);
EnsembleVectorPar = zeros(NumLocations, NumHours); % pre-allocate memory




    %% Automated Testing
    idxTime = 1:1; %Customer can change the hours
    DataOptions = [100,500,400]; %Determines Option Sizes, maximum ammount -> 2
    PoolSizes = [1,2,3,4];
    Records1 = []
    Records2 = []
    Records3 = []
    RecordPoolSize1 = []
    RecordPoolSize2 = []
    RecordPoolSize3 = []
    

%% 4: Cycle through the hours and load all the models for each hour and record memory use
% We use an index named 'idxTime' in our loop
% The section 'parallel processing' will process the data location one
% after the other, reporting on the time involved.

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
%% 10: Reshape ensemble values to Lat, lon, hour format
EnsembleVectorPar = reshape(EnsembleVectorPar, 696, 396, []);
fprintf('Total processing time for %i workers = %.2f s\n', PoolSize, sum(T3));

      
%% Automated Plotting
x1Vals = RecordPoolSize1;  %Extracts PoolSize as a
y1Vals = Records1; %Extracts recorded time as the y axis
figure(1) % Plots them into a figure
yyaxis left
hold on
plot(x1Vals, y1Vals, '-b')
plot(x1Vals, y1Vals, 'p','MarkerSize',10,...
    'MarkerEdgeColor','blue')
xlabel('Number of Hours')
ylabel('Processing time (s)')
title('Processing time vs number of processors')
%legendText{1} = sprintf('% of data',Options(1));
legendText1 = sprintf('% f data',round(DataOptions(1)));
legendText2 = sprintf('% f data plot',round(DataOptions(1)));

x2Vals = RecordPoolSize2;
y2Vals = Records2;
figure(1)
yyaxis right
hold on
plot(x2Vals, y2Vals, '-r')
plot(x2Vals, y2Vals, '-s','MarkerSize',10,...
    'MarkerEdgeColor','red',...
    'MarkerFaceColor',[1 .6 .6])
xlabel('Number of Hours')
ylabel('Processing time (s)')
title('Processing time vs number of processors')
%legendText{2} = sprintf('% f data',Options(2));
legendText3 = sprintf('% f data',round(DataOptions(2)));
legendText4 = sprintf('% f data plot',round(DataOptions(2)));

x3Vals = RecordPoolSize3;
y3Vals =  Records3;
figure(1)
yyaxis right
hold on
plot(x3Vals, y3Vals, 'm')
plot(x3Vals, y3Vals, 'v', 'MarkerSize',10,...
    'MarkerEdgeColor','magenta')
xlabel('Number of Hours')
ylabel('Processing time (s)')
title('Mean Processing time vs number of processors')
%legendText{3} = sprintf('% data',Options(3));
legendText5 = sprintf('% f data',round(DataOptions(3)));
legendText6 = sprintf('% f data plot',round(DataOptions(3)));

hold on
legend(legendText1, legendText2, legendText3, legendText4, legendText5, legendText6)

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
legendtext1 = sprintf('% f  data',DataOptions(1));
legendtext2 = sprintf('% f data',DataOptions(1));
legendtext3 = sprintf('% f data',DataOptions(3));
legend(legendtext1,legendtext2,legendtext3);