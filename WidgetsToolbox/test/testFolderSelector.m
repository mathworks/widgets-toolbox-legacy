function tests = testFolderSelector()
% Unit Test - Implements a unit test for a widget or component

% Copyright 2018 The MathWorks,Inc.
%
% Auth/Revision:
% MathWorks Consulting
% $Author: rjackey $
% $Revision: 55 $
% $Date: 2018-02-27 13:41:05 -0500 (Tue, 27 Feb 2018) $
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

assert( isa( uiw.widget.FolderSelector(),'uiw.widget.FolderSelector' ) );

end %function


%% Test Construction with Inputs
function testConstructionArguments(testCase)

fcn = @()uiw.widget.FolderSelector(...
    'Parent',testCase.TestData.Figure,...
    'Value','C:\Temp\',...
    'ForegroundColor',[0 1 0],...
    'BackgroundColor',[0.5 0.5 0.5],...
    'FontAngle','normal',...
    'FontName','MS Sans Serif',...
    'FontSize',12,...
    'FontUnits','points',...
    'FontWeight','normal',...
    'TextHorizontalAlignment','center',...
    'Callback',@(a,b) disp( a.Value ),...
    'Units','Pixels',...
    'Position',[10 10 200 50],...
    'Tag','Test',...
    'Label','Test folder selection',...
    'RootDirectory','c:\a',...
    'RequireSubdirOfRoot',true,...
    'Visible','on');

verifyWarningFree(testCase,fcn)

end %function


%% Test bad values
function testBadValues(testCase)

s = uiw.widget.FolderSelector();

setFcn = @() set( s, 'Value', 0.5 );
verifyError(testCase, setFcn, 'uiw:widget:FolderSelector:BadValue');

end %function


%% Test root directory usage
function testRootDirectory(testCase)

% Make a temporary folder and file
tmpFolder = fullfile(tempdir, 'mltest', 'myfolder');
[~,~,~] = mkdir( tmpFolder );

w = uiw.widget.FolderSelector(...
    'Parent', testCase.TestData.Figure, ...
    'RootDirectory', tempdir, ...
    'Value', fullfile('mltest', 'myfolder'), ...
    'Units', 'pixels', ...
    'Position', [10 10 400 25]);

assert( isequal(w.Value, fullfile('mltest', 'myfolder')) )
assert( isequal(w.FullPath, tmpFolder) )

end %function


%% Test Invalid Coloring
function testColoring(testCase)

% Make a temporary folder and file
tmpFolder = fullfile(tempdir, 'mltest', 'myfolder');
[~,~,~] = mkdir( tmpFolder );

w = uiw.widget.FolderSelector(...
    'Parent', testCase.TestData.Figure, ...
    'Value', tmpFolder, ...
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

% Set an invalid value
verifyWarningFree(testCase, @()set(w,'Value','invalid_folder_name') )

% Verify color of the internal edit box
verifyEqual(testCase, hEdit.BackgroundColor, testCase.TestData.InvBGColor)
verifyEqual(testCase, hEdit.ForegroundColor, testCase.TestData.InvFGColor)

% Set an valid value
verifyWarningFree(testCase, @()set(w,'Value',tmpFolder) )

% Verify color of the internal edit box
verifyEqual(testCase, hEdit.BackgroundColor, testCase.TestData.BGColor)
verifyEqual(testCase, hEdit.ForegroundColor, testCase.TestData.FGColor)

end %function
