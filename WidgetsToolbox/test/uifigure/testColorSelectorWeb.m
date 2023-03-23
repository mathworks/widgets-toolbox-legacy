function tests = testColorSelector()
% Unit Test - Implements a unit test for a widget or component

% Copyright 2018 The MathWorks, Inc.
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

    testCase.TestData.Figure = uifigure();
    
end %function

% Teardown once for each test
function teardown(testCase)

    delete(testCase.TestData.Figure);
    
end %function


%% Test Basic Construction
function testDefaultConstructor(testCase)

fcn = @()uiw.widget.ColorSelector();

verifyWarningFree(testCase,fcn)

end %function


%% Test Construction with Inputs
function testConstructionArguments(testCase)

fcn = @()uiw.widget.ColorSelector(...
    'Parent',testCase.TestData.Figure,...
    'Value',[1 0 0],...
    'ForegroundColor',[0 1 0],...
    'BackgroundColor',[0.5 0.5 0.5],...
    'FontAngle','normal',...
    'FontName','MS Sans Serif',...
    'FontSize',12,...
    'FontWeight','normal',...
    'TextHorizontalAlignment', 'center',...
    'Callback',@(a,b) disp( a.Value ),...
    'Units','Pixels',...
    'Position',[10 10 200 50],...
    'Tag','Test',...
    'TextEditable','on',...
    'Visible','on');

verifyWarningFree(testCase,fcn)

end %function


%% Test various values

function testBadValues1(testCase)

InitValue = [0.3 0.3 0.3];
w = uiw.widget.ColorSelector('Parent',testCase.TestData.Figure,'Value',InitValue);

badValue = 'aslkdjf;lkksdjf';
w.Value = badValue;
assert( isequal(w.Value, InitValue) )

end


function testBadValues2(testCase)

InitValue = [0.3 0.3 0.3];
w = uiw.widget.ColorSelector('Parent',testCase.TestData.Figure,'Value',InitValue);

badValue = [2 2 2]';
w.Value = badValue;
assert( isequal(w.Value, InitValue) )

end


function testGoodValues1(testCase)

InitValue = [0.3 0.3 0.3];
w = uiw.widget.ColorSelector('Parent',testCase.TestData.Figure,'Value',InitValue);

okValue = [1 0 0];
w.Value = 'red';
assert( isequal(w.Value, okValue) )

end


function testGoodValues2(testCase)

InitValue = [0.3 0.3 0.3];
w = uiw.widget.ColorSelector('Parent',testCase.TestData.Figure,'Value',InitValue);

okValue = [.8 .7 .6];
w.Value = okValue;
assert( isequal(w.Value, okValue) )

end


%% Test Invalid Coloring
function testColoring(testCase)

BGColor = [1 1 1];
FGColor = [0 0 0];
InvBGColor = [1 0 0];
InvFGColor = [1 1 1];

w = uiw.widget.ColorSelector(...
    'Parent', testCase.TestData.Figure, ...
    'Value', [1 0 0], ...
    'Units', 'pixels', ...
    'TextBackgroundColor', BGColor, ...
    'TextForegroundColor', FGColor, ...
    'TextInvalidBackgroundColor', InvBGColor, ...
    'TextInvalidForegroundColor', InvFGColor, ...
    'Position', [10 10 400 25]);

% Mark invalid
w.TextIsValid = false;

% Make valid again
w.TextIsValid = true;


end %function
