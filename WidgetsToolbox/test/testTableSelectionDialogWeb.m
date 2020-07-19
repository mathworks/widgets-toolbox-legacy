function tests = testTableSelectionDialogWeb()

% Unit Test - Implements a unit test for a widget or component

% Copyright 2018 The MathWorks,Inc.
%
% Auth/Revision:
% MathWorks Consulting
% $Author: rjackey $
% $Revision: 338 $
% $Date: 2019-06-19 08:40:52 -0400 (Wed, 19 Jun 2019) $
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

filename = fullfile(matlabroot,'examples','matlab','myCsvTable.dat');
tableData = readtable(filename);

fcn = @()uiw.dialog.TableSelection(...
    'Title','My Dialog',...
    'DataTable',tableData,...
    'SelectedRows',1,...
    'MultiSelect',true);

testCase.TestData.Dialog = verifyWarningFree(testCase,fcn);

end %function

