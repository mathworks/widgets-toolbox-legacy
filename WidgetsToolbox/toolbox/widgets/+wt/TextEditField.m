classdef TextEditField < wt.abstract.WidgetBase & wt.abstract.HasCallback
    % TextEditField - A field for editable text
    %
    % Create a widget with an editable text field, and optional history
    % dropdown. 
    %
    % Syntax:
    %           w = wt.TextField('Property','Value',...)
    %
    
    %   Copyright 2020 The MathWorks Inc.
    %
    % Auth/Revision:
    %   MathWorks Consulting
    %   $Author: rjackey $
    %   $Revision: 324 $
    %   $Date: 2019-04-23 08:05:17 -0400 (Tue, 23 Apr 2019) $
    % ---------------------------------------------------------------------
    
    %% Properties
    properties (Dependent, AbortSet)
        
        Value (1,1) string
        
    end %properties
    
    %% Internal Properties
    properties (Access = protected)
        EditControl (1,1) matlab.ui.control.EditField
    end
    
    
    %% Protected methods
    methods (Access = protected)
        
        function setup(obj)
            
            % Call superclass methods
            obj.setup@wt.abstract.WidgetBase();
          
            obj.EditControl = uieditfield(obj.Grid,...
                'HorizontalAlignment','center',...
                'ValueChangedFcn',@(h,e)obj.callCallback(e),...
                'ValueChangingFcn',@(h,e)obj.callCallback(e));
            
        end %function  
    
    end %methods
    
    
    %% Get/Set methods
    methods
        
        function set.Value(obj,value)
            obj.EditField.Value = value;
        end
        function value = get.Value(obj)
            value = obj.EditField.Value;
        end
        
    end % methods
    
end % classdef

