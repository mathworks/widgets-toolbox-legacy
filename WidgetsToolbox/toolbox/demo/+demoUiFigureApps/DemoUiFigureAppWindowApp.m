classdef DemoUiFigureAppWindowApp < uiw.abstract.AppWindow
    % App - Class definition for a MATLAB desktop application
    % ---------------------------------------------------------------------
    % Instantiates the Application figure window
    %
    % Syntax:
    %           app = demoUiFigureApps.DemoUiFigureAppWindowApp
    %
    
    %   Copyright 2020 The MathWorks Inc.
    % ---------------------------------------------------------------------
    
    %% Application Settings
    properties (Constant, Access=protected)
        
        % Abstract in superclass
        AppName char = 'My App'
        
    end %properties
    
    
    
    %% Constructor and Destructor
    methods
        
        % Constructor
        function obj = DemoUiFigureAppWindowApp(varargin)
            % Construct the app
            
            % Call superclass constructor
            obj@uiw.abstract.AppWindow('FigureType','uifigure');
            
            % Create the base graphics
            obj.create();
            
            % Populate public properties from P-V input pairs
            obj.assignPVPairs(varargin{:});
            
            % Mark construction complete to tell redraw the graphics exist
            obj.IsConstructed = true;
            
            % Redraw the entire view
            obj.redraw();
            
            % Now, make the figure visible
            obj.Visible = 'on';
            
        end %function
        
    end %methods
    
    
    
    %% Protected Methods
    methods (Access=protected)
        
        function create(obj)
            
            obj.h.Button = uicontrol(...
                'Parent',obj.Figure,...
                'String','Redraw',...
                'Callback',@(h,e)redraw(obj));
            
        end %function
        
        
        function redraw(obj)
            if obj.IsConstructed
                
                disp('Redraw called');
                
                
            end
        end %function
        
    end %methods
    
    
end %classdef

