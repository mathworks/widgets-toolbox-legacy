function tests = testLabelWeb()
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

% Setup once for all tests
function setupOnce(testCase)

testCase.TestData.BGColor = [1 1 1];
testCase.TestData.FGColor = [0 0 0];
testCase.TestData.InvBGColor = [1 0 0];
testCase.TestData.InvFGColor = [1 0 1];

testCase.TestData.Label = 'Unit Test - Label';
testCase.TestData.LabelFontName = 'Times New Roman';
testCase.TestData.LabelFontSize = 20;
testCase.TestData.LabelFontWeight = 'bold';
testCase.TestData.LabelHorizontalAlignment = 'center';
testCase.TestData.LabelFGColor = [0 1 1];
testCase.TestData.LabelTooltipString = 'label tooltip';
testCase.TestData.LabelLocation = 'top';
testCase.TestData.LabelHeight = 30;
testCase.TestData.LabelWidth = 50;
testCase.TestData.LabelSpacing = 7;
testCase.TestData.LabelVisible = 'on';

end %function

% Setup once for each test
function setup(testCase)

testCase.TestData.Figure = uifigure();

end %function

% Teardown once for each test
function teardown(testCase)

delete(testCase.TestData.Figure);

end %function


%% Test Label Default Constructor
function testDefaultConstructor(testCase)

fcn = @()uiw.widget.EditableText();

verifyWarningFree(testCase,fcn)

end %function


%% Test Label Visibility
function testLabelVisibility(testCase)

w = uiw.widget.EditableText();

verifyEqual(testCase, char(w.LabelVisible), 'off')
w.Label = 'test label';
verifyEqual(testCase, char(w.LabelVisible), 'on')

end %function


%% Test Construction with Inputs
function testConstructionArguments(testCase)
                
fcn = @()uiw.widget.EditableText(...
    'Parent',testCase.TestData.Figure,...
    'Label',testCase.TestData.Label,...
    'LabelFontName',testCase.TestData.LabelFontName,...
    'LabelFontSize',testCase.TestData.LabelFontSize,...
    'LabelFontWeight',testCase.TestData.LabelFontWeight,...
    'LabelForegroundColor',testCase.TestData.LabelFGColor,...
    'LabelHorizontalAlignment',testCase.TestData.LabelHorizontalAlignment,...
    'LabelTooltipString',testCase.TestData.LabelTooltipString,...
    'LabelLocation',testCase.TestData.LabelLocation,...
    'LabelHeight',testCase.TestData.LabelHeight,...
    'LabelWidth',testCase.TestData.LabelWidth,...
    'LabelSpacing',testCase.TestData.LabelSpacing,...
    'LabelVisible',testCase.TestData.LabelVisible,...
    'ForegroundColor',testCase.TestData.FGColor,...
    'BackgroundColor',testCase.TestData.BGColor,...
    'FontAngle','normal',...
    'FontName','Arial',...
    'FontSize',15,...
    'FontWeight','normal',...
    'FieldType','text',...
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
    'Visible','on');

verifyWarningFree(testCase,fcn)

end %function


%% Test Settings
function testSettings(testCase)

w = uiw.widget.EditableText(...
    'Parent',testCase.TestData.Figure,...
    'Label',testCase.TestData.Label,...
    'LabelFontName',testCase.TestData.LabelFontName,...
    'LabelFontSize',testCase.TestData.LabelFontSize,...
    'LabelFontWeight',testCase.TestData.LabelFontWeight,...
    'LabelForegroundColor',testCase.TestData.LabelFGColor,...
    'LabelHorizontalAlignment',testCase.TestData.LabelHorizontalAlignment,...
    'LabelTooltipString',testCase.TestData.LabelTooltipString,...
    'LabelLocation',testCase.TestData.LabelLocation,...
    'LabelHeight',testCase.TestData.LabelHeight,...
    'LabelWidth',testCase.TestData.LabelWidth,...
    'LabelSpacing',testCase.TestData.LabelSpacing,...
    'LabelVisible',testCase.TestData.LabelVisible,...
    'ForegroundColor',testCase.TestData.FGColor,...
    'BackgroundColor',testCase.TestData.BGColor,...
    'FontAngle','normal',...
    'FontName','Arial',...
    'FontSize',15,...
    'FontWeight','normal',...
    'FieldType','text',...
    'TextEditable','on',...
    'TextHorizontalAlignment','right',...
    'TextBackgroundColor', testCase.TestData.BGColor, ...
    'TextForegroundColor', testCase.TestData.FGColor, ...
    'TextInvalidBackgroundColor', testCase.TestData.InvBGColor, ...
    'TextInvalidForegroundColor', testCase.TestData.InvFGColor, ...
    'TextIsValid',true,...
    'Units','Pixels',...
    'Position',[10 10 200 50],...
    'Tag','Test',...
    'Visible','on');

% Verify each setting
verifyEqual(testCase, w.Label, testCase.TestData.Label)
verifyEqual(testCase, w.LabelFontName, testCase.TestData.LabelFontName)
verifyEqual(testCase, w.LabelFontSize, testCase.TestData.LabelFontSize)
verifyEqual(testCase, w.LabelFontWeight, testCase.TestData.LabelFontWeight)
verifyEqual(testCase, w.LabelForegroundColor, testCase.TestData.LabelFGColor)
verifyEqual(testCase, w.LabelHorizontalAlignment, testCase.TestData.LabelHorizontalAlignment)
verifyEqual(testCase, w.LabelTooltipString, testCase.TestData.LabelTooltipString)
verifyEqual(testCase, w.LabelLocation, testCase.TestData.LabelLocation)
verifyEqual(testCase, w.LabelHeight, testCase.TestData.LabelHeight)
verifyEqual(testCase, w.LabelWidth, testCase.TestData.LabelWidth)
verifyEqual(testCase, w.LabelSpacing, testCase.TestData.LabelSpacing)
verifyEqual(testCase, char(w.LabelVisible), testCase.TestData.LabelVisible)

verifyEqual(testCase, w.FontAngle, 'normal')
verifyEqual(testCase, w.FontName, 'Arial')
verifyEqual(testCase, w.FontSize, 15)
verifyEqual(testCase, w.FontWeight, 'normal')

verifyEqual(testCase, w.TextHorizontalAlignment, 'right')
verifyEqual(testCase, w.TextBackgroundColor, testCase.TestData.BGColor)
verifyEqual(testCase, w.TextForegroundColor, testCase.TestData.FGColor)

end %function