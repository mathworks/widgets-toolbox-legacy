classdef LogMessage < event.EventData
    % LogMessage - class to provide eventdata to listeners
    % ---------------------------------------------------------------------
    % Abstract: A message used by Logger
    %
    % Syntax:
    %           obj = uiw.tool.LogMessage
    %           obj = uiw.tool.LogMessage('Property','Value',...)
    %
    
%   Copyright 2017-2020 The MathWorks Inc.
    %
    % 
    %   
    %   
    %   
    % ---------------------------------------------------------------------
    
    
    %% Properties
    properties
        Message char %The text of the message
        Timestamp (1,1) datetime %Time the message occurred
        Level (1,1) uiw.enum.LogLevel = 'NONE' %Level of the message
    end %properties
    
    
    %% Public Methods
    methods (Sealed)
        
        function toDialog(obj,title,opts)
            
            % Prep title and options
            if nargin<3
                opts = struct('WindowStyle','modal','Interpreter','none');
                if nargin<2
                    title = char(obj.Level);
                    title(2:end) = lower(title(2:end));
                end
            end
           
            % Remove html
            messageStr = regexprep(obj.Message,'<.+?>','');
            
            % Which type of message icon? (error, warning, etc.)
            icon = obj.Level.getIconName();

            % Throw the dialog
            hDlg = msgbox(messageStr, title, icon, opts);
            
        end %function
        
        
        function tf = isWithinLevel(obj,level)
            % Compare the level to the requested one
            
            validateattributes(level,{'uiw.enum.LogLevel'},{'scalar'})
            tf = obj.Level >= level;
            
        end %function
        
    end %methods
    
end % classdef