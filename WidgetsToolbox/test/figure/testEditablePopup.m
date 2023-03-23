function tests = testEditablePopup()
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

testCase.TestData.Items = {
    'USA'
    'Canada'
    'Mexico'
    };
    
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

fcn = @()uiw.widget.EditablePopup();

verifyWarningFree(testCase,fcn)

end %function


%% Test Construction with Inputs
function testConstructionArguments(testCase)

fcn = @()uiw.widget.EditablePopup(...
    'Parent',testCase.TestData.Figure,...
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
    'Items',testCase.TestData.Items,...
    'Tag','Test',...
    'TextEditable','on',...
    'Label','Unit Test:',...
    'Visible','on');

verifyWarningFree(testCase,fcn)

end %function



%% Test Invalid Coloring
function testColoring(testCase)

BGColor = [1 1 1];
FGColor = [0 0 0];
InvBGColor = [0.2 0 0];
InvFGColor = [1 0 0];

w = uiw.widget.EditablePopup(...
    'Parent',testCase.TestData.Figure,...
    'Value','invalid_value',...
    'Units','pixels',...
    'TextBackgroundColor',BGColor,...
    'TextForegroundColor',FGColor,...
    'TextInvalidBackgroundColor',InvBGColor,...
    'TextInvalidForegroundColor',InvFGColor,...
    'Position',[10 10 400 25]);

% Mark invalid
w.TextIsValid = false;

% Make valid again
w.TextIsValid = true;

end %function


%% Test value and index setting
function testIndexSetting(testCase)

% This verifies that different input ordering still works as expected

w = uiw.widget.EditablePopup(...
    'Parent',testCase.TestData.Figure,...
    'Items',testCase.TestData.Items,...
    'SelectedIndex',2);
testCase.verifyEqual( w.Value, testCase.TestData.Items{2} )

w = uiw.widget.EditablePopup(...
    'Parent',testCase.TestData.Figure,...
    'SelectedIndex',2,...
    'Items',testCase.TestData.Items);
testCase.verifyEqual( w.Value, testCase.TestData.Items{2} )

w = uiw.widget.EditablePopup(...
    'Parent',testCase.TestData.Figure,...
    'Value', testCase.TestData.Items{2},...
    'Items',testCase.TestData.Items);
testCase.verifyEqual( w.Value, testCase.TestData.Items{2} )
testCase.verifyEqual( w.SelectedIndex,2 )

w = uiw.widget.EditablePopup(...
    'Parent',testCase.TestData.Figure,...
    'Items',testCase.TestData.Items,...
    'Value', testCase.TestData.Items{2});
testCase.verifyEqual( w.Value, testCase.TestData.Items{2} )
testCase.verifyEqual( w.SelectedIndex,2 )

end %function


%% Test bad value and index setting
function testBadIndexSetting(testCase)

w = uiw.widget.EditablePopup(...
    'Parent',testCase.TestData.Figure);

verifyError(testCase,@()set(w,'SelectedIndex',2),'MATLAB:notLessEqual');
verifyError(testCase,@()set(w,'SelectedIndex',-1),'MATLAB:expectedNonnegative');

w.Value = 123;
testCase.verifyEqual( w.Value,'' )

end %function