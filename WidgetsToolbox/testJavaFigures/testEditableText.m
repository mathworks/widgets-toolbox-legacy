function tests = testEditableText()
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

fcn = @()uiw.widget.EditableText();

verifyWarningFree(testCase,fcn)

end %function


%% Test Construction with Inputs
function testConstructionArguments(testCase)

fcn = @()uiw.widget.EditableText(...
    'Parent',testCase.TestData.Figure,...
    'FieldType','text',...
    'Validator',@()disp('validate'),...
    'ShowDialogOnError',false,...
    'IsMultiLine',false,...
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
    
w = uiw.widget.EditableText('Parent', testCase.TestData.Figure);

verifyWarningFree(testCase, @()set(w,'ShowDialogOnError',true) )
verifyWarningFree(testCase, @()set(w,'ShowDialogOnError',false) )

verifyWarningFree(testCase, @()set(w,'IsMultiLine',true) )
verifyWarningFree(testCase, @()set(w,'IsMultiLine',false) )

end %function


%% Test Field Types
function testFieldTypes(testCase)
    

% text
w = uiw.widget.EditableText('Parent', testCase.TestData.Figure);
verifyWarningFree(testCase, @()set(w,'FieldType','text') )
verifyWarningFree(testCase, @()set(w,'Value','123') )
verifyEqual(testCase, w.Value, '123')

% number
w = uiw.widget.EditableText('Parent', testCase.TestData.Figure);
verifyWarningFree(testCase, @()set(w,'FieldType','number') )
verifyWarningFree(testCase, @()set(w,'Value',456) )
verifyEqual(testCase, w.Value, 456)

% matrix
w = uiw.widget.EditableText('Parent', testCase.TestData.Figure);
verifyWarningFree(testCase, @()set(w,'FieldType','matrix') )
verifyWarningFree(testCase, @()set(w,'Value',[123 456]) )
verifyEqual(testCase, w.Value, [123 456])

verifyWarningFree(testCase, @drawnow )

end %function



%% Test Bad Value/FieldType Combinations
function testBadValueFieldTypes(testCase)
    

% FieldType 'text', Value as number
w = uiw.widget.EditableText('Parent', testCase.TestData.Figure);
verifyWarningFree(testCase, @()set(w,'FieldType','text') )
verifyWarningFree(testCase, @()set(w,'Value','abc') )
verifyWarningFree(testCase, @()set(w,'Value',[3 10]) )
verifyEqual(testCase, w.Value, 'abc')

% FieldType 'number', Value as text
w = uiw.widget.EditableText('Parent', testCase.TestData.Figure);
verifyWarningFree(testCase, @()set(w,'FieldType','number') )
verifyWarningFree(testCase, @()set(w,'Value',10) )
verifyWarningFree(testCase, @()set(w,'Value','abc') )
verifyEqual(testCase, w.Value, 10)


% FieldType 'matrix', Value as text
w = uiw.widget.EditableText('Parent', testCase.TestData.Figure);
verifyWarningFree(testCase, @()set(w,'FieldType','matrix') )
verifyWarningFree(testCase, @()set(w,'Value',[3 10]) )
verifyWarningFree(testCase, @()set(w,'Value','abc') ) %RAJ - this will convert to []
verifyEqual(testCase, w.Value, [])

verifyWarningFree(testCase, @drawnow )

end %function


%% Test Invalid Coloring
function testColoring(testCase)

w = uiw.widget.EditableText(...
    'Parent', testCase.TestData.Figure, ...
    'Value', 'abcdef', ...
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