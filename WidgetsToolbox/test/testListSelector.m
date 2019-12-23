function tests = testListSelector()
% Unit Test - Implements a unit test for a widget or component

% Copyright 2018 The MathWorks, Inc.
%
% Auth/Revision:
% MathWorks Consulting
% $Author: rjackey $
% $Revision: 310 $
% $Date: 2019-01-31 14:18:53 -0500 (Thu, 31 Jan 2019) $
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

    testCase.TestData.Figure = figure();
    
end %function

% Teardown once for each test
function teardown(testCase)

    delete(testCase.TestData.Figure);
    
end %function


%% Test Basic Construction
function testDefaultConstructor(testCase)

fcn = @()uiw.widget.ListSelector();

verifyWarningFree(testCase,fcn)

end %function


%% Test Construction with Inputs
function testConstructionArguments(testCase)

fcn = @()uiw.widget.ListSelector(...
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
    'Tag','Test',...
    'AllItems',testCase.TestData.Items,...
    'AllowCopy', true, ... %Requires callback implementation
    'AllowEdit', true, ... %Requires callback implementation
    'AllowMove', true, ... %Callback is optional
    'AllowPlot', true, ... %Requires callback implementation
    'AllowReverse', true, ... %Requires callback implementation
    'AllowRun', true, ... %Requires callback implementation
    'AllowSearch',true, ...
    'Visible','on');

verifyWarningFree(testCase,fcn)

end %function


%% Test setting invalid value does not change result
function testBadValues1(testCase)

w = uiw.widget.ListSelector(...
    'Parent',testCase.TestData.Figure,...
    'AllItems',testCase.TestData.Items,...
    'AddedIndexR',[1 3 4]);

testCase.verifyWarningFree( @()set(w,'SelectedIndexL',10) )
testCase.verifyEqual(w.SelectedIndexL, [])

testCase.verifyWarningFree( @()set(w,'SelectedIndexR',4) )
testCase.verifyEqual( w.SelectedIndexR, [])

end %function


%% Test duplicates
function testDuplicates(testCase)
w = uiw.widget.ListSelector(...
    'Parent',testCase.TestData.Figure,...
    'AllItems',testCase.TestData.Items,...
    'AllowMove', true, ... %Callback is optional
    'AddedIndexR',[1 3 4]);

testCase.verifyEqual( w.ItemsL, testCase.TestData.Items([2 5 6]) )
testCase.verifyEqual( w.ItemsR, testCase.TestData.Items([1 3 4]) )

w.AllowDuplicatesR = true;

testCase.verifyEqual( w.ItemsL, testCase.TestData.Items(:) )
testCase.verifyEqual( w.ItemsR, testCase.TestData.Items([1 3 4]) )

testCase.verifyWarningFree( @()set(w,'AddedIndexR',[2 2 4]) )
testCase.verifyEqual( w.ItemsL, testCase.TestData.Items(:) )
testCase.verifyEqual( w.ItemsR, testCase.TestData.Items([2 2 4]) )

end %function

