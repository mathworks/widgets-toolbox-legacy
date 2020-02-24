function testResult = runToolboxUnitTests()

% Find test location
toolboxRoot = fileparts(mfilename('fullpath'));
unitTestPath = fullfile(toolboxRoot,'test');

% Run tests
testResult = runtests(unitTestPath);

% Assign in base just in case
assignin('base','wtTestResult',testResult);