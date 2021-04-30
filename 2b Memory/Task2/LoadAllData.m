%% This script allows you to open and explore the data in a *.nc file
clear all % clear all variables
close all % close all windows

FileName = 'Users/althof/Documents/MATLAB/5011CEM/Model/o3_surface_20180701000000.nc'; % define the name of the file to be used, the path is included

Contents = ncinfo(FileName); % Store the file content information in a variable.


%% Section 2: Load all the model data together
for idx = 1: 8
    AllData(idx,:,:,:) = ncread(FileName, Contents.Variables(idx).Name);
    fprintf('Loading %s\n', Contents.Variables(idx).Name); % display loading information
end

AllDataMem = whos('AllData').bytes/1000000;
fprintf('Memory used for all data: %.3f MB\n', AllDataMem)

%% Task 3
function [outputArg1,outputArg2] = untitled6(inputArg1,inputArg2)
%UNTITLED6 Summary of this function goes here
% Detailed explanation goes here
outputArg1 = inputArg1;
outputArg2 = inputArg2;
end

function [AllDataMem] = LoadAllData(FileName)
%% Task 3 Section 2: Load all the model data together
for idx = 1: 8
AllData(idx,:,:,:) = ncread(FileName, Contents.Variables(idx).Name);
fprintf('Loading %s\n', Contents.Variables(idx).Name); % display loading information
end