classdef EditableTextWithHistory < uiw.abstract.EditablePopupControl ...
        & uiw.mixin.HasEditableTextField
    % EditableTextWithHistory - A popup control with editable text
    %
    % Create a widget that is for editable text with a popup for history
    %
    % Syntax:
    %           w = uiw.widget.EditableTextWithHistory('Property','Value',...)
    %
    
%   Copyright 2017-2020 The MathWorks Inc.
    %
    % 
    %   
    %   
    %   
    %   
    % ---------------------------------------------------------------------
    
    %% Properties
    properties (AbortSet)
        History (:,1) string %History items list [string]
    end
    
    
    %% Constructor / Destructor
    methods
        function obj = EditableTextWithHistory(varargin)
            
            % Call superclass constructors
            obj@uiw.abstract.EditablePopupControl();
            
            % Set properties from P-V pairs
            obj.assignPVPairs(varargin{:});
            
            % Assign the construction flag
            obj.IsConstructed = true;
            obj.CallbacksEnabled = false;
            
            % Redraw the widget
            obj.onResized();
            obj.onEnableChanged();
            obj.onStyleChanged();
            obj.redraw();
            
            % Now enable callbacks
            obj.CallbacksEnabled = true;
            
        end % constructor
        
    end %methods - constructor/destructor
    
    
    
    %% Protected methods
    methods (Access=protected)
        
        
        function createWebControl(obj)
            
            % Create
            obj.WebControl = uidropdown(...
                'Parent',obj.hBasePanel,...
                'Editable',true,...
                'Items',obj.History,...
                'Value',obj.Value,...
                'ValueChangedFcn', @(h,e)obj.onTextEdited(h,e) );
            
            obj.hTextFields(end+1) = obj.WebControl;
            
        end %function
        
        
        function setValue(obj,value)
            % Set the selection to Java control
            
            validateattributes(value,{'char'},{})
            
            % Add the history
            obj.addHistory(obj.interpretValueAsString(value));
            
            % Call superclass method
            obj.setValue@uiw.abstract.EditablePopupControl(value);
            
        end %function
        
        
        function addHistory(obj,str)
            % Add the string to the top of history
            
            isDupe = strcmp(str,obj.History);
            
            if isempty(str)
                % Do nothing
            elseif obj.FigureIsJava
                obj.CallbacksEnabled = false;
                if any(isDupe)
                    idxDupe = find(isDupe,1);
                    obj.JControl.removeItemAt(idxDupe - 1);
                end
                obj.JControl.insertItemAt(str,0);
                obj.CallbacksEnabled = true;
            elseif ~isempty(obj.WebControl)
                items = obj.WebControl.Items';
                if any(isDupe)
                    idxDupe = find(isDupe,1);
                    items(idxDupe) = [];
                end
                items = [{str}; items];
                obj.WebControl.Items = items;
            else
                items = obj.History;
                if any(isDupe)
                    idxDupe = find(isDupe,1);
                    items(idxDupe) = [];
                end
                items = [{str}; items];
                obj.History = items;
            end
            
        end %function
        
    end % Protected methods
    
    
    %% Get/Set methods
    methods
        
        % Items
        function value = get.History(obj)
            if obj.FigureIsJava
                value = string.empty(0,1);
                if obj.IsConstructed
                    jModel = obj.JControl.getModel();
                    nItems = jModel.getSize();
                    for idx=1:nItems
                        value{idx,1} = char(jModel.getElementAt(idx-1));
                    end
                end
            elseif isempty(obj.WebControl)
                value = obj.History;
            else
                value = string(obj.WebControl.Items(:));
            end
        end
        function set.History(obj,value)
            obj.History = value;
            if obj.FigureIsJava
                currentValue = obj.Value;
                jModel = javaObjectEDT('javax.swing.DefaultComboBoxModel',value);
                obj.CallbacksEnabled = false;
                obj.JControl.setModel(jModel);
                javaMethod('setSelectedItem',obj.JControl,currentValue);
                obj.CallbacksEnabled = true;
            elseif ~isempty(obj.WebControl)
                obj.WebControl.Items = value;
            else
                obj.History = value;
            end
        end
        
    end % Get/Set methods
    
end % classdef
