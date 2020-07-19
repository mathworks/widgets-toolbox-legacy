function tests = testProgressBarWeb()

% Unit Test - Implements a unit test for a widget or component

% Copyright 2018 The MathWorks,Inc.
%
% Auth/Revision:
% MathWorks Consulting
% $Author: rjackey $
% $Revision: 172 $
% $Date: 2018-06-19 17:53:20 -0400 (Tue, 19 Jun 2018) $
% ---------------------------------------------------------------------

% Indicate to test the local functions in this file
tests = functiontests(localfunctions);

end %function

% Setup once for each test
function setup(testCase)

testCase.TestData.Figure = uifigure('Units','pixels','Position',[100 100 320 45]);

end %function

% Teardown once for each test
function teardown(testCase)

delete(testCase.TestData.Figure);

end %function


%% Test Basic Construction
function testDefaultConstructor(testCase)

fcn = @()uiw.widget.ProgressBar();

verifyWarningFree(testCase,fcn)

end %function


%% Test Construction with Inputs
function testConstructionArguments(testCase)

fcn = @()uiw.widget.ProgressBar(...
    'Parent',testCase.TestData.Figure,...
    'AllowCancel',true,...
    'FlagCancel',false,...
    'ForegroundColor',[0 1 0],...
    'BackgroundColor',[0.5 0.5 0.5],...
    'FontAngle','normal',...
    'FontName','MS Sans Serif',...
    'FontSize',12,...
    'FontWeight','normal',...
    'Units','normalized',...
    'Position',[0 0 1 1],...
    'Tag','Test',...
    'Label','Unit Test:',...
    'Visible','on');

verifyWarningFree(testCase,fcn)

end %function


%% Test Progress
function testProgress(testCase)

w = uiw.widget.ProgressBar(...
    'Parent', testCase.TestData.Figure, ...
    'AllowCancel',true,...
    'Units','normalized',...
    'Position',[0 0 1 1]);

verifyEqual(testCase, w.Value, 0)

% Start progress
verifyWarningFree(testCase, @()startProgress(w) )
verifyWarningFree(testCase, @()startProgress(w,'Starting...') )
verifyEqual(testCase, w.StatusText, 'Starting...')


% Update progress
verifyWarningFree(testCase, @()setProgress(w, 0.1) )
verifyEqual(testCase, w.StatusText, 'Starting...')
verifyWarningFree(testCase, @()setProgress(w, 0.2, 'Step 1 begins') )
verifyEqual(testCase, w.StatusText, 'Step 1 begins')

verifyWarningFree(testCase, @()setProgress(w, 0.6, '') )
verifyEqual(testCase, w.StatusText, '')

% Finish progress
verifyWarningFree(testCase, @()finishProgress(w) )
verifyEqual(testCase, w.StatusText, '')
verifyWarningFree(testCase, @()finishProgress(w,'DONE!') )
verifyEqual(testCase, w.StatusText, 'DONE!')

end %function


%% Test Cancel
function testCancel(testCase)

w = uiw.widget.ProgressBar(...
    'Parent', testCase.TestData.Figure, ...
    'AllowCancel',true,...
    'Units','normalized',...
    'Position',[0 0 1 1]);

verifyMatches(testCase, char(w.h.CancelButton.Visible), 'off')

verifyWarningFree(testCase, @()set(w,'AllowCancel',true) )

verifyMatches(testCase, char(w.h.CancelButton.Visible), 'off')

verifyWarningFree(testCase, @()startProgress(w,'Starting...') )

verifyMatches(testCase, char(w.h.CancelButton.Visible), 'on')
verifyMatches(testCase, char(w.h.CancelButton.Enable), 'on')

verifyWarningFree(testCase, @()set(w,'FlagCancel',true) )

verifyMatches(testCase, char(w.h.CancelButton.Visible), 'on')
verifyMatches(testCase, char(w.h.CancelButton.Enable), 'off')

verifyWarningFree(testCase, @()finishProgress(w,'DONE!') )

verifyMatches(testCase, char(w.h.CancelButton.Visible), 'off')

end %function


%% Test Bad Values
function testBadValues(testCase)

w = uiw.widget.ProgressBar(...
    'Parent', testCase.TestData.Figure, ...
    'Units','normalized',...
    'Position',[0 0 1 1]);

%RAJ - the errors changed - may be different in earlier release?
verifyError(testCase, @()setProgress(w, 2), 'MATLAB:validators:mustBeLessThanOrEqual');
verifyError(testCase, @()setProgress(w, 0.5,{[1 2]}), 'MATLAB:validation:UnableToConvert');

end %function


%% Test StatusText
function testStatusText(testCase)

w = uiw.widget.ProgressBar(...
    'Parent', testCase.TestData.Figure, ...
    'Units','normalized',...
    'Position',[0 0 1 1]);

% Set status message
message = 'Status message';
w.setStatusText(message)
verifyEqual(testCase, w.StatusText, message)

end %function
