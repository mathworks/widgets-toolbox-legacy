classdef HasTextEditField < wt.mixin.HasCallback
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
    
    
    %% Abstract Properties
%     properties (Abstract, AbortSet)
    properties (AbortSet)
        
        Value (1,1) string
        
    end %properties
    
    
    %% Properties
    properties (AbortSet)
        
        %Value (1,1) string
        
        History (:,1) string
        TrackHistory (1,1) logical = false;
        
    end %properties
    
    
    
    %% Internal Properties
    properties (Access = protected)
        EditControl matlab.ui.control.EditField
    end %properties
    
    
    %% Protected methods
    methods (Access = protected)
        
        function setup(obj,parent)
          
            obj.EditControl = uieditfield(parent,...
                'ValueChangedFcn',@(h,e)obj.onTextChanged(e),...
                'ValueChangingFcn',@(h,e)obj.callCallback(e));
            
        end %function
        
        
        function update(obj)
            
            % Update the edit control text
            %obj.EditControl.Value = obj.Value;
            
        end %function
        
        
        function onTextChanged(obj,evt)
            % Triggered on text interaction - subclass may override
            
            obj.Value = evt.NewValue;
            
            obj.callCallback(evt);
            
        end % onTextEdited
    
    end %methods
    
    
end % classdef

