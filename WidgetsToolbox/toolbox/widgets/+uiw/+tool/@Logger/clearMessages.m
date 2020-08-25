function clearMessages(obj)
% clearMessages - clear the log messages in memory
% -------------------------------------------------------------------------
% Abstract: Clears the log messages currently stored in memory within the
% Logger object's buffer. Does not clear the log file.
%
% Syntax:
%           logObj.clearMessages();
%           clearMessages(logObj);
%
% Examples:
%           logObj = Logger.getInstance('MyLogger');
%           write(logObj,'warning','My warning message')
%           logObj.clearMessages();

%   Copyright 2018-2020 The MathWorks Inc.
%
% 
%   
%   
%   
% ---------------------------------------------------------------------

obj.MessageBuffer(obj.BufferSize,1) = uiw.tool.LogMessage();
obj.BufferIndex = 0;
obj.BufferIsWrapped = false;