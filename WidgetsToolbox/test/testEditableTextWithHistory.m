function tests = testEditableTextWithHistory()
% Unit Test - Implements a unit test for a widget or component

% Copyright 2018 The MathWorks,Inc.
%
% Auth/Revision:
% MathWorks Consulting
% $Author: rjackey $
% $Revision: 207 $
% $Date: 2018-07-24 09:09:48 -0400 (Tue, 24 Jul 2018) $
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

fcn = @()uiw.widget.EditableTextWithHistory();

verifyWarningFree(testCase,fcn)

end %function


%% Test Construction with Inputs
function testConstructionArguments(testCase)

fcn = @()uiw.widget.EditableTextWithHistory(...
    'Parent',testCase.TestData.Figure,...
    'FieldType','text',...
    'Validator',@()disp('validate'),...
    'ShowDialogOnError',false,...
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
    'Callback',@(a,b) disp( a.Value ),...
    'Units','Pixels',...
    'Position',[10 10 200 50],...
    'Tag','Test',...
    'Label','Unit Test:',...
    'Visible','on');

verifyWarningFree(testCase,fcn)

end %function


%% Test Settings
function testSettings(testCase)
    
w = uiw.widget.EditableTextWithHistory('Parent', testCase.TestData.Figure);

verifyWarningFree(testCase, @()set(w,'ShowDialogOnError',true) )
verifyWarningFree(testCase, @()set(w,'ShowDialogOnError',false) )

end %function


%% Test Field Types
function testFieldTypes(testCase)
    

% text
w = uiw.widget.EditableTextWithHistory('Parent', testCase.TestData.Figure);
verifyWarningFree(testCase, @()set(w,'FieldType','text') )
verifyWarningFree(testCase, @()set(w,'Value','123') )
verifyEqual(testCase, w.Value, '123')

% number
w = uiw.widget.EditableTextWithHistory('Parent', testCase.TestData.Figure);
verifyWarningFree(testCase, @()set(w,'FieldType','number') )
verifyWarningFree(testCase, @()set(w,'Value',456) )
verifyEqual(testCase, w.Value, 456)

% matrix
w = uiw.widget.EditableTextWithHistory('Parent', testCase.TestData.Figure);
verifyWarningFree(testCase, @()set(w,'FieldType','matrix') )
verifyWarningFree(testCase, @()set(w,'Value',[123 456]) )
verifyEqual(testCase, w.Value, [123 456])

verifyWarningFree(testCase, @drawnow )

end %function


%% Test History
function testHistory(testCase)
    
w = uiw.widget.EditableTextWithHistory('Parent', testCase.TestData.Figure);

verifyWarningFree(testCase, @()set(w,'FieldType','number') )


verifyWarningFree(testCase, @()set(w,'Value','123') )
verifyEqual(testCase, w.Value, 123)

verifyWarningFree(testCase, @()set(w,'Value','456') )
verifyEqual(testCase, w.Value, 456)

verifyWarningFree(testCase, @()set(w,'Value','789') )
verifyEqual(testCase, w.Value, 789)

verifyEqual(testCase, w.History, ["789";"456";"123"])

end %function
