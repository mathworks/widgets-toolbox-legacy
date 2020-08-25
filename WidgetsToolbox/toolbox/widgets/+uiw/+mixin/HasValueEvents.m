classdef (Hidden, Abstract) HasValueEvents < handle
    % HasValueEvents - Mixin to provide key events for a widget
    % ---------------------------------------------------------------------
    % This is a mixin class. It provides event handling for a widget.
    %
    % This class may change in the future.
    
%   Copyright 2018-2020 The MathWorks Inc.
    %
    % 
    %   
    %   
    %   
    % ---------------------------------------------------------------------
    
    
    %% Events
    events
        ValueChanging %Triggered on value changing within the control
    end
    
    
    
    %% Properties
    properties (AbortSet, Hidden)
        %function handle to call when value is changing but not confirmed, such as by typing a character
        ValueChangingFcn function_handle = function_handle.empty(0,1) 
    end
    
    
    %% Methods
    
    methods (Hidden, Access=protected)
        
        function onValueChanging(obj,data)
            % Triggered on value changing
            
            % If the input data was an eventdata, use it. If data was not
            % an eventdata, assume data is the new value itself and create
            % an eventdata
            if isa(data,'matlab.ui.eventdata.ValueChangingData')
                evt = data;
            else
                evt = matlab.ui.eventdata.ValueChangingData(data);
            end
            
            % Trigger this event
            notify(obj,'ValueChanging',evt);
            
            % Call the callback
            if ~isempty(obj.ValueChangingFcn)
                obj.ValueChangingFcn(obj, evt);
            end
            
        end %function
        
    end %methods
    
end %classdef