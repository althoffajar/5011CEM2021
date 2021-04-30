%% Script to examine NetCDF data formats and check for NaN
% Note, you would carry out this test each time you load data.
% You should NOT test the whole file at the start

clear all
close all


%% Test File with Errors
NaNErrors = 0;
%% Set file to test
DataFileName = '../Model/TestFileNaN.nc'; % define our test file
FileName = Users/althof/Documents/MATLAB/5011CEM/Model/TestFileNaN.nc'; % define our test file % un rem this line to see what happens with good data
Contents = ncinfo(DataFileName); % Store the file content information in a variable.

%% Create and open log file
LogFileName = 'AnalysisLog.txt';

% create new log file, 'w' replaces the file if present. To continually
% append, use 'a'
LogID = fopen('AnalysisLog.txt', 'w');
fprintf(LogID, '%s: Starting analysis of %s\n', datestr(now, 0), DataFileName);

StartLat = 1;
StartLon = 1;

fprintf('Testing files: %s\n', DataFileName)
for idxHour = 1:25
    
    for idxModel = 1:8
        Data(idxModel,:,:) = ncread(DataFileName, Contents.Variables(idxModel).Name,...
            [StartLat, StartLon, idxHour], [inf, inf, 1]); % 'inf' reads all the data
    end
    
    % check for NaNs
    if any(isnan(Data), 'All')
        NaNErrors = 1;
        %% display warning
        fprintf('NaNs present\n')
        ErrorModel = find(isnan(Data), 1, 'first');
        %% find first error:
        fprintf('Analysis for hour %i is invalid, NaN errors recorded in model %s\n',...
            idxHour, Contents.Variables(ErrorModel).Name)
        
        % Write to log file
        fprintf(LogID, '%s: %s processing data hour %i\n', datestr(now, 0), 'NaN Error', idxHour);
    else
        % write to log file
        fprintf(LogID, '%s: %s processing data hour %i\n', datestr(now, 0), 'Success', idxHour);
    end
    
end
 fclose(LogID);

if ~NaNErrors
    fprintf('No errors!\n')
end