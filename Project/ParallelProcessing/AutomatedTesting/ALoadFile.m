%% This script allows you to open and explore the data in a *.nc file
clear all
close all

FileName = '5011CEM/Model/o3_surface_20180701000000.nc';


Contents = ncinfo(FileName);

Lat = ncread(FileName, 'lat'); % load the latitude locations
Lon = ncread(FileName, 'lon'); % loadthe longitude locations
