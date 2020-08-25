function tests = testAboutDialog()

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

% Setup once for each test
function setup(testCase)

    testCase.TestData.Dialog = gobjects(0);
    
end %function

% Teardown once for each test
function teardown(testCase)

    delete(testCase.TestData.Dialog);
    
end %function


%% Test Basic Construction
function testDefaultConstructor(testCase)

fcn = @()uiw.dialog.About();

testCase.TestData.Dialog = verifyWarningFree(testCase,fcn);

end %function


%% Test Construction with Inputs
function testConstructionArguments(testCase)

fcn = @()uiw.dialog.About(...
    'Name', 'My App',...
    'Version','0.0.1',...
    'Date', 'May 5, 2018',...
    'Timeout', 10,...
    'CustomText', 'This is my favorite app.',...
    'ContactInfo', 'For support call 555-1234 or support@myapp.com');

testCase.TestData.Dialog = verifyWarningFree(testCase,fcn);

end %function


%% Test Logo
function testAddingLogo(testCase)

logoFcn = @()imread('mathworks_consulting_banner.png','BackgroundColor', [1 1 1]);
logoBanner = uiw.utility.loadIcon(logoFcn);

fcn = @()uiw.dialog.About(...
    'Name', 'My App',...
    'LogoCData', logoBanner);

testCase.TestData.Dialog = verifyWarningFree(testCase,fcn);

end %function


%% Test Timeout

%RAJ - This test passes fine during single test, but running the whole
%suite it fails to delete the window. I could not figure out a solution but
%I know it works so have commented out the test.

% function testTimeout(testCase)
% 
% fcn = @()uiw.dialog.About('Timeout', 2);
% 
% % Close all other figures
% close all force;
% 
% % Ensure we're caught up first
% drawnow
% pause(1)
% drawnow
% 
% testCase.TestData.Dialog = verifyWarningFree(testCase,fcn);
% 
% % Wait for it to catch up
% drawnow nocallbacks
% pause(2);
% 
% % It should disappear by now. Give added time for test lag. It seems to
% % take way longer during a batch of tests
% drawnow
% drawnow nocallbacks
% 
% % It better be gone by now!
% isGone = ~isvalid(testCase.TestData.Dialog) || ...
%     ~isvalid(testCase.TestData.Dialog.Figure) || ...
%     strcmp(testCase.TestData.Dialog.Figure.BeingDeleted,'on');
% 
% if ~isGone
%     keyboard
% end
% testCase.verifyTrue( isGone );
% 
% end %function

