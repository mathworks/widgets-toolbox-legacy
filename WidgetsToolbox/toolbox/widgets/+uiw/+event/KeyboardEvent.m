classdef (Hidden) KeyboardEvent < uiw.event.EventData
    % KeyboardEvent - Class for eventdata for keyboard actions
    % 
    % This class provides storage of data for a keyboard event
    %
    % Syntax:
    %           obj = uiw.event.KeyboardEvent
    %           obj = uiw.event.KeyboardEvent('Property','Value',...)
    %
    % This class may change in the future.
    
%   Copyright 2018-2019 The MathWorks Inc.
    %
    % 
    %   
    %   
    %   
    % ---------------------------------------------------------------------
    
    
    %% Properties
    properties
        Character char
        Modifier cell
        Key char
        %Source
        %EventName
%         HitObject matlab.graphics.Graphics
%         MouseSelection matlab.graphics.Graphics
%         Axes matlab.graphics.axis.Axes
%         AxesPoint double
%         Figure matlab.ui.Figure
%         FigurePoint double
%         ScreenPoint double
    end %properties
  
    
    %% Constructor / destructor
    methods 
        
        function obj = KeyboardEvent(varargin)
            % Construct the event
            
            % Call superclass constructors
            obj@uiw.event.EventData(varargin{:});
            
        end %constructor
        
    end %methods
    
end % classdef