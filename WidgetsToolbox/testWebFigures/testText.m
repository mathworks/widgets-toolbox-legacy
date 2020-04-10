function tests = testText()

% Unit Test - Implements a unit test for a widget or component

% Copyright 2018 The MathWorks,Inc.
%
% Auth/Revision:
% MathWorks Consulting
% $Author: rjackey $
% $Revision: 253 $
% $Date: 2018-10-05 08:50:12 -0400 (Fri, 05 Oct 2018) $
% ---------------------------------------------------------------------

% Indicate to test the local functions in this file
tests = functiontests(localfunctions);

end %function

% Setup once for all tests
function setupOnce(testCase)

testCase.TestData.BGColor = [0.94 0.94 0.94];
testCase.TestData.FGColor = [0 0 0];
testCase.TestData.InvBGColor = [1 0 0];
testCase.TestData.InvFGColor = [1 1 1];

end %function

% Setup once for each test
function setup(testCase)

testCase.TestData.Figure = uifigure();

end %function

% Teardown once for each test
function teardown(testCase)

delete(testCase.TestData.Figure);

end %function


%% Test Basic Construction
function testDefaultConstructor(testCase)

fcn = @()uiw.widget.Text();

verifyWarningFree(testCase,fcn)

end %function


%% Test Compatibility with old FixedText name
function testCompatibilityForFixedText(testCase)

fcn = @()uiw.widget.FixedText();

verifyWarningFree(testCase,fcn)

end %function


%% Test Construction with Inputs
function testConstructionArguments(testCase)

fcn = @()uiw.widget.Text(...
    'Parent',testCase.TestData.Figure,...
    'Value','abcdef',...
    'ForegroundColor',[0 1 0],...
    'BackgroundColor',[0.5 0.5 0.5],...
    'FontAngle','normal',...
    'FontName','MS Sans Serif',...
    'FontSize',12,...
    'FontWeight','normal',...
    'TextEditable','on',...
    'TextHorizontalAlignment','center',...
    'TextBackgroundColor', testCase.TestData.BGColor, ...
    'TextForegroundColor', testCase.TestData.FGColor, ...
    'TextInvalidBackgroundColor', testCase.TestData.InvBGColor, ...
    'TextInvalidForegroundColor', testCase.TestData.InvFGColor, ...
    'TextIsValid',true,...
    'Units','Pixels',...
    'Position',[10 10 200 50],...
    'Tag','Test',...
    'Label','Unit Test:',...
    'Visible','on');

verifyWarningFree(testCase,fcn)

end %function


%% Test Value set
function testFieldTypes(testCase)
    
w = uiw.widget.Text('Parent', testCase.TestData.Figure);

verifyWarningFree(testCase, @()set(w,'Value','test test test') )
verifyEqual(testCase, w.Value, 'test test test')

end %function


%% Test Invalid Coloring
function testColoring(testCase)

w = uiw.widget.Text(...
    'Parent', testCase.TestData.Figure, ...
    'Value', 'abcdef', ...
    'Units', 'pixels', ...
    'TextBackgroundColor', testCase.TestData.BGColor, ...
    'TextForegroundColor', testCase.TestData.FGColor, ...
    'TextInvalidBackgroundColor', testCase.TestData.InvBGColor, ...
    'TextInvalidForegroundColor', testCase.TestData.InvFGColor, ...
    'Position', [10 10 400 25]);

% Get the internal text box
hText = findall(w,'Type','UIControl','Style','text','String','abcdef');

% Ensure we found it
assumeNumElements(testCase, hText, 1)

% Verify color of the internal edit box
verifyEqual(testCase, hText.BackgroundColor, testCase.TestData.BGColor)
verifyEqual(testCase, hText.ForegroundColor, testCase.TestData.FGColor)

% Set text invalid
verifyWarningFree(testCase, @()set(w,'TextIsValid',false) )

% Verify color of the internal edit box
verifyEqual(testCase, hText.BackgroundColor, testCase.TestData.InvBGColor)
verifyEqual(testCase, hText.ForegroundColor, testCase.TestData.InvFGColor)

% Set text valid
verifyWarningFree(testCase, @()set(w,'TextIsValid',true) )

% Verify color of the internal edit box
verifyEqual(testCase, hText.BackgroundColor, testCase.TestData.BGColor)
verifyEqual(testCase, hText.ForegroundColor, testCase.TestData.FGColor)

end %function