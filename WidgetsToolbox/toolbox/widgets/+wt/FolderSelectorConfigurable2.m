classdef FolderSelectorConfigurable2 < wt.abstract.WidgetBase & ...
        wt.abstract.HasCallback
    % FolderSelectorConfigurable2 - A folder selection control with browse button
    %
    % Create a widget that allows you to specify a folder by editable
    % text or by dialog. Optimum height of this control is 25 pixels.
    %
    % Syntax:
    %           w = wt.FolderSelectorConfigurable2('Property','Value',...)
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
    properties (AbortSet)
        
        % The current value shown. If a RootDirectory is used, this will be
        % a relative path to the root.
        Value (1,1) string
        
        History (:,1) string
        
        TrackHistory (1,1) logical = false;
        
    end %properties
    
    
    properties (Dependent, SetAccess = protected)
        
        % Absolute path to the file. If RootDirectory is used, this will
        % show the full path combining the root and the Value property.
        FullPath
        
    end %properties
    
    
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
    
    
    %% Internal Properties
    properties (Access = protected)
        ButtonControl (1,1) matlab.ui.control.Button
        EditControl matlab.ui.control.WebComponent
    end
    
    
    
    %% Protected methods
    methods (Access = protected)
        
        function setup(obj)
            
            % Call superclass method to establish the grid
            obj.setup@wt.abstract.WidgetBase();
            
            % Configure Grid
            obj.Grid.ColumnWidth = {'1x',25};
            obj.Grid.RowHeight = {'1x'};
            
            % Create the edit control
            obj.setupEditControl();
            
            % Create Button
            obj.ButtonControl = uibutton(obj.Grid, ...
                'Text','',...
                'Icon','folder_24.png',...
                'ButtonPushedFcn',@(h,e)obj.onButtonPushed(e));
            
        end %function
        
        
        function setupEditControl(obj)
            % Create the specified edit control type, removing any existing
            % one
            
            % Remove existing control
            delete(obj.EditControl)
            
            % Create new control
            if obj.TrackHistory
                obj.EditControl = uidropdown(obj.Grid,...
                    'Editable',true,...
                    'ValueChangedFcn',@(h,e)obj.onTextChanged(e));
            else
                obj.EditControl = uieditfield(obj.Grid,...
                    'ValueChangedFcn',@(h,e)obj.onTextChanged(e));
            end %if
            
            % Place it in the same spot
            obj.EditControl.Layout.Row = 1;
            
        end %function
        
        
        function update(obj)
            
            % Update the dropdown history
            if obj.TrackHistory
                %items = vertcat(obj.Value, obj.History);
                items = obj.History;
                obj.EditControl.Items = items;
            end %if obj.TrackHistory
            
            % Update the edit control text
            obj.EditControl.Value = obj.Value;
            
            % Indicate invalid paths
            if strlength(obj.Value) && ~exist(obj.FullPath,'dir')
                %obj.EditControl.BackgroundColor = [1 .9 .9];
                obj.BackgroundColor = 'red';
            else
                %obj.EditControl.BackgroundColor = [1 1 1];
                obj.BackgroundColor = 'white';
            end
            
        end %function
        
        
        function updateHistory(obj,newValue)
            % Update the history and verify paths
            
            newHistory = obj.History;
            
            % Prepend new value, if provided
            if nargin >= 2
                newHistory = vertcat(newValue, newHistory);
            end
            
            % Remove duplicates
            newHistory = unique(newHistory,'stable');
            
            % Verify paths
            allPaths = fullfile(obj.RootDirectory, newHistory);
            isValid = arrayfun(@(x)exist(x,'dir'),allPaths);
            newHistory(~isValid) = [];
            
            % Limit length
            newHistory(9:end) = [];
                
            % Store result
            obj.History = newHistory;
                
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
                
                % Append history
                obj.updateHistory(obj.Value);
                
                % Call callback
                evtOut = matlab.ui.eventdata.ValueChangedData(obj.Value, oldValue,...
                    "FullPath",obj.FullPath);
                notify(obj,'ValueChanged',evtOut);
                obj.callCallback(evtOut);
                
            end %if ~isempty(fullPath) && ~isequal(fullPath,0)
            
        end %function
        
        
        function onTextChanged(obj,evt)
            % Triggered on text interaction - subclass may override
            
            % Trim the result
            newValue = strtrim(evt.Value);          
            
            % Remove any trailing filesep
            if endsWith(newValue,filesep)
                newValue(end) = [];
            end
            
            % Set the new value
            oldValue = obj.Value;
            obj.Value = newValue;
            
            % Append history
            obj.updateHistory(obj.Value);
            
            % Call callback
            evtOut = matlab.ui.eventdata.ValueChangedData(newValue, oldValue,...
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
        
        function set.TrackHistory(obj,value)
            obj.TrackHistory = value;
            obj.setupEditControl();
        end
        
    end % Get/Set methods
    
    
end % classdef