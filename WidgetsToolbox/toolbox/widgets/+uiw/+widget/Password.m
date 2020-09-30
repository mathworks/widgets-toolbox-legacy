classdef Password < uiw.abstract.JavaEditableText
    % Password - A password control that hides typed characters
    %
    % Create a widget for entering a password
    %
    % Syntax:
    %     w = uiw.widget.Password('Property','Value',...)
    %
    
%   Copyright 2017-2020 The MathWorks Inc.
    %
    % 
    %   
    %   
    %   
    %   
    % ---------------------------------------------------------------------
    
        
    
    %% Constructor / Destructor
    methods
        
        function obj = Password(varargin)
            
            % Call superclass constructor
            obj@uiw.abstract.JavaEditableText(varargin{:});
            
        end % constructor
        
    end %methods - constructor/destructor
    
    
    
    %% Protected methods
    methods (Access=protected)
        
        function createJavaComponent(obj)
            
            % Create
            obj.createJControl('javax.swing.JPasswordField');
            obj.JEditor = obj.JControl;
            obj.JControl.ActionPerformedCallback = @(h,e)onTextEdited(obj,h,e);
            
        end %function
        
        
        function createWebControl(obj)
            
            % Create
            % obj.WebControl = uieditfield(...
            %     'Parent',obj.hBasePanel,...
            %     'ValueChangedFcn', @(h,e)obj.onTextEdited() );
            %obj.hTextFields(end+1) = obj.WebControl;
            
            %To allow disable:
            % <input type="password" id="pass" name="password" style="width:100%;height:100%" disabled>
            html = ['<input type="password" id="pass" name="password" style="width:100%;height:100%">',...
                '<script type="text/javascript">',...
                'function setup(htmlComponent) {',...
                'document.getElementById("pass").addEventListener("input", function() {',...
                'htmlComponent.Data = document.getElementById("pass").value;',...
                '});',...
                '}',...
                '</script>'];
            
            
            obj.WebControl = uihtml(...
                'Parent',obj.hBasePanel,...
                'HTMLSource',html,...
                'DataChangedFcn',@(h,e)obj.onTextEdited() );
            
            
        end %function
        
        
        function value = getValue(obj)
            % Get the text from Java control - subclass may override
            
            if ~obj.IsConstructed
                value = char(obj.Value);
            elseif obj.FigureIsJava
                value = obj.getValue@uiw.abstract.JavaEditableText();
            else
                value = obj.WebControl.Data;
            end %if ~obj.IsConstructed
            
            if ~isempty(value)
                value = value(:)';
            end
            
        end %function
        
        
        function setValue(obj,value)
            % Set the text to Java control - subclass may override
            
            if isstring(value) && isscalar(value)
                value = char(value);
            end
            validateattributes(value,{'char'},{})
            
            if ~obj.IsConstructed
                obj.Value = value;
            elseif obj.FigureIsJava
                obj.setValue@uiw.abstract.JavaEditableText(value);
            else
                obj.WebControl.Data = value;
            end
            
        end %function
        
        
        function onFocusLost(obj,h,e)
            % Triggered on focus lost from the control
            
            % Call superclass method
            obj.onFocusLost@uiw.abstract.JavaControl(h,e);
            
            % Complete any text edits
            obj.onTextEdited(h,e);
            
        end %function
        
    end % Protected methods
    
end % classdef