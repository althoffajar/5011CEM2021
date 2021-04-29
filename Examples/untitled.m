
%% Automated Testing
for idx = 1:10
	Results = feval('TestDemo01', idx)
end

for idx = 1:10
    Result = feval('TestDemo01', idx);
    TestResults(idx,:) = [idx, Result];
end


%% Break Testing
for idx = -10:10
    Result = feval('TestDemo01', idx);
    TestResults(idx+11,:) = [idx, Result];
end
