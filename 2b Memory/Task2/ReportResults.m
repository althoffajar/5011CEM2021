%% Section 5: Print our results
fprintf('\nResults:\n')

fprintf('Memory used for all data: %.2f MB\n', AllDataMem)

fprintf('Memory used for hourly data: %.2f MB\n', HourlyData)
%fprintf('Memory used for hourly data: %.2f MB\n', HourDataMem)

fprintf('Maximum memory used hourly = %.2f MB\n', HourMem)

fprintf('Hourly memory as fraction of all data = %.2f\n\n', HourMem / AllDataMem)
