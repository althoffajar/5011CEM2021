function EV = EnsembleValue(Data, LatLon, RadLat, RadLon, RadO3)

%ENSEMBLEVALUE Summary of this function goes here
%   Detailed explanation goes here


Data4Cluster = [Data(:),LatLon];
[Clusters, Results] = DDC_ver01_1_CAMS(Data4Cluster, [RadLat, RadLon, RadO3], 0, 0);
MostCommonCluster = mode(Results(:,end));
EV = Clusters.Centre(MostCommonCluster);
    
end
