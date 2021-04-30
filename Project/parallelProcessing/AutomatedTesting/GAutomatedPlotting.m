%% Automated Plotting
x1Vals = RecordPoolSize1;  %Extracts PoolSize as a
y1Vals = Records1; %Extracts recorded time as the y axis
figure(1) % Plots them into a figure
yyaxis left
hold on
plot(x1Vals, y1Vals, '-b')
plot(x1Vals, y1Vals, 'p','MarkerSize',10,'MarkerEdgeColor','blue')
xlabel('Number of Hours')
ylabel('Processing time (s)')
title('Processing time vs number of processors')
%legendText{1} = sprintf('% of data',Options(1));
legendText1 = sprintf('% f data',round(DataOptions(1)));
legendText2 = sprintf('% f data plot',round(DataOptions(1)));

x2Vals = RecordPoolSize2;
y2Vals = Records2;
figure(1)
yyaxis right
hold on
plot(x2Vals, y2Vals, '-r')
plot(x2Vals, y2Vals, '-s','MarkerSize',10,'MarkerEdgeColor','red',...
    'MarkerFaceColor',[1 .6 .6])
xlabel('Number of Hours')
ylabel('Processing time (s)')
title('Processing time vs number of processors')
%legendText{2} = sprintf('% f data',Options(2));
legendText3 = sprintf('% f data',round(DataOptions(2)));
legendText4 = sprintf('% f data plot',round(DataOptions(2)));

x3Vals = RecordPoolSize3;
y3Vals =  Records3;
figure(1)
yyaxis right
hold on
plot(x3Vals, y3Vals, 'm')
plot(x3Vals, y3Vals, 'v', 'MarkerSize',10,'MarkerEdgeColor','magenta')
xlabel('Number of Hours')
ylabel('Processing time (s)')
title('Mean Processing time vs number of processors')
%legendText{3} = sprintf('% data',Options(3));
legendText5 = sprintf('% f data',round(DataOptions(3)));
legendText6 = sprintf('% f data plot',round(DataOptions(3)));

hold on
legend(legendText1, legendText2, legendText3, legendText4, legendText5, legendText6)

%% Fugure 2
y1MeanVals = y1Vals / DataOptions(1);
y2MeanVals = y2Vals / DataOptions(2);
y3MeanVals = y3Vals / DataOptions(3);
figure(2)
hold on
plot(x1Vals, y1MeanVals, '-bd')
plot(x2Vals, y2MeanVals, '-rx')
plot(x3Vals, y3MeanVals,'m')
xlabel('Number of Processors')
ylabel('Processing time (s)')
title('Mean Processing time vs number of processors')
legendtext1 = sprintf('% f  data',DataOptions(1));
legendtext2 = sprintf('% f data',DataOptions(1));
legendtext3 = sprintf('% f data',DataOptions(3));
legend(legendtext1,legendtext2,legendtext3);