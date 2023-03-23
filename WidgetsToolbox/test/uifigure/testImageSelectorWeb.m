function tests = testImageSelectorWeb()
% Unit Test - Implements a unit test for a widget or component

% Copyright 2018-2020 The MathWorks,Inc.
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

% Locate a bunch of image files
searchRoot = 'C:\Program Files\MATLAB\R2019a\toolbox\images\imdata';
if ~exist(searchRoot,'dir')
    searchRoot = fullfile(matlabroot,'toolbox','images','imdata');
end
fileInfo = [
    dir(fullfile(searchRoot,'*.jpg'))
    dir(fullfile(searchRoot,'*.tif'))
    ];
imageFiles = sortrows( {fileInfo.name} );
imagePaths = fullfile(searchRoot,imageFiles);

testCase.TestData.ImageFiles = imageFiles;
testCase.TestData.ImagePaths = imagePaths;
testCase.TestData.SearchRoot = searchRoot;

end %function

% Setup once for each test
function setup(testCase)

testCase.TestData.Figure = uifigure();

end %function

% Teardown once for each test
function teardown(testCase)

delete(testCase.TestData.Figure);
delete([tempdir '*.png'])

end %function


%% Test Basic Construction
function testDefaultConstructor(testCase)

fcn = @()uiw.widget.ImageSelector();

verifyWarningFree(testCase,fcn)

end %function


%% Test Construction with Inputs
function testConstructionArguments(testCase)

fcn = @()uiw.widget.ImageSelector(...
    'Parent',testCase.TestData.Figure,...
    'ImageFiles', testCase.TestData.ImagePaths, ...
    'Captions', testCase.TestData.ImageFiles, ...
    'Value',5,...
    'ForegroundColor',[0 1 0],...
    'BackgroundColor',[0.5 0.5 0.5],...
    'FontAngle','normal',...
    'FontName','MS Sans Serif',...
    'FontSize',12,...
    'FontUnits','points',...
    'FontWeight','normal',...
    'Callback', @(h,e)disp(e),...
    'Units','normalized',...
    'Position',[0 0 1 1],...
    'Tag','Test',...
    'Label','Test image selection',...
    'Visible','on');

verifyWarningFree(testCase,fcn)

end %function


%% Test bad values
function testBadValues(testCase)

w = uiw.widget.ImageSelector();
f = @() set( w,'Value',10 );
verifyNotEqual(testCase,f,w.Value,10);

end %function


