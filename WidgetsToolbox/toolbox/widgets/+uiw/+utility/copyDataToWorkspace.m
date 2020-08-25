function copyDataToWorkspace(data,name)
% copyDataToWorkspace - copy the input data to a workspace variable
% -------------------------------------------------------------------------
%
% Syntax:
%   copyDataToWorkspace(data,name)
%
%       
%

%   Copyright 2017-2020 The MathWorks Inc.
%
% 
%   
%   
%   
% ---------------------------------------------------------------------

if nargin<2
    name = inputname(2);
end

% Make a valid variable name
name = matlab.lang.makeValidName(name);
varNames = evalin('base','who');
name = matlab.lang.makeUniqueStrings(name,varNames);

% Export
assignin('base',name,data)

% Display
fprintf('Data was exported to workspace variable ''%s''.\n',name);
