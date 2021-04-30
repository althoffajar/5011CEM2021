%% This script allows you to open and explore the data in a *.nc file
clear all
close all

FileName = '../Model/o3_surface_20180701000000.nc';

Contents = ncinfo(FileName);

%% List dimensions names
% if you select dimension 1, then tyou are selecting along the 'longitude'
% for our project we will select along the 'ntim' or 'time' dimension
fprintf('Data Dimension Names: %s, %s, %s\n',...
    Contents.Dimensions(1).Name,...
    Contents.Dimensions(2).Name,...
    Contents.Dimensions(3).Name)

%% List variable names
% note that variable 3 is an ensemble, we will NOT use this in our project!
% Not each model is 700 x 400 x 12 and we know that lat, lon and time match
% these numbers.
% To visulaise this 3D array think of it as a 700 x 400 grid for each model
% for one hour. These are stacked up 25 high.

NumVariables = size(Contents.Variables,2);
fprintf('Variable names and sizes:\n')
%for idx = 1: NumVariables
%    fprintf('%i %s  %i, %i, %i',...
%        idx, Contents.Variables(idx).Name, Contents.Variables(idx).Size);
%    fprintf('\n');
%end
for idx = 1:1
    fprintf('%i %s  %i, %i, %i',...
        idx, Contents.Variables(idx).Name, Contents.Variables(idx).Size);
    fprintf('\n');
    if idx = 1:1:1
        
    end
end

%% Selecting data
% We want to load models only, i.e. variables 1, 2, 4, 5, 6, 7, 8
% and we only want a single hour. We use indexing into our *.nc file:
% To load the variable 'chimere_ozone, starting at lat = 1, lon = 1 and
% hour = 1 we use:
StartLat = 1;
NumLat = 400;
StartLon = 1;
NumLon = 700;
StartHour = 1;
NumHour = 1;

Data = ncread(FileName, 'chimere_ozone', [StartLon, StartLat, StartHour], [NumLon, NumLat, NumHour]);

%% Cycling through the variable names
% We only want the models to load

for idx = [1, 2, 4, 5, 6, 7, 8]
    fprintf('Model %i : %s\n', idx, Contents.Variables(idx).Name);
end
