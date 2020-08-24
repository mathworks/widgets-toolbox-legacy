classdef DemoUiFigureSingleSessionApp < uiw.abstract.SingleSessionApp
    % App - Class definition for a MATLAB desktop application
    % ---------------------------------------------------------------------
    % Instantiates the Application figure window
    %
    % Syntax:
    %           app = demoUiFigureApps.DemoUiFigureSingleSessionApp
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
        function obj = DemoUiFigureSingleSessionApp(varargin)
            % Construct the app
            
            % Call superclass constructor
            obj@uiw.abstract.SingleSessionApp('FigureType','uifigure');
            
            % Create the file menu from SessionManagement & SingleSessionApp
            obj.createFileMenu();
            
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
            
            obj.Menu.MyMenu = uimenu(...
                'Parent',obj.Figure,...
                'Label','MyMenu',...
                'Tag','MyMenu');
            
            obj.Menu.Robyn = uimenu(...
                'Parent',obj.Menu.MyMenu,...
                'Label','Robyn',...
                'Tag','Robyn');
            
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
        
        
        function sessionObj = createSession(~)
            %Creation of the session object
            
            sessionObj = demoAppPkg.model.DataModel();
            
        end %function
        
        
        function onSessionSet(obj,~)
            %What to do when the session changes
            
            % New model, so full redraw is needed
            obj.redraw();
            
        end %function
        
    end %methods
    
    
end %classdef

