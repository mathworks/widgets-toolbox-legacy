classdef ProgressBar < uiw.abstract.WidgetContainer & uiw.mixin.HasCallback
    % ProgressBar - A progress and status indicator
    %
    % Create a widget with fixed text.
    %
    % Syntax:
    %           w = uiw.widget.ProgressBar('Property','Value',...)
    %
    
    %   Copyright 2017-2019 The MathWorks Inc.
    %
    % Auth/Revision:
    %   MathWorks Consulting
    %   $Author: rjackey $
    %   $Revision: 335 $
    %   $Date: 2019-05-06 09:37:15 -0400 (Mon, 06 May 2019) $
    % ---------------------------------------------------------------------
    
    % Future features:
    % - Unique identifier / singleton behavior
    % - Time estimate

    %% Properties
    properties (AbortSet)
        AllowCancel (1,1) logical = false %Enables a Cancel button during progress
        FlagCancel (1,1) logical = false %Indicates that Cancel button was pressed
    end
    
    properties (Dependent, AbortSet)
        BorderColor %Color of the bar's border (default='none')
        ProgressColor %Color of the bar's progress (defaults to dark blue)
    end
    
    properties (SetAccess = protected)
        IsRunning (1,1) logical = false %Indicates that progress is counting
        Value (1,1) double {mustBeNonnegative, mustBeLessThanOrEqual(Value,1)} = 0 %Current progress displayed (read-only)
        StatusText char %Current text displayed (read-only)
    end
    
    
    
    %% Constructor / Destructor
    methods
        
        function obj = ProgressBar(varargin)
            % Construct the widget
            
            % Call superclass constructors
            obj@uiw.abstract.WidgetContainer();
            
            % Set defaults
            obj.ForegroundColor = [1 1 1];
            obj.BackgroundColor = [.4 .4 .4];
            
            % Create graphics objects
            obj.create();
            
            % Populate public properties from P-V input pairs
            obj.assignPVPairs(varargin{:});
            
            % Special case - do this before construction is marked to avoid
            % drawnow call
            obj.redraw();
            
            % Assign the construction flag
            obj.IsConstructed = true;
            
            % Redraw the widget
            obj.onResized();
            obj.onEnableChanged();
            obj.onStyleChanged();
            
        end % constructor
        
    end %methods - constructor/destructor
    
    
    
    %% Public Methods
    methods
        
        function startProgress(obj, text)
            % Begin the progress bar
            
            narginchk(1,2)
            if nargin<2
                text = '';
            end
            
            obj.FlagCancel = false;
            obj.IsRunning = true;
            obj.Value = 0;
            obj.StatusText = text;
            obj.redraw();
            
        end %function 
        
        
        function setProgress(obj, value, text)     
            % Set the progress bar and status text
            
            narginchk(2,3)
            
            obj.IsRunning = true;
            obj.Value = value;
            if nargin >= 3
                obj.StatusText = text;
            end
            obj.redraw();
            
        end %function
        
        
        function finishProgress(obj, text)   
            % Finish the progress bar
            
            narginchk(1,2)
            if nargin<2
                text = '';
            end  
            
            obj.FlagCancel = false;
            obj.IsRunning = false;
            obj.Value = 0;
            obj.StatusText = text;
            obj.redraw();
            
        end %function
        
        
        function setStatusText(obj, text)
            % Set the status text
            
            narginchk(2,2)
            obj.StatusText = text;
            obj.redraw();
            
        end %function
        
    end %methods
    
    
    
    %% Protected Methods
    methods (Access=protected)
        
        function create(obj)
            
            % Axes
            obj.h.Axes = axes(...
                'Parent',obj.hBasePanel,...
                'Units','normalized',...
                'ActivePositionProperty','Position',...
                'Position',[0 0 1 1],...
                'Color','none',...
                'LineWidth',2,...
                'XLim',[0 1],...
                'YLim',[0 1],...
                'XTick',{},...
                'YTick',{},...
                'ZTick',{},...
                'HandleVisibility','off',...
                'HitTest','off',...
                'PickableParts','none',...
                'Box','on');
                
            % Progress bar
            pos = [0 0 0 1];
            obj.h.ProgressBar = rectangle(obj.h.Axes,...
                'Position',pos,...
                'EdgeColor','none',...
                'HandleVisibility','off',...
                'HitTest','off',...
                'PickableParts','none',...
                'FaceColor',[0.05 0.25 0.5]);
            
            % Border
            obj.h.Border = rectangle(obj.h.Axes,...
                'Position',[0 0 1 1],...
                'LineWidth',2,...
                'EdgeColor',obj.BackgroundColor,...
                'HandleVisibility','off',...
                'HitTest','off',...
                'PickableParts','none',...
                'FaceColor','none');
            
            % Status text
            obj.h.StatusText = text(...
                'Parent',obj.h.Axes,...
                'Position',[0.5 0.5 1],...
                'BackgroundColor','none',...
                'HandleVisibility','off',...
                'HitTest','off',...
                'PickableParts','none',...
                'HorizontalAlignment','center',...
                'VerticalAlignment','middle');
            
            % Cancel button
            obj.h.CancelButton = uicontrol(...
                'Parent',obj.hBasePanel,...
                'Style','pushbutton',...
                'CData',uiw.utility.loadIcon( @()imread('stop_16.png') ),...
                'Units','pixels',...
                'Position',[1 1 28 28],...
                'Tag','Cancel',...
                'Callback',@(h,e)onButtonPressed(obj,e));
            
            
        end %function
        
        
        function redraw(obj)
            % Handle state changes that may need UI redraw - subclass may override
            
            % Update the controls
            obj.h.Axes.Visible = uiw.utility.tf2onoff( obj.IsRunning );
            obj.h.Border.Visible = uiw.utility.tf2onoff( obj.IsRunning );
            obj.h.ProgressBar.Position(3) = obj.Value;
            obj.h.StatusText.String = obj.StatusText;
            obj.h.CancelButton.Visible = uiw.utility.tf2onoff( obj.IsRunning && obj.AllowCancel );
            obj.h.CancelButton.Enable = uiw.utility.tf2onoff( ~obj.FlagCancel );
                
            % Force drawnow only after construction is complete
            if obj.IsConstructed
                drawnow('limitrate')
            end
            
        end % redraw
        
        
        function onResized(obj)
            % Handle changes to widget size - subclass may override
            
            % Ensure the construction is complete
            if obj.IsConstructed
                
                % What space do we have?
                [w,h] = obj.getInnerPixelSize();
                butSz = obj.h.CancelButton.Position(3:4);
                h = max(h, butSz(2));
                w = max(w, butSz(1));
                pad = obj.Padding;
                %spc = obj.Spacing;
                bw = 3; %border width

                % Calculate positions
                hAvail = h - 2*pad - 2*bw;
                butSz = min(butSz, hAvail);
                xb = w - pad - bw - butSz(1);
                yb = (h - butSz(2)) / 2;
                obj.h.CancelButton.Position = [xb yb butSz];
                
            end %if obj.IsConstructed
            
        end %function
        
        
        function onEnableChanged(obj,~)
            % Handle updates to Enable state
            if obj.IsConstructed
                
                % Call superclass methods
                onEnableChanged@uiw.abstract.WidgetContainer(obj);
                
            end %if obj.IsConstructed
        end % function
        
        
        function onStyleChanged(obj,~)
            % Handle updates to style and value validity changes
            if obj.IsConstructed
                
                % Call superclass methods
                onStyleChanged@uiw.abstract.WidgetContainer(obj);
                
                % Set additional styles for this widget
                obj.h.StatusText.BackgroundColor = 'none';
                obj.h.StatusText.Color = obj.ForegroundColor;
                
            end %if obj.IsConstructed
        end % function
        
        
        function onButtonPressed(obj,evt)
            % Triggered on button press
            
            % Set cancel flag
            obj.FlagCancel = true;
            
            % Call the callback, if one exists
            evt = struct('Source', obj, ...
                'Interaction', evt.Source.Tag);
            obj.callCallback(evt);
                
        end % function
        
    end %methods
    
    
    
    %% Get/Set Methods
    methods

        function set.AllowCancel(obj,value)
            obj.AllowCancel = value;
            obj.redraw();
        end

        function set.FlagCancel(obj,value)
            obj.FlagCancel = value;
            obj.redraw();
        end
        
        function value = get.BorderColor(obj)
            value = obj.h.Border.EdgeColor;
        end
        function set.BorderColor(obj,value)
            obj.h.Border.EdgeColor = value;
        end
        
        function value = get.ProgressColor(obj)
            value = obj.h.ProgressBar.FaceColor;
        end
        function set.ProgressColor(obj,value)
            obj.h.ProgressBar.FaceColor = value;
        end
        
    end %methods
    
    
end % classdef
