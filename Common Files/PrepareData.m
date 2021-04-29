function [ SegVector, LatLon ] = PrepareData(O3Data, Lat, Lon)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

fprintf('Creating segments....')

GeogSlice = 2;
DimSize = 2*GeogSlice+1;

% tic
SegLatLon = zeros(400-GeogSlice, 700-GeogSlice,7,2*GeogSlice+1,2*GeogSlice+1);
idxSeg = 0;


for idxLat = GeogSlice+1:400-GeogSlice
%         idxLat
    for idxLon = GeogSlice+1:700-GeogSlice
       SegLatLon(idxLat, idxLon, :, :, :) =...
           O3Data(:, idxLon-GeogSlice:idxLon+GeogSlice, idxLat-GeogSlice:idxLat+GeogSlice);
    end
end

fprintf('Segments created\n')

SegVector = reshape(SegLatLon,[],7,DimSize,DimSize);
LatSpace = abs(Lat(2)-Lat(1));
LatList = [1:DimSize]*LatSpace;
LonSpace = abs(Lon(2)-Lon(1));
LonList = [1:DimSize]*LonSpace;
[X, Y] = meshgrid(LonList,LatList);
LatLon = repmat([X(:),Y(:)], 7, 1);

end

