
x1Vals = storeHour1;
y1Vals =  Result1;
figure(1)
yyaxis left
hold on
plot(x1Vals, y1Vals, '-b')
plot(x1Vals, y1Vals, 'p','MarkerSize',10,...
    'MarkerEdgeColor','blue')
xlabel('Number of Hours')
ylabel('Processing time (s)')
title('Processing time vs number of processors')
%legendText{1} = sprintf('% of data',Options(1));
legendText1 = sprintf('% f data',round(Options(1)));
legendText2 = sprintf('% f data plot',round(Options(1)));

x2Vals = storeHour2;
y2Vals =  Result2;
figure(1)
yyaxis right
hold on
plot(x2Vals, y2Vals, '-r')
plot(x2Vals, y2Vals, '-s','MarkerSize',10,...
    'MarkerEdgeColor','red',...
    'MarkerFaceColor',[1 .6 .6])
xlabel('Number of Hours')
ylabel('Processing time (s)')
title('Processing time vs number of processors')
%legendText{2} = sprintf('% f data',Options(2));
legendText3 = sprintf('% f data',round(Options(2)));
legendText4 = sprintf('% f data plot',round(Options(2)));


x3Vals = storeHour3;
y3Vals =  Result3;
figure(1)
yyaxis right
hold on
plot(x3Vals, y3Vals, 'm')
plot(x3Vals, y3Vals, 'v', 'MarkerSize',10,...
    'MarkerEdgeColor','magenta')
xlabel('Number of Hours')
ylabel('Processing time (s)')
title('Mean Processing time vs number of processors')
%legendText{3} = sprintf('% data',Options(3));
legendText5 = sprintf('% f data',round(Options(3)));
legendText6 = sprintf('% f data plot',round(Options(3)));

hold on
legend('Location','northwest')
%legend(legendText)
legend(legendText1, legendText2, legendText3, legendText4, legendText5, legendText6)



   