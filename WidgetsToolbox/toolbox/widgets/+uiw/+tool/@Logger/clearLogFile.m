function clearLogFile(obj)
% clearLogFile - clear the log messages in the log file
% -------------------------------------------------------------------------
% Abstract: Clears the log messages currently stored in the log file.
%
% Syntax:
%           logObj.clearLogFile();
%           clearLogFile(logObj);
%
% Examples:
%           logObj = Logger.getInstance('MyLogger');
%           write(logObj,'warning','My warning message')
%           logObj.clearLogFile();

%   Copyright 2018-2020 The MathWorks Inc.
%
% 
%   
%   
%   
% ---------------------------------------------------------------------


% Close the log file
obj.closeLogFile();

% Open the log file again and overwrite
openLogFile(obj,obj.LogFile,'w');