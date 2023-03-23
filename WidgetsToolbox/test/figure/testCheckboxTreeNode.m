function tests = testCheckboxTreeNode()
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

fcn = @()uiw.widget.CheckboxTreeNode();

verifyWarningFree(testCase,fcn)

end %function


%% Test Construction with Inputs
function testConstructionArguments(testCase)

fcn = @()uiw.widget.CheckboxTreeNode(...
    'Name','Node 1',...
    'Value',1,...
    'TooltipString','Node 1 Tooltip',...
    'UserData',struct());

verifyWarningFree(testCase,fcn)

end %function


%% Test Parent/Child relationships
function testParentChild(testCase)


node_1 = uiw.widget.CheckboxTreeNode('Name','Node_1');
node_1_1 = uiw.widget.CheckboxTreeNode('Name','Node_1_1');

verifyWarningFree(testCase, @()set(node_1_1,'Parent',node_1) )
verifyEqual(testCase, node_1.Children, node_1_1 )

end %function


