classdef EditablePopup < uiw.abstract.EditablePopupControl
    % EditablePopup - A popup control with editable text
    %
    % Create a widget that is an editable popup/combobox/dropdown
    %
    % Syntax:
    %           w = uiw.widget.EditablePopup('Property','Value',...)
    %
    % Limitations for uifigure:
    %
    %   KeyPressFcn and KeyReleaseFcn are not available. You can't trigger
    %   a callback while typing.
    %   
    
    %   Copyright 2017-2019 The MathWorks Inc.
    %
    % Auth/Revision:
    %   MathWorks Consulting
    %   $Author: rjackey $
    %   $Revision: 324 $
    %   $Date: 2019-04-23 08:05:17 -0400 (Tue, 23 Apr 2019) $
    % ---------------------------------------------------------------------
    
    
    %% Properties
    properties (AbortSet)
        Items cell = cell(0,1) %Cell array of all items in the list [cell of strings]
    end
    
    properties (AbortSet)
        SelectedIndex double % The selected index from the list of choices (0 if edited)
    end
    
    
    %% Constructor / Destructor
    methods
        function obj = EditablePopup(varargin)
            
            % Call superclass constructors
            obj@uiw.abstract.EditablePopupControl();
            
            % These args must be set last
            [lastArgs,firstArgs] = obj.splitArgs({'SelectedIndex'},varargin{:});
            
            % Set properties from P-V pairs
            obj.assignPVPairs(firstArgs{:});
            
            % Set selected index - both figure and uifigure compatible
            if numel(lastArgs) == 2
                selIndex = lastArgs{2};
                if selIndex <= numel(obj.Items)
                    obj.Value = obj.Items{selIndex};
                end
            end
            
        end % constructor
        
    end %methods - constructor/destructor
    
    
    
    %% Protected methods
    methods (Access=protected)
        
        function createJavaComponent(obj)
            
            % Call superclass method
            obj.createJavaComponent@uiw.abstract.EditablePopupControl(value);
            
            obj.updateSelection();
            
        end %function
        
        
        function createWebControl(obj)
            
            % Create
            obj.WebControl = uidropdown(...
                'Parent',obj.hBasePanel,...
                'Editable',true,...
                'Items',obj.Items,...
                'Value',obj.Value,...
                'ValueChangedFcn', @(h,e)obj.onTextEdited(h,e) );
            
            obj.hTextFields(end+1) = obj.WebControl;
            
            obj.updateSelection();
            
        end %function
        
        
        function updateItems(obj)
            
            % Ensure the construction is complete
            if obj.IsConstructed
                
                if obj.FigureIsJava
                    % If the Items was just edited, perhaps we shouldn't replace
                    % the whole model. Only replace model if very new Items? Check
                    % performance.
                    items = obj.Items;
                    if isempty(items)
                        items = {''};
                    end
                    currentValue = obj.Value;
                    jModel = javaObjectEDT('javax.swing.DefaultComboBoxModel',items);
                    obj.JControl.setModel(jModel);
                    javaMethod('setSelectedItem',obj.JControl,currentValue);
                elseif ~isempty(obj.WebControl)
                    obj.WebControl.Items = obj.Items;
                    obj.setValue(obj.Value);
                else
                    obj.setValue(obj.Value);
                end
                
            end %if obj.IsConstructed
        
        end %function
        
        
        function updateSelection(obj,newValue)
            
            % Ensure the construction is complete
            if obj.IsConstructed && ~isempty(newValue) && ...
                    newValue <= numel(obj.Items)
                
                if obj.FigureIsJava
                    obj.CallbacksEnabled = false;
                    if newValue~=0
                        obj.Value = obj.Items{newValue};
                    else
                        obj.Value = '';
                    end
                    %javaMethodEDT('setSelectedIndex',obj.JControl,value-1);
                    obj.CallbacksEnabled = true;
                elseif ~isempty(obj.WebControl)
                    obj.WebControl.Value = obj.Items{newValue};
                end
                
            end %if obj.IsConstructed
            
        end %function
        
        
        function onTextEdited(obj,~,e)
            % Handle interaction with text field
            
            % Ensure the construction is complete
            if obj.isvalid && obj.IsConstructed && obj.CallbacksEnabled
                
                str = deblank(obj.getValue());
                value = obj.interpretStringAsValue(str);
                
                % What do we do next?
                if isa(e,'java.awt.event.KeyEvent')
                    % Key press
                    
                    % Prepare event data
                    evt = struct('Source', obj, ...
                        'Interaction', 'KeyPress', ...
                        'PendingValue', value, ...
                        'PendingString', str, ...
                        'OldSelectedIndex', obj.SelectedIndex, ...
                        'NewSelectedIndex', [],...
                        'OldValue', obj.Value, ...
                        'NewValue', obj.Value);
                    
                    % Call the callback
                    if ~isequal(evt.OldValue,evt.PendingValue)
                        obj.callCallback(evt);
                    end
                    
                elseif ~checkValue(obj,value)
                    % Value was invalid, so revert
                    
                    %obj.CallbacksEnabled = false;
                    str = obj.interpretValueAsString(obj.Value);
                    obj.setValue(str);
                    %obj.CallbacksEnabled = true;
                    
                elseif ~isequal(obj.Value, value)
                    % Trigger callback if value changed
                    
                    % Prepare event data
                    evt = struct('Source', obj, ...
                        'Interaction', 'Edit', ...
                        'OldSelectedIndex', obj.SelectedIndex, ...
                        'NewSelectedIndex', [],...
                        'OldValue', obj.Value, ...
                        'NewValue', value,...
                        'NewString', str);
                    
                    % Set the value
                    obj.Value = value;
                    evt.NewSelectedIndex = obj.SelectedIndex;
                    
                    % Call the callback
                    obj.callCallback(evt);
                    
                end %if ~ok
                
            end %if obj.IsConstructed && obj.CallbacksEnabled
            
        end %function
        
    end % Protected methods
    
    
    %% Get/Set methods
    methods
        
        % Items
        function set.Items(obj,value)
            validateattributes(value,{'cell'},{})
            value = cellstr(value(:)');
            obj.Items = value;
            obj.updateItems();
        end
        
        % SelectedIndex
        function value = get.SelectedIndex(obj)
            
            % Ensure the construction is complete
            if obj.IsConstructed
                
                if obj.FigureIsJava
                    value = javaMethodEDT('getSelectedIndex',obj.JControl) + 1;
                    if value==0
                        value = [];
                    end
                else
                    value = find(obj.WebControl.Value == string(obj.WebControl.Items),1);
                end
            else
                value = obj.SelectedIndex;
            end %if obj.IsConstructed
        end
        
        function set.SelectedIndex(obj,value)
            
            % Ensure the construction is complete
            if obj.IsConstructed
                
                validateattributes(value,{'numeric'},{'nonnegative','integer','finite','<=',numel(obj.Items)})
                obj.SelectedIndex = value;
                obj.updateSelection(value);

            end %if obj.IsConstructed
             
        end
        
    end % Get/Set methods
    
end % classdef
