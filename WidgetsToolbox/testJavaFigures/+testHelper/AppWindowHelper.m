classdef AppWindowHelper < uiw.abstract.AppWindow
    % AppWindowHelper - Unit Test helper for uiw.abstract.AppWindow
    %
    % Notes:
    %
    %
    
    % Copyright 2018 The MathWorks, Inc.
    %
    % Auth/Revision:
    %   MathWorks Consulting $Author: rjackey $ $Revision: 109 $  $Date: 2018-05-04 11:18:12 -0400 (Fri, 04 May 2018) $
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
            obj@uiw.abstract.AppWindow();

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
            obj.h.TestControl = uicontrol(...
                'Parent',obj.Figure,...
                'Style','text',...
                'String','Test Control',...
                'Units','pixels',...
                'Position',[1 1 200 25]);
            
        end %function
        
        function redraw(obj)
            
            obj.h.TestControl.String = 'Unit Test';
            
        end %function
        
    end %methods
    
end % classdef