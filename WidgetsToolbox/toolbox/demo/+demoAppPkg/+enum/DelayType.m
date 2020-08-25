classdef DelayType
    % DelayType - enumeration of different delay types
    % ---------------------------------------------------------------------
    %
    
%   Copyright 2018-2019 The MathWorks Inc.
    %
    % 
    %   
    %   
    %   
    % ---------------------------------------------------------------------
    
    %% Enumerations
    
    enumeration
        Departure('Departure')
        Arrival('Arrival')
    end %enumeration
    
    
    %% Properties
    
    properties (Transient, SetAccess='immutable')
        String char
    end %properties
    
    
    %% Constructor
    methods
        function obj = DelayType(str)
            
            obj.String = str;
            
        end %function
    end %methods
    
end % classdef