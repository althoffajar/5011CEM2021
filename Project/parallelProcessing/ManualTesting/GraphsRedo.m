%% Plotting graphs in Matlab
clear all
close all


%% Show two plots on different y-axes
%% 40000 data processed
%{
x1Vals = [1,2,3,4, 5, 6, 7];
y1Vals = [497.96,246.35,177.99, 144.21, 143.08 , 134.25, 120.90];
figure(1)
yyaxis left
hold on
plot(x1Vals, y1Vals, '-b')
plot(x1Vals, y1Vals, 'p','MarkerSize',10,...
    'MarkerEdgeColor','blue')
xlabel('Number of Processors')
ylabel('Processing time (s)')
title('Processing time vs number of processors')
%}

%% 80000 data processed


x2Vals = [ 4, 5, 6, 7];
y2Vals = [292.53,254.43,239.95,215.05];
figure(1)
yyaxis right
hold on
plot(x2Vals, y2Vals, '-r')
plot(x2Vals, y2Vals, '-s','MarkerSize',10,...
    'MarkerEdgeColor','red',...
    'MarkerFaceColor',[1 .6 .6])
xlabel('Number of Processors')
ylabel('Processing time (s)')
title('Processing time vs number of processors')


%% 10000 data processed

%{
x3Vals = [1, 2, 3, 4, 5, 6, 7, 8];
y3Vals = [120.92, 64.74, 43.83, 35.39,32.91,33.54,31.87,36.74];
figure(1)
yyaxis right
hold on
plot(x3Vals, y3Vals, 'm')
plot(x3Vals, y3Vals, 'v', 'MarkerSize',10,...
    'MarkerEdgeColor','magenta')
xlabel('Number of Processors')
ylabel('Processing time (s)')
title('Processing time vs number of processors')
%}

%legend('40,000 Data','40,000 Data plot','80,000 Data', '80,000 Data Plot',...
%'10,000 Data','10,000 Data Plot')

legend('80,000 Data','80,000 Data plot')

% Plots the Y for 80000
%yLinear = 386.1 - 24.69*x2Vals
%% Show two plots on same y-axis
%% Mean processing time
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