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
Options = [10, 232, 300]; % Chooses different number of data, maximum of 3 different data
Plot = []; 
% Stored the recorded processing time
Result1 = []
Result2 = []
Result3 = []
% Stored each number of hours
storeHour1 = []
storeHour2 = []
storeHour3 = []
%% Starts Automated Testing!
for CurrentData = Options
   %% Cycle through the hours and load all the models for each hour and record memory use
   for NumHour = 1: %task 1

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
    
    %% Break Tests
    if any(isnan(Lat,Lon), 'All')
        NaNErrors = 1;
        % display warning
        fprintf('NaNs present\n')
        ErrorModel = find(isnan(Data), 1, 'first');
        % find first error:
        fprintf('Analysis for hour %i is invalid, NaN errors recorded in model %s\n',...
            idxHour, Contents.Variables(ErrorModel).Name) 
        break
    else
        continue
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
    %Plot(CurrentData,:)=[Options(CurrentData),tSeq];
    %If statements to extract results  as an array for plotting
    if CurrentData == Options(1)
        Result1 = [Result1,t2]
        storeHour1 = [storeHour1,CurrentHour]
    elseif CurrentData == Options(2)
        Result2 = [Result2,t2]
        storeHour2 = [storeHour2, CurrentHour]
    else
        Result3 = [Result3,t2]
        storeHour3 = [storeHour3, CurrentHour]
    end
  end
end

disp(num2str(Plot));


%% Automated Plotting

x1Vals = storeHour1;
y1Vals =  Result1;
figure(1)
yyaxis left
hold on
plot(x1Vals, y1Vals, '-b')
plot(x1Vals, y1Vals, 'p','MarkerSize',10,...
    'MarkerEdgeColor','blue')
xlabel('Number of Hours')
ylabel('Processing time (s)')
title('Processing time vs number of processors')
%legendText{1} = sprintf('% of data',Options(1));
legendText1 = sprintf('% f data',round(Options(1)));
legendText2 = sprintf('% f data plot',round(Options(1)));

x2Vals = storeHour2;
y2Vals =  Result2;
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
legendText3 = sprintf('% f data',round(Options(2)));
legendText4 = sprintf('% f data plot',round(Options(2)));


x3Vals = storeHour3;
y3Vals =  Result3;
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
legendText5 = sprintf('% f data',round(Options(3)));
legendText6 = sprintf('% f data plot',round(Options(3)));

hold on
legend('Location','northwest')
%legend(legendText)
legend(legendText1, legendText2, legendText3, legendText4, legendText5, legendText6)



    
