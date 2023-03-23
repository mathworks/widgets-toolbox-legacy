function tests = testDemos()

% Unit Test - Implements a unit test for a widget or component

% Copyright 2018 The MathWorks,Inc.
%
% 
% 
% 
% 
% 
% ---------------------------------------------------------------------

% Indicate to test the local functions in this file
tests = functiontests(localfunctions);

end %function


%% Test each demo
function testEachDemo(testCase)

% Get a list of demo files
fileList = what(fullfile(widgetsRoot,'demo'));
demoFiles = vertcat(fileList.m, fileList.mlx);
demoFiles = demoFiles(strncmpi(demoFiles,'demo',4));

for idx = 1:numel(demoFiles)
    
    [~,thisDemo,~] = fileparts(demoFiles{idx});
    
    % Verify
    fcn = str2func(thisDemo);
    
    % Run the demo
    verifyWarningFree(testCase,fcn)
    
end %for

try %#ok<TRYNC>
    close all force
end

end %function
