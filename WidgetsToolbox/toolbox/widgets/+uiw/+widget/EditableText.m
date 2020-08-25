classdef EditableText < uiw.abstract.EditableTextControl
    % EditableText - A simple text or numeric edit field
    %
    % Create a widget with editable text.
    %
    % Syntax:
    %           w = uiw.widget.EditableText('Property','Value',...)
    %
    
%   Copyright 2005-2020 The MathWorks Inc.
    %
    % 
    %   
    %   
    %   
    %   
    % ---------------------------------------------------------------------
    
    %% Constructor / Destructor
    methods
        
        function obj = EditableText(varargin)
            % Construct the widget
            
            % Call superclass constructors
            obj@uiw.abstract.EditableTextControl();
            
            % Populate public properties from P-V input pairs
            obj.assignPVPairs(varargin{:});
            
            % Assign the construction flag
            obj.IsConstructed = true;
            
            % Do the following only if the object is not a subclass
            if strcmp(class(obj), 'uiw.widget.EditableText') %#ok<STISA>
                
                % Assign the construction flag
                obj.IsConstructed = true;
                
                % Redraw the widget
                obj.onResized();
                obj.onEnableChanged();
                obj.redraw();
                obj.onStyleChanged();
                
            end %if strcmp(class(obj),...
            
        end % constructor
        
    end %methods - constructor/destructor
    
end % classdef
