function tests = testPopupWeb()
% Unit Test - Implements a unit test for a widget or component

% Copyright 2018 The MathWorks,Inc.
%
% Auth/Revision:
% MathWorks Consulting
% $Author: rjackey $
% $Revision: 67 $
% $Date: 2018-03-08 11:13:04 -0500 (Thu, 08 Mar 2018) $
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

    testCase.TestData.Figure = uifigure();
    
end %function

% Teardown once for each test
function teardown(testCase)

    delete(testCase.TestData.Figure);
    
end %function


%% Test Basic Construction
function testDefaultConstructor(testCase)

fcn = @()uiw.widget.Popup();

verifyWarningFree(testCase,fcn)

end %function


%% Test Construction with Inputs
function testConstructionArguments(testCase)

fcn = @()uiw.widget.Popup(...
    'Parent',testCase.TestData.Figure,...
    'ForegroundColor',[0 1 0],...
    'BackgroundColor',[0.5 0.5 0.5],...
    'FontAngle','normal',...
    'FontName','MS Sans Serif',...
    'FontSize',12,...
    'FontWeight','normal',...
    'Callback',@(a,b) disp( a.Value ),...
    'Units','Pixels',...
    'Position',[10 10 200 50],...
    'Items',testCase.TestData.Items,...
    'Tag','Test',...
    'Label','Unit Test:',...
    'Visible','on');

verifyWarningFree(testCase,fcn)

end %function


%% Test value and index setting
function testIndexSetting(testCase)

w = uiw.widget.Popup(...
    'Parent',testCase.TestData.Figure,...
    'Items',testCase.TestData.Items);

verifyWarningFree(testCase, @()set(w,'SelectedIndex',2) );
verifyWarningFree(testCase, @()drawnow);
verifyEqual(testCase, w.SelectedIndex, 2)
verifyEqual(testCase, w.Value, testCase.TestData.Items{2} )

end %function


%% Test value setting
function testValueSetting(testCase)

w = uiw.widget.Popup(...
    'Parent',testCase.TestData.Figure,...
    'Items',testCase.TestData.Items);

verifyWarningFree(testCase, @()set(w,'Value',testCase.TestData.Items{3}) );
verifyWarningFree(testCase, @()drawnow);
verifyEqual(testCase, w.SelectedIndex, 3)
verifyEqual(testCase, w.Value, testCase.TestData.Items{3} )

end %function


%% Test string setting
function testStringSetting(testCase)

w = uiw.widget.Popup(...
    'Parent',testCase.TestData.Figure,...
    'Items',{});

% Set the list of choices in Items. Item 1 should be selected.
verifyWarningFree(testCase, @()set(w,'Items',testCase.TestData.Items) );
verifyWarningFree(testCase, @()drawnow);
verifyEqual(testCase, w.SelectedIndex, 1)
verifyEqual(testCase, w.Value, testCase.TestData.Items{1} )

% Select item 3.
verifyWarningFree(testCase, @()set(w,'Value',testCase.TestData.Items{3}) );
verifyWarningFree(testCase, @()drawnow);
verifyEqual(testCase, w.SelectedIndex, 3)

% Reduce Items to 2 choices
verifyWarningFree(testCase, @()set(w,'Items',testCase.TestData.Items(1:2)) );
verifyWarningFree(testCase, @()drawnow);

% Selection should return to 1, because 3 is no longer valid
verifyEqual(testCase, w.SelectedIndex, 1)
verifyEqual(testCase, w.Value, testCase.TestData.Items{1} )

end %function


%% Test input ordering
function testInputOrdering(testCase)
% This verifies that different input ordering still works as expected

% Correct - set Items then SelectedIndex
w = uiw.widget.Popup(...
    'Parent',testCase.TestData.Figure,...
    'Items',testCase.TestData.Items,...
    'SelectedIndex',2);
verifyEqual(testCase, w.Value, testCase.TestData.Items{2} )
verifyEqual(testCase, w.SelectedIndex, 2 )

% Correct - set Items then Value
w = uiw.widget.Popup(...
    'Parent',testCase.TestData.Figure,...
    'Items',testCase.TestData.Items,...
    'Value', testCase.TestData.Items{2});
verifyEqual(testCase, w.Value, testCase.TestData.Items{2} )
verifyEqual(testCase, w.SelectedIndex, 2 )

% Wrong - set SelectedIndex outside range before setting Items
fcn = @()uiw.widget.Popup(...
    'Parent',testCase.TestData.Figure,...
    'SelectedIndex',2);
verifyError(testCase, fcn, 'MATLAB:notLessEqual' )

% Wrong - set invalid Value before setting Items
fcn = @()uiw.widget.Popup(...
    'Parent',testCase.TestData.Figure,...
    'Value', testCase.TestData.Items{2});
verifyWarning(testCase, fcn, 'uiw:widget:Popup:BadValue' )

end %function


%% Test bad value and index setting
function testBadIndexSetting(testCase)

w = uiw.widget.Popup('Parent',testCase.TestData.Figure,'Items',{});

% Try bad indices
verifyError(testCase,@()set(w,'SelectedIndex',2),'MATLAB:notLessEqual');
verifyError(testCase,@()set(w,'SelectedIndex',-1),'MATLAB:expectedPositive');

end %function