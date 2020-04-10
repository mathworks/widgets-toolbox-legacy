function tests = testList()
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
    'Alpha'
    'Bravo'
    'Charlie'
    'Delta'
    'Echo'
    'Foxtrot'
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

fcn = @()uiw.widget.List();

verifyWarningFree(testCase,fcn)

end %function


%% Test Construction with Inputs
function testConstructionArguments(testCase)

fcn = @()uiw.widget.List(...
    'Parent',testCase.TestData.Figure,...
    'Label','List:',...
    'Items',testCase.TestData.Items,...
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



%% Test default settings have not changed
function testDefaultSettings(testCase)

w = uiw.widget.List(...
    'Parent',testCase.TestData.Figure);

% Change settings and verify
testCase.verifyEmpty( w.Callback );
testCase.verifySize( w.Items,[0 1] );
testCase.verifyEmpty( w.SelectedIndex );

end %function


%% Test single selection
function testSingleSelection(testCase)

w = uiw.widget.List(...
    'Parent',testCase.TestData.Figure,...
    'Items',testCase.TestData.Items);

% Change selection and verify
SelIdx = 2;
w.SelectedIndex = SelIdx;
testCase.verifyEqual( w.SelectedIndex,SelIdx )

end


%% Test multiple selection
function testMultiSelection(testCase)

w = uiw.widget.List(...
    'Parent',testCase.TestData.Figure,...
    'Items',testCase.TestData.Items);

% Change selection and verify
SelIdx = 2;
w.SelectedIndex = SelIdx;
testCase.verifyEqual( w.SelectedIndex,SelIdx )

% Change selection and verify
SelIdxMulti = [3 5];
hFcn = @()set(w,'SelectedIndex',SelIdxMulti);
testCase.verifyError( hFcn,'uiw:widget:List:MultiSelectOff' )
testCase.verifyEqual( w.SelectedIndex,SelIdx )

% Now, allow multi select
w.AllowMultiSelect = true;
hFcn = @()set(w,'SelectedIndex',SelIdxMulti);
testCase.verifyWarningFree(hFcn)

end
