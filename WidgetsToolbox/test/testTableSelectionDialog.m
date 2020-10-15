function tests = testTableSelectionDialog()

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

    testCase.TestData.Dialog = gobjects(0);
    
end %function

% Teardown once for each test
function teardown(testCase)

    delete(testCase.TestData.Dialog);
    
end %function


%% Test Basic Construction
function testDefaultConstructor(testCase)

fcn = @()uiw.dialog.TableSelection();

testCase.TestData.Dialog = verifyWarningFree(testCase,fcn);

end %function


%% Test Construction with Inputs
function testConstructionArguments(testCase)

tableData = readtable('myCsvTable.dat');

fcn = @()uiw.dialog.TableSelection(...
    'Title','My Dialog',...
    'DataTable',tableData,...
    'SelectedRows',1,...
    'MultiSelect',true);

testCase.TestData.Dialog = verifyWarningFree(testCase,fcn);

end %function

