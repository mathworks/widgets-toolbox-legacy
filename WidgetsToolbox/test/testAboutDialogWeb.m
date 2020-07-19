function tests = testAboutDialog()

% Unit Test - Implements a unit test for a widget or component

% Copyright 2018 The MathWorks,Inc.
%
% Auth/Revision:
% MathWorks Consulting
% $Author: rjackey $
% $Revision: 154 $
% $Date: 2018-05-30 14:34:04 -0400 (Wed, 30 May 2018) $
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
function testTimeout(testCase)

fcn = @()uiw.dialog.About('Timeout', 2);

testCase.TestData.Dialog = verifyWarningFree(testCase,fcn);

pause(3);

testCase.verifyFalse( isvalid(testCase.TestData.Dialog) );

end %function

