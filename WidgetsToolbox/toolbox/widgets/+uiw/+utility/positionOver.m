function varargout = positionOver(hFigOver,hFigUnder)
% positionOver - Reposition figure centered over another figure
% -------------------------------------------------------------------------

%   Copyright 2017-2020 The MathWorks Inc.
%
% 
%   
%   
%   
% ---------------------------------------------------------------------

% Get positions
figOverPosition = getpixelposition(hFigOver,true);
figUnderPos = getpixelposition(hFigUnder,true);

% Position the new figure at the center of the app
szFigUnder = figUnderPos([3 4]);
szFigOver = figOverPosition([3 4]);
offset = floor( (szFigUnder-szFigOver)/2 );
figOverPosition([1 2]) = figUnderPos([1 2]) + offset;

% Output args?
if nargout
    varargout{1} = figOverPosition;
else
    setpixelposition(hFigOver,figOverPosition);
end

