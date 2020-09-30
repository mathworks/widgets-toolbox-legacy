classdef LogLevel < uint8
    % LogLevel - Enumeration of log levels
    %
    % Abstract: This contains the enumerations of different log message
    % levels for Logger
    %
    % Syntax:
    %           obj = uiw.enum.LogLevel.<MEMBER>
    %
    
%   Copyright 2018-2020 The MathWorks Inc.
    %
    % 
    %   
    %   
    %   
    % ---------------------------------------------------------------------
    
    %% Enumerations
    enumeration
        DEBUG (7)
        CALLBACK (6)
        EVENT (5)
        MESSAGE (4)
        USER (3)
        WARNING (2)
        ERROR (1)
        NONE (0)
    end %enumeration
    
    %% Methods
    methods
        
        function icon = getIconName(logLevel)
            
            switch logLevel
                
                case uiw.enum.LogLevel.NONE
                    icon = 'none';
                    
                case uiw.enum.LogLevel.ERROR
                    icon = 'error';
                    
                case uiw.enum.LogLevel.WARNING
                    icon = 'warning';
                    
                otherwise
                    icon = 'help';
                    
            end %switch
            
        end %function
        
    end %methods
    
end % classdef