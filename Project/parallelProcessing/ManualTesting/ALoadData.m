%% 1: Load Data
clear all
close all

FileName = 'Users/althof/Documents/MATLAB/5011CEM/Model/o3_surface_20180701000000.nc';

Contents = ncinfo(FileName);

Lat = ncread(FileName, 'lat');
Lon = ncread(FileName, 'lon');
NumHours = 25;