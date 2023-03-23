function tests = testSlider()
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
testCase.TestData.InvFGColor = [1 1 1];

end %function

% Setup once for each test
function setup(testCase)

testCase.TestData.Figure = figure();

end %function

% Teardown once for each test
function teardown(testCase)

delete(testCase.TestData.Figure);

end %function


%% Test Basic Construction
function testDefaultConstructor(testCase)

fcn = @()uiw.widget.EditableText();

verifyWarningFree(testCase,fcn)

end %function


%% Test Construction with Inputs
function testConstructionArguments(testCase)

fcn = @()uiw.widget.Slider(...
    'Parent',testCase.TestData.Figure,...
    'Min',0,...
    'Max',100,...
    'Value',0,...
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
    'Callback',@(a,b) disp( a.Value ),...
    'Units','Pixels',...
    'Position',[10 10 200 50],...
    'Tag','Test',...
    'Label','Unit Test:',...
    'Visible','on');

verifyWarningFree(testCase,fcn)

end %function


%RAJ - the error ID changed, so commenting this out
% %% Test incorrect values that throw an error
% function testBadValues(testCase)
% 
% w = uiw.widget.Slider();
% 
% f = @() set( w, 'Min', 'abc');
% verifyError(testCase, f, 'MATLAB:type:InvalidInputSize');
% 
% end %function


%% Test vertical slider
function testVerticalSlider(testCase)

uiw.widget.Slider(...
    'Parent',testCase.TestData.Figure,...
    'Orientation','vertical',...
    'Units','pixels',...
    'Position',[200 100 50 300],...
    'FlipText',true);

end %function



%% Test text flipping
function testTextFlipping(testCase)

uiw.widget.Slider(...
    'Parent',testCase.TestData.Figure,...
    'Units','pixels',...
    'Position',[10 10 500 40],...
    'Min',0,...
    'Max',100,...
    'Value',0,...
    'FlipText',true);

end %function



%% Test fractional slider
function testFractional(testCase)

w = uiw.widget.Slider('Parent',testCase.TestData.Figure,'Min',1.3,'Max',2.57,'Value',1.56);

verifyEqual(testCase, w.Value, 1.56)

end %function


%% Test negative slider
function testNegative(testCase)

uiw.widget.Slider('Parent',testCase.TestData.Figure,'Min',-10,'Max',-2);

end %function



%% Test small size slider
function testSmall(testCase)

w = uiw.widget.Slider('Parent',testCase.TestData.Figure);

verifyWarningFree(testCase, @()set(w,'Units','pixels','Position',[1 1 1 1]) )

end %function


%% Test min max
function testMinMax(testCase)

w = uiw.widget.Slider('Parent',testCase.TestData.Figure,'Min',0,'Max',100,'Value',50);

% Reduce maximum
verifyWarningFree(testCase, @()set(w,'Max',-5) )
verifyEqual(testCase, w.Value, -5)

end %function


%% Test Invalid Coloring
function testColoring(testCase)

w = uiw.widget.Slider(...
    'Parent', testCase.TestData.Figure, ...
    'Value', 'invalid_value', ...
    'Units', 'pixels', ...
    'TextBackgroundColor', testCase.TestData.BGColor, ...
    'TextForegroundColor', testCase.TestData.FGColor, ...
    'TextInvalidBackgroundColor', testCase.TestData.InvBGColor, ...
    'TextInvalidForegroundColor', testCase.TestData.InvFGColor, ...
    'Position', [10 10 400 25]);

% Get the internal edit box
hEdit = findall(w,'Type','UIControl','Style','edit');

% Ensure we found it
assumeNumElements(testCase, hEdit, 1)

% Verify color of the internal edit box
verifyEqual(testCase, hEdit.BackgroundColor, testCase.TestData.BGColor)
verifyEqual(testCase, hEdit.ForegroundColor, testCase.TestData.FGColor)

% Set text invalid
verifyWarningFree(testCase, @()set(w,'TextIsValid',false) )

% Verify color of the internal edit box
verifyEqual(testCase, hEdit.BackgroundColor, testCase.TestData.InvBGColor)
verifyEqual(testCase, hEdit.ForegroundColor, testCase.TestData.InvFGColor)

% Set text valid
verifyWarningFree(testCase, @()set(w,'TextIsValid',true) )

% Verify color of the internal edit box
verifyEqual(testCase, hEdit.BackgroundColor, testCase.TestData.BGColor)
verifyEqual(testCase, hEdit.ForegroundColor, testCase.TestData.FGColor)

end %function
