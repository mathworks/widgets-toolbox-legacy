classdef SingleSessionAppHelper < uiw.abstract.SingleSessionApp
    % SingleSessionAppHelper - Unit Test helper for uiw.abstract.SingleSessionApp
    %
    % Notes:
    %
    %
    
    % Copyright 2018 The MathWorks, Inc.
    %
    % Auth/Revision:
    %   MathWorks Consulting $Author: rjackey $ $Revision: 139 $  $Date: 2018-05-24 09:05:40 -0400 (Thu, 24 May 2018) $
    % ---------------------------------------------------------------------

    
    %% Override Methods for Testing
    methods
        
        function statusOk = promptToSave(obj,~,~)
            % Override save dialog - always save without prompt
            
            statusOk = ~any(obj.IsDirty) || ...
                obj.saveSessionToFile(obj.SessionPath,obj.Session);
            
        end %function
        
        
        function throwError(~,varargin)
            % Override error dialogs
            
            if isa(varargin{1},'MException')
                rethrow(varargin{1});
            else
                error('unitTest:throwTextError',varargin{:});
            end
            
        end %function
        
        
        function helperSetSessionPath(obj,name)
            
            obj.SessionPath = name;
            
        end %function
        
    end %methods
    
    
    %% Properties
    properties (Constant, Access=protected)
        AppName char = 'Single Session App Test Helper'
    end %properties
    
    
    %% Constructor and Destructor
    methods
        
        % Constructor
        function obj = SingleSessionAppHelper(varargin)
            % Construct the app
            
            % Call superclass constructor
            obj@uiw.abstract.SingleSessionApp();
            
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
        
        function redraw(obj)
            
            obj.h.TestControl.String = 'Unit Test';
            
        end %function
        
        function sessionObj = createSession(~)
            %Creation of the session object
            
            sessionObj = struct('Status','Session Created');
            
        end %function
        
        
        function onSessionSet(obj,~)
            %What to do when the session changes
            
            obj.redraw();
            
        end %function
        
        
        function create(obj)
            
            % Put something on the uifigure
            obj.h.TestControl = uicontrol(...
                'Parent',obj.Figure,...
                'Style','text',...
                'String','Test Control',...
                'Units','pixels',...
                'Position',[1 1 200 25]);
            
        end %function
        
    end %methods
    
end % classdef