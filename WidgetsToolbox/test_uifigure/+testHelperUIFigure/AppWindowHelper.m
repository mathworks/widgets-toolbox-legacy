classdef AppWindowHelper < uiw.abstract.AppWindow
    % AppWindowHelper - Unit Test helper for uiw.abstract.AppWindow
    %
    % Notes:
    %
    %
    
    % Copyright 2018 The MathWorks, Inc.
    %
    % 
    %   
    % ---------------------------------------------------------------------
    
    
    %% Passthru methods
    methods
       
        function out = getPreferenceTest(varargin)
            out = getPreference(varargin{:});
        end
        
        function setPreferenceTest(varargin)
            setPreference(varargin{:});
        end
        
    end
    
    
    %% Properties
    properties (Constant, Access=protected)
        AppName char = 'App Window Test Helper'
    end %properties
    
    
    %% Constructor and Destructor
    methods
        
        % Constructor
        function obj = AppWindowHelper(varargin)
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
            
            % Now, make the uifigure visible
            obj.Visible = 'on';
            
        end %function
        
    end %methods
    
    
    
    %% Protected Methods
    methods (Access=protected)
        
        function create(obj)
            
            % Put something on the uifigure
            obj.h.TestControl = uilabel(...
                'Parent',obj.Figure,...
                'Text','Test Control',...
                'Position',[1 1 200 25]);
            
        end %function
        
        function redraw(obj)
            
            obj.h.TestControl.Text = 'Unit Test';
            
        end %function
        
    end %methods
    
end % classdef