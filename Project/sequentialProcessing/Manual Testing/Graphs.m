%% Plotting graphs in Matlab
clear all
close all


%% Show two plots on different y-axes
%% 40000 data processed

x1Vals = [1,2,3];
y1Vals = [750.91, 1276.82, 1995.76];
figure(1)
yyaxis left
hold on
plot(x1Vals, y1Vals, '-b')
plot(x1Vals, y1Vals, 'p','MarkerSize',10,...
    'MarkerEdgeColor','blue')
xlabel('Number of Processors')
ylabel('Processing time (s)')
title('Processing time vs number of processors')


%% 80000 data processed


x2Vals = [1, 2, 3];
y2Vals = [1375.48,2855.12,4003.52];
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


x3Vals = [1,2,3];
y3Vals = [187.22, 358.34, 503.35];
figure(1)
yyaxis right
hold on
plot(x3Vals, y3Vals, 'm')
plot(x3Vals, y3Vals, 'v', 'MarkerSize',10,...
    'MarkerEdgeColor','magenta')
xlabel('Number of Processors')
ylabel('Processing time (s)')
title('Processing time vs number of processors')

hold on
legend('Location','northwest')
legend('40,000 Data','40,000 Data plot','80,000 Data', '80,000 Data Plot',...
'10,000 Data','10,000 Data Plot')


