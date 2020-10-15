function tests = testColorOrderSelector()
% Unit Test - Implements a unit test for a widget or component

% Copyright 2018 The MathWorks, Inc.
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

    testCase.TestData.Figure = figure();
    
end %function

% Teardown once for each test
function teardown(testCase)

    delete(testCase.TestData.Figure);
    
end %function


%% Test Basic Construction
function testDefaultConstructor(testCase)

fcn = @()uiw.widget.ColorOrderSelector();

verifyWarningFree(testCase,fcn)

end %function


%% Test Construction with Inputs
function testConstructionArguments(testCase)

fcn = @()uiw.widget.ColorOrderSelector(...
    'Parent',testCase.TestData.Figure,...
    'Editing',false,...
    'ColorOrder',[0 1 1; 1 0 0; 0 1 0],...
    'ForegroundColor',[0 1 0],...
    'BackgroundColor',[0.5 0.5 0.5],...
    'FontAngle','normal',...
    'FontName','MS Sans Serif',...
    'FontSize',12,...
    'FontWeight','normal',...
    'Callback',@(a,b) disp( a.Value ),...
    'Units','Pixels',...
    'Position',[10 10 200 50],...
    'Tag','Test',...
    'Visible','on');

verifyWarningFree(testCase,fcn)

end %function


%% Test set colormap from enum
function testSetColorOrder(testCase)

w = uiw.widget.ColorOrderSelector('Parent',testCase.TestData.Figure);

verifyWarningFree(testCase, @()set(w,'ColorOrder',testCase.TestData.Figure.Colormap) )

% Need a tolerance here because of roundoff in the view
verifyEqual(testCase, w.ColorOrder, testCase.TestData.Figure.Colormap, 'RelTol', 0.01)

end %function


%% Test editing mode
function testEditMode(testCase)

w = uiw.widget.ColorOrderSelector('Parent',testCase.TestData.Figure);

verifyWarningFree(testCase, @()set(w,'Editing',true) )

verifyWarningFree(testCase, @()set(w,'Editing',false) )

end %function

