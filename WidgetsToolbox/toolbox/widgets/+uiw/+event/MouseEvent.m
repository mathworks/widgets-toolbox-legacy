classdef MouseEvent < uiw.event.EventData
    % MouseEvent - Class for eventdata for mouse actions
    % 
    % This class provides storage of data for a mouse event
    %
    % Syntax:
    %           obj = uiw.event.MouseEvent
    %           obj = uiw.event.MouseEvent('Property','Value',...)
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
        HitObject matlab.graphics.Graphics
        MouseSelection matlab.graphics.Graphics
        SelectionType char
        Axes matlab.graphics.axis.AbstractAxes
        AxesPoint double
        Figure matlab.ui.Figure
        FigurePoint double
        ScreenPoint double
        Position double
        Button double
        NumClicks double
        MetaOn logical
        ControlOn logical
        ShiftOn logical
        AltOn logical
    end %properties
  
    
    %% Constructor / destructor
    methods
        
        function obj = MouseEvent(varargin)
            % Construct the event
            
            % Call superclass constructors
            obj@uiw.event.EventData(varargin{:});
            
        end %constructor
        
    end %methods
    
end % classdef