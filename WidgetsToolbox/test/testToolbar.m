function tests = testToolbar()
% Unit Test - Implements a unit test for a widget or component

% Copyright 2018 The MathWorks,Inc.
%
% Auth/Revision:
% MathWorks Consulting
% $Author: rjackey $
% $Revision: 232 $
% $Date: 2018-08-16 13:47:30 -0400 (Thu, 16 Aug 2018) $
% ---------------------------------------------------------------------

% Indicate to test the local functions in this file
tests = functiontests(localfunctions);

end %function

% Setup once for all tests
function setupOnce(testCase)

[~,testCase.TestData.Icon1] = uiw.utility.loadIcon('add_24.png');
[~,testCase.TestData.Icon2] = uiw.utility.loadIcon('check_24.png');

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

fcn = @()uiw.widget.Toolbar();

verifyWarningFree(testCase,fcn)

end %function


%% Test Construction with Inputs
function testConstructionArguments(testCase)

fcn = @()uiw.widget.Toolbar(...
    'Parent',testCase.TestData.Figure,...
    'Callback',@(h,e) disp(e.Source.Tag),...
    'Units','normalized',...
    'Position',[0 0.6 1 0.4],...
    'Tag','Test',...
    'Label','Unit Test:',...
    'Visible','on');

verifyWarningFree(testCase,fcn)

end %function


%% Test Compatibility with old Toolstrip name
function testCompatibility(testCase)

w = uiw.widget.Toolstrip(...
    'Parent',testCase.TestData.Figure,...
    'Units','normalized',...
    'Position',[0 0.6 1 0.4]);

verifyWarningFree(testCase, @()addSection(w,'Section1') )
verifyWarningFree(testCase, @()addButton(w,testCase.TestData.Icon1,'Tag1') )

end %function


%% Test normal section
function testNormalSection(testCase)

w = uiw.widget.Toolbar(...
    'Parent',testCase.TestData.Figure,...
    'Units','normalized',...
    'Position',[0 0.6 1 0.4]);


verifyWarningFree(testCase, @()addSection(w,'Section1') )

verifyWarningFree(testCase, @()addButton(w,testCase.TestData.Icon1,'Tag1') )
verifyWarningFree(testCase, @()addButton(w,testCase.TestData.Icon2,'Tag2') )

end %function


%% Test mixed sections and buttons
function testMixedSections(testCase)

w = uiw.widget.Toolbar(...
    'Parent',testCase.TestData.Figure,...
    'Units','normalized',...
    'Position',[0 0.6 1 0.4]);

verifyWarningFree(testCase, @()addSection(w,'Section1') )

verifyWarningFree(testCase, @()addButton(w,testCase.TestData.Icon1,'Tag1') )
verifyWarningFree(testCase, @()addButton(w,testCase.TestData.Icon2,'Tag2') )

verifyWarningFree(testCase, @()addSection(w,'Section2') )

verifyWarningFree(testCase, @()addToggleButton(w,testCase.TestData.Icon1,'Tag1b') )
verifyWarningFree(testCase, @()addButton(w,testCase.TestData.Icon2,'Tag2b') )

verifyWarningFree(testCase, @()addToggleSection(w,'Section3') )

verifyWarningFree(testCase, @()addToggleButton(w,testCase.TestData.Icon1,'Tag1c') )
verifyWarningFree(testCase, @()addToggleButton(w,testCase.TestData.Icon2,'Tag2c') )
verifyWarningFree(testCase, @()addButton(w,testCase.TestData.Icon1,'Tag1_d') )
verifyWarningFree(testCase, @()addToggleButton(w,testCase.TestData.Icon2,'Tag2d') )

end %function
