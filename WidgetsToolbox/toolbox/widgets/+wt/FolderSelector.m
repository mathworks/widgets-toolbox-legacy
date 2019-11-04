classdef FolderSelector < wt.abstract.WidgetBase & wt.abstract.HasTextEditField
    % FolderSelector - A folder selection control with browse button
    %
    % Create a widget that allows you to specify a folder by editable
    % text or by dialog. Optimum height of this control is 25 pixels.
    %
    % Syntax:
    %           w = wt.FolderSelector('Property','Value',...)
    %
    
    %   Copyright 2020 The MathWorks Inc.
    %
    % Auth/Revision:
    %   MathWorks Consulting
    %   $Author: rjackey $
    %   $Revision: 324 $
    %   $Date: 2019-04-23 08:05:17 -0400 (Tue, 23 Apr 2019) $
    % ---------------------------------------------------------------------
    
    events
        ValueChanged
    end
    
    %% Public properties
%     properties (AbortSet)
%         
%         Value
%         
%     end %properties
    
    
    % These properties do not trigger the update method
    properties (UsedInUpdate = false)
        
        % Optional default directory to start in when Value does not exist
        % and user clicks the browse button.
        DefaultDirectory (1,1) string
        
        % Optional root directory. If unspecified, Value uses an absolute
        % path (default). If specified, Value will show a relative path to
        % the root directory. ['']
        RootDirectory (1,1) string
        
        % Indicates whether the Value must be a subdirectory of the
        % RootDirectory. If false, the value could be a directory above
        % RootDirectory expressed with '..\' to go up levels in the
        % hierarchy.
        RequireSubdirOfRoot (1,1) logical = false
        
    end %properties
    
    
    properties (Dependent, SetAccess = protected)
        
        % Absolute path to the file. If RootDirectory is used, this equals
        % fullfile(obj.RootDirectory, obj.Value). Otherwise, it is the same
        % as obj.Value.
        FullPath
        
    end %properties
    
    
    %% Internal Properties
    properties (Access = protected)
        ButtonControl (1,1) matlab.ui.control.Button
    end
    
    
    %% Protected methods
    methods (Access = protected)
        
        function setup(obj)
            
            % Call superclass method to establish the grid
            obj.setup@wt.abstract.WidgetBase();
            
            % Configure Grid
            obj.Grid.ColumnWidth = {'1x',25};
            obj.Grid.RowHeight = {'1x'};
            
            % Create text field from superclass method
            obj.setup@wt.abstract.HasTextEditField(obj.Grid);
            
            % Create Button
            obj.ButtonControl = uibutton(obj.Grid, ...
                'Text','',...
                'Icon','folder_24.png',...
                'ButtonPushedFcn',@(h,e)obj.onButtonPushed(e));
            
        end %function
        
        
        function update(obj)
            
            % Call superclass method
            obj.update@wt.abstract.HasTextEditField();
            
            % Update the edit control text
            obj.EditControl.Value = obj.Value;
            
            % Update validity by file existance or not
            % obj.TextIsValid = checkPathExists(obj,value);
            
        end %function
        
        
        function onButtonPushed(obj,~)
            % Triggered on button pushed
            
            % What folder should the prompt start at?
            if exist(obj.FullPath,'dir')
                initialPath = obj.FullPath;
            elseif exist(obj.DefaultDirectory,'dir')
                initialPath = obj.DefaultDirectory;
            else
                initialPath = pwd;
            end
            
            % Prompt user for the path
            fullPath = uigetdir(initialPath,'Select a folder');
            
            % Save result (unless they cancelled)
            if ~isequal(fullPath,0)
                
                % Store new result
                oldValue = obj.Value;
                obj.FullPath = fullPath;
                
                % Call callback
                evtOut = matlab.ui.eventdata.ValueChangedData(obj.Value, oldValue,...
                    "FullPath",obj.FullPath);
                notify(obj,'ValueChanged',evtOut);
                obj.callCallback(evtOut);
                
            end %if ~isempty(fullPath) && ~isequal(fullPath,0)
            
        end %function
        
        
        function onTextChanged(obj,evt)
            % Triggered on text interaction - subclass may override
            
            % Set the new value
            oldValue = obj.Value;
            obj.Value = evt.Value;
            
            % Call callback
            evtOut = matlab.ui.eventdata.ValueChangedData(obj.Value, oldValue,...
                "FullPath",obj.FullPath);
            notify(obj,'ValueChanged',evtOut);
            obj.callCallback(evtOut);
            
        end % onTextEdited
        
        
        function pathExists = checkPathExists(obj,relPath)
            % Verify whether the path exists
            
            thisPath = fullfile(obj.RootDirectory, relPath);
            pathExists = ~isempty(dir(thisPath));
            
        end %function checkValidPath
        
    end % Protected methods
    
    
    
    %% Get/Set methods
    methods
        
        function value = get.FullPath(obj)
            value = fullfile(obj.RootDirectory, obj.Value);
        end
        function set.FullPath(obj,value)
            try
                obj.Value = wt.utility.getRelativeFilePath(value,...
                    obj.RootDirectory, obj.RequireSubdirOfRoot);
            catch err
                hDlg = errordlg(err.message,'File Selection','modal');
                uiwait(hDlg);
            end
        end
        
    end % Get/Set methods
    
    
end % classdef