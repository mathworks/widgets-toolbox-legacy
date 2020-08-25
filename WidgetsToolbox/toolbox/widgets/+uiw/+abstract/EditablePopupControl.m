classdef (Abstract) EditablePopupControl < uiw.abstract.JavaEditableText
    % EditablePopupControl - Base class for a popup control with editable text
    %
    % Create a widget that is an editable popup/combobox/dropdown
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
    properties (Access = protected)
        ArgsAfterLaunch = cell(1,0)
    end
    
    
    %% Constructor / Destructor
    methods
        function obj = EditablePopupControl(varargin)
            % Construct the control
            
            % Default value (twice as AbortSet treats [] and '' the same)
            obj.Value = 'temp';
            obj.Value = '';
            
            % Set properties from P-V pairs
            obj.assignPVPairs(varargin{:});
            
        end % constructor
    end %methods - constructor/destructor
    
    
    
    %% Public Methods
    methods
        
        function [str,data] = onCopy(obj)
            % Execute a copy operation on the control
            
            if obj.FigureIsJava
                obj.JEditor.copy();
                str = clipboard('paste');
            else
                str = obj.WebControl.Value;
            end
            data = str;
            
        end %function
        
        
        function [str,data] = onCut(obj)
            % Execute a cut operation on the control
            
            if obj.FigureIsJava
                obj.JEditor.cut();
                str = clipboard('paste');
            else
                str = obj.WebControl.Value;
            end
            data = str;
            
        end %function
        
        
        function onPaste(obj,str)
            % Execute a paste operation on the control
            
            if ischar(str) && obj.FigureIsJava
                obj.JEditor.paste();
            end
            
        end %function
        
        
        function requestFocus(obj)
            % Request focus
            
            % Overridden to set the editor in focus, not the control
            if obj.FigureIsJava
                obj.JEditor.requestFocusInWindow();
            end
            
        end %function
        
    end %methods
    
    
    
    %% Protected methods
    methods (Access=protected)
        
        function createJavaComponent(obj)
            
            % Create the control
            %obj.createJControl('javax.swing.JComboBox');
            % The JIDE version expands the dropdown to accomodate wide text
            obj.createJControl('com.jidesoft.combobox.ListComboBox');
            obj.JControl.setEnabled(true);
            obj.JControl.setEditable(true);
            obj.JControl.ActionPerformedCallback = @(h,e)onTextEdited(obj,'ActionPerformedCallback',e);
            %obj.JControl.FocusLostCallback = @(h,e)onTextEdited(obj,'FocusLostCallback',e);
            %obj.JControl.KeyReleasedCallback = @(h,e)onTextEdited(obj,'KeyReleasedCallback',e);
            %obj.JControl.KeyPressedCallback = @(h,e)onKeyPressed(obj,e);
            %obj.JControl.KeyReleasedCallback = @(h,e)onKeyReleased(obj,e);
            obj.JEditor = javaObjectEDT(obj.JControl.getEditor().getEditorComponent());
            obj.JEditor.setOpaque(true); %Needed for background color
            
            % For JComboBox, the *editor* is what needs focusability
            obj.JControl.setFocusable(false);
            obj.setFocusProps(obj.JEditor);
            
            % Default value (twice as AbortSet treats [] and '' the same)
            obj.Value = 'temp';
            obj.Value = '';
            
        end %function
        
        
        function onResized(obj)
            % Handle changes to widget size
            
            % Ensure the construction is complete
            if obj.IsConstructed
                
                if obj.FigureIsJava
                    
                    % Get widget dimensions
                    [w,h] = obj.getInnerPixelSize;
                    
                    % Calculations for a normal uicontrol popup:
                    % FontSize =  10: Height = 25
                    % FontSize =  20: Height = 42
                    % FontSize =  50: Height = 92
                    % FontSize = 100: Height = 175
                    % Buffer is 8-9, so h = FontSize*1.6666 + 8
                    
                    % Calculate popup height based on font size
                    if strcmp(obj.FontUnits,'points')
                        hW = round(obj.FontSize*1.666666) + 8;
                        pos = [1 h-hW+1 w hW];
                    else
                        pos = [1 1 w h];
                    end
                    
                    % Update position
                    set(obj.HGJContainer,'Position',pos);
                    
                else
                    obj.onResized@uiw.abstract.JavaEditableText();
                end
                
            end %if obj.IsConstructed
            
        end %function onResized(obj)
        
        
        % This method may be overridden for custom behavior
        function onStyleChanged(obj,~)
            % Handle updates to style and value validity changes
            
            % Ensure the construction is complete
            if obj.IsConstructed
                
                % Call superclass methods
                onStyleChanged@uiw.abstract.JavaEditableText(obj);
                
                % Also need font change on list part (JIDE only)
                % This fails, because it doesn't widen to the new list
                %jList = obj.JControl.getList;
                %jList.setFont(obj.getJFont());
                
            end %if obj.IsConstructed
            
        end %function
        
        
        function onFocusLost(obj,h,e)
            % Triggered on focus lost from the control - subclass may override
            
            % Call superclass method
            obj.onFocusLost@uiw.abstract.JavaControl(h,e);
            
            % Complete any text edits
            obj.onTextEdited('FocusLost',e);
            
        end %function
        
        
        function setValue(obj,value)
            % Set the selection to Java control
            
            if isStringScalar(value)
                value = char(value);
            end
            validateattributes(value,{'char'},{})
            
            if obj.FigureIsJava
                javaMethodEDT('setSelectedItem',obj.JControl,value);
            else
                obj.setValue@uiw.abstract.JavaEditableText(value);
            end
            
        end %function
        
    end % Protected methods
    
end % classdef
