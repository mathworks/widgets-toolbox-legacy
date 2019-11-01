function varargout = throwError(varargin)
% throwError - Throw an error to a dialog
% ---------------------------------------------------------------------
% Throw an error to a dialog
%
% Syntax:
%
%   uiw.utility.throwError(message) creates an error dialog with the
%   specified message and blocks execution until the window is closed
%
%   uiw.utility.throwError(title,message) also includes the specified title
%
%   uiw.utility.throwError(title,message,A1,A2,...An) includes additional
%   sprintf arguments applied to message
%
%   uiw.utility.throwError(MException) throws an error using the specified
%   MException and the stack
%
%   uiw.utility.throwError(title,MException) also includes the specified
%   title
%
%   uiw.utility.throwError(title,MException,message) also includes the
%   specified message
%
%   uiw.utility.throwError(title,MException,message,A1,A2,...An) also
%   includes additional sprintf arguments applied to message
%
%   uiw.utility.throwError(parentFig,...)
%   positions the dialog over the center of the specified parent figure
%
%   dlg = uiw.utility.throwError(...)
%   returns the dialog handle and does not block execution
%
%
% Inputs:
%
%   title - text to display in title bar
%
%   message - message text (may contain sprintf tokens)
%
%   A1,A2,...An - sprintf arguments
%
%   MException - a MException from a caught error
%
%   parentFig - parent figure to position over
%
% Outputs:
%   dlg - the resulting dialog
%
% Examples:
%           none
%
% Notes: none
%

%   Copyright 2019 The MathWorks Inc.
%
% Auth/Revision:
%   MathWorks Consulting
%   $Author: rjackey $
%   $Revision: 324 $  $Date: 2019-04-23 08:05:17 -0400 (Tue, 23 Apr 2019) $
% ---------------------------------------------------------------------

% Check inputs
narginchk(1,inf)

% Defaults
parentFig = [];
title = 'Error';
message = string.empty(0);
stackInfo = string.empty(0);


%% Is the first argument a figure?
p = varargin{1};
if isgraphics(p)
    parentFig = p;
    varargin(1) = [];
elseif isa(p,'uiw.abstract.BaseFigure')
    parentFig = p.Figure;
    varargin(1) = [];
end


%% Is there a title?
if numel(varargin) >= 2
    title = varargin{1};
    varargin(1) = [];
end


%% Is there a MException?
p = varargin{1};
if isa(p,'MException')
    stackInputs = [{p.stack.name};{p.stack.line}];
    stackInfo = sprintf("\n\t\t> %s (line %d)",stackInputs{:});
    stackInfo = string(p.message) + newline + stackInfo;
    varargin(1) = [];
end


%% Parse the message
if ~isempty(varargin)
    message = sprintf(varargin{:});
end

% Combine the messages
message = strjoin([message stackInfo],newline);

% Add HTML tag if needed
% if strlength(stackInfo)
%     message = "<html>" + message;
% end


%% Create the  dialog

%R2017b compatibility:
message = char(message);
title = char(title);

hDlg = errordlg(message,title,'modal');

% Move over parent figure
if ~isempty(parentFig)
    uiw.utility.positionOver(hDlg, parentFig);
end

% Gather output if specified, otherwise block execution
if nargout
    varargout{1} = hDlg;
else
    uiwait(hDlg);
end


