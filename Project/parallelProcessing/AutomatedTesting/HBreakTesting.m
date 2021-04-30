%% Break Testing
for idxHour = 1:25
    
    % check for NaNs
    if any(isnan(Hours), 'All')
        NaNErrors = 1;
        %% display warning
        fprintf('NaNs present\n')
        ErrorModel = find(isnan(Data), 1, 'first');
        %% find first error:
        
        fprintf('Analysis for hour %i is invalid, NaN errors recorded in model %s\n',...
            idxHour, Contents.Variables(ErrorModel).Name)
        
        %% Analysis will crash if we continue!
        % Set all data to zero, so analysis failure is obvious.
        Data = zeros(size(Data));
        % continue and carry out analysis?
        % Other techniques may be better, e.g. set all to (-1), or skip
        % analysis and set results which will be quicker, e.g:
        % Results = -(ones(700, 400));
    end
    
end
    
if ~NaNErrors
    fprintf('No errors!\n')


end