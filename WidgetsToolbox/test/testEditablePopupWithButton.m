function tests = testEditablePopupWithButton()
% Unit Test - Implements a unit test for a widget or component

% Copyright 2018 The MathWorks,Inc.
%
% Auth/Revision:
% MathWorks Consulting
% $Author: rjackey $
% $Revision: 55 $
% $Date: 2018-02-27 13:41:05 -0500 (Tue, 27 Feb 2018) $
% ---------------------------------------------------------------------

% Indicate to test the local functions in this file
tests = functiontests(localfunctions);

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

fcn = @()uiw.widget.EditablePopupWithButton();

verifyWarningFree(testCase,fcn)

end %function


%% Test Construction with Inputs
function testConstructionArguments(testCase)

fcn = @()uiw.widget.EditablePopupWithButton(...
    'Parent',testCase.TestData.Figure,...
    'ButtonVisible',true,...
    'ForegroundColor',[0 1 0],...
    'BackgroundColor',[0.5 0.5 0.5],...
    'FontAngle','normal',...
    'FontName','MS Sans Serif',...
    'FontSize',12,...
    'FontWeight','normal',...
    'TextHorizontalAlignment','center',...
    'Callback',@(a,b) disp( a.Value ),...
    'Units','Pixels',...
    'Position',[10 10 200 50],...
    'Items',{'USA','Canada','Mexico'},...
    'Tag','Test',...
    'TextEditable','on',...
    'Label','Unit Test:',...
    'Visible','on');

verifyWarningFree(testCase,fcn)

end %function
