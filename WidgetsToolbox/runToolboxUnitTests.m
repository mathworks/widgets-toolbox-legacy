function testResult = runToolboxUnitTests()

%% Run traditional figure tests
% Find test location
toolboxRoot = fileparts(mfilename('fullpath'));
unitTestPath = fullfile(toolboxRoot,'test');

% Run tests
testResult = runtests(unitTestPath);

% Assign in base just in case
assignin('base','wtTestResult',testResult);



%% Run uifigure tests

if ~verLessThan('matlab','9.9')
    
    % Find test location
    unitTestPath = fullfile(toolboxRoot,'test_uifigure');
    
    % Run tests
    testResult2 = runtests(unitTestPath);
    
    % Assign in base just in case
    assignin('base','wtTestResult_uifigure',testResult2);
    
    % Combine results
    testResult = horzcat(testResult, testResult2);
    
end