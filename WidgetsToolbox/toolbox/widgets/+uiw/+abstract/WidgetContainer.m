classdef WidgetContainer < uiw.mixin.AssignPVPairs & ...
        matlab.ui.componentcontainer.ComponentContainer & uiw.mixin.HasContainer
    %uiw.abstract.BaseContainer
    %uiw.abstract.BasePanel & uiw.abstract.BaseLabel
    % WidgetContainer - Base class for a graphical widget
    %
    % This class provides the basic properties needed for a panel that will
    % contain a group of graphics objects to build a complex widget. It
    % also has a label which may optionally be used. The label will be
    % shown once any Label* property has been set.
    %
    
    %   Copyright 2008-2019 The MathWorks Inc.
    %
    % Auth/Revision:
    %   MathWorks Consulting
    %   $Author: rjackey $
    %   $Revision: 324 $
    %   $Date: 2019-04-23 08:05:17 -0400 (Tue, 23 Apr 2019) $
    % ---------------------------------------------------------------------
    
    %% Properties
    properties (AbortSet, UsedInUpdate = false)
        Enable = 'on' %Allow interaction with this widget [(on)|off]
        Padding = 0 %Pixel spacing around the widget (applies to some widgets)
        Spacing = 4 %Pixel spacing between controls (applies to some widgets)
    end %properties
    
    properties (AbortSet, Dependent, UsedInUpdate = false)
        FontAngle %Style of the font [(normal)|italic]
        FontName %Name of the font
        FontSize %Size of the font
        FontUnits %Units of the font [inches|centimeters|characters|normalized|(points)|pixels]
        FontWeight %Weight of the font [(normal)|bold]
        ForegroundColor %Foreground/font color of the panel
    end %properties
    
    properties (Access=protected, UsedInUpdate = false)
        hBasePanel %The internal panel upon which the widget contents are placed
        hLabel %The label control
    end %properties
    
    properties (SetAccess=protected, UsedInUpdate = false)
        h = struct() %For widgets to store internal graphics objects
        hLayout = struct() %For widgets to store internal layout objects
        IsConstructed = false %Indicates widget has completed construction, useful for optimal performance to minimize redraws on launch, etc.
    end %properties
    
    
    %% Properties
    properties (AbortSet, Dependent)
        Label char %The label (char). If set, LabelVisible changes to 'on'.
        LabelFontAngle char %Font angle of the label [(normal)|italic]
        LabelFontName char %Font name of the label
        LabelFontSize double %Font size of the label
        LabelFontUnits char %Font units of the label [inches|centimeters|characters|normalized|(points)|pixels]
        LabelFontWeight char %Font weight of the label [(normal)|bold]
        LabelForegroundColor %Font color of the label
        LabelHorizontalAlignment char %Alignment of the label
        LabelVisible char %Toggles the label visibility [on|(off)]
        LabelTooltipString char %Tooltip of the label
    end %properties
    
    properties (AbortSet)
        %Placement of the label [(left)|right|top|bottom]
        LabelLocation char {mustBeMember(LabelLocation,{'left','right','top','bottom'})} = 'left'
        
        %Pixel height of label (applies to top|bottom location)
        LabelHeight (1,1) double {mustBePositive} = 20
        
        %Pixel width of label (applies to left|right location)
        LabelWidth (1,1) double {mustBePositive} = 75
        
        %Pixel spacing between label and widget
        LabelSpacing (1,1) double {mustBeNonnegative} = 4
    end %properties
    
    properties (Access=protected)
        LabelVisible_ (1,1) logical = false; %Cache of LabelVisible
    end
    
    properties (SetAccess=immutable, GetAccess=protected)
        %hLabel %The label control
    end %properties
    
    
    %% Properties
    properties (Access=private)
        InnerSize_ double = [1 1] % Cache of the inner pixel size of the widget (will not report below a minimum size)
    end
    properties (Access=private)
        DestroyedListener %Listener for container destroyed
        VisibleChangedListener %Listener for visibility changes
        SizeChangedListener %Listener for resize of container
        StyleChangedListener %Listener for container style changes
    end
    
    
    
    %% Constructor
    methods
        
        function obj = WidgetContainer()
            % Construct the control
            
            % Call superclass constructors
            obj@matlab.ui.componentcontainer.ComponentContainer('ParentMode','manual');
            
            % Attach listeners and callbacks
            obj.DestroyedListener = event.listener(obj,...
                'ObjectBeingDestroyed',@(h,e)onContainerBeingDestroyed(obj));
            obj.SizeChangedListener = event.listener(obj,...
                'SizeChanged',@(h,e)onContainerResized(obj));
            obj.StyleChangedListener = event.proplistener(obj,...
                findprop(obj,'BackgroundColor'),'PostSet',@(h,e)onStyleChanged(obj,e));
            obj.VisibleChangedListener = event.proplistener(obj,...
                findprop(obj,'Visible'),'PostSet',@(h,e)onVisibleChanged(obj));
            
            % Adjust sizing of label and widget panel
            obj.onContainerResized();
            
        end
        
    end %constructor/destructor methods
    
    
    
    %% Protected methods
    methods (Access=protected)
        
        function setup(obj)
            % To support ComponentContainer
            
            if isempty(obj.hBasePanel)
                %obj.hBasePanel = matlab.ui.container.Panel(...
                obj.Units = 'normalized';
                obj.Position = [0 0 1 1];
                obj.hLabel = uicontrol(...
                    'Parent',obj,...
                    'HandleVisibility','off',...
                    'Style', 'text', ...
                    'HorizontalAlignment','left',...
                    'Units','pixels',...
                    'TooltipString','',...
                    'Visible','off',...
                    'FontSize',10);
                obj.hBasePanel = uipanel(...
                    'Parent',obj,...
                    'HandleVisibility','off',...
                    'BorderType','none',...
                    'Units','pixels',...
                    'FontSize', 10);
            end
            
        end %function
        
        
        function redraw(obj)
            % Handle state changes that may need UI redraw - subclass may override
            
            % Ensure the construction is complete
            if obj.IsConstructed
                
            end %if obj.IsConstructed
            
        end % function
        
        
        function onResized(obj)
            % Handle changes to widget size - subclass may override
            
            % Ensure the construction is complete
            if obj.IsConstructed
                
                
            end %if obj.IsConstructed
            
        end %function
        
        
        function onEnableChanged(obj,hAdd)
            % Handle updates to Enable state - subclass may override
            
            % Ensure the construction is complete
            if obj.IsConstructed
                
                % Find all uicontrols depth 1 that have an Enable field
                if nargin < 2
                    hAdd = [obj.hLabel;
                        findall(obj.hBasePanel,'-property','Enable','-depth',1) ];
                end
                
                % Look for all encapsulated graphics objects in "h" property
                hAll = obj.findHandleObjects();
                
                % Combine them all
                if nargin>1 && ~isempty(hAdd) && all(ishghandle(hAdd))
                    hAll = unique([hAll(:); hAdd(:)]);
                end
                
                % Default behavior: Set all objects with an Enable field
                hHasEnable = hAll( isprop(hAll,'Enable') );
                set(hHasEnable,'Enable',obj.Enable);
                
            end %if obj.IsConstructed
            
        end %function
        
        
        function onVisibleChanged(obj)
            % Handle updates to Visible state - subclass may override
            
            % Ensure the construction is complete
            if obj.IsConstructed
                
            end %if obj.IsConstructed
            
        end %function
        
        
        function onStyleChanged(obj,hAdd)
            % Handle updates to style changes - subclass may override
            
            % Ensure the construction is complete
            if obj.IsConstructed
                
                % Get any other objects at the top level of the widget
                if nargin < 2
                    hAdd = findall(obj.hBasePanel,'-depth',1);
                end
                
                % Look for all encapsulated graphics objects in "h" property
                hAll = obj.findHandleObjects();
                
                % Combine them all
                if ~isempty(hAdd)
                    hAll = unique([hAll(:); hAdd(:)]);
                end
                
                % Set all objects that have font props
                if isprop(obj,'FontName')
                    set(hAll( isprop(hAll,'FontName') ),...
                        'FontName',obj.FontName,...
                        'FontSize',obj.FontSize);
                    set(hAll( isprop(hAll,'FontWeight') ),...
                        'FontWeight',obj.FontWeight,...
                        'FontAngle',obj.FontAngle);
                    try %#ok<TRYNC>
                        set(hAll( isprop(hAll,'FontUnits') ),...
                            'FontUnits',obj.FontUnits);
                    end
                end
                
                % Set all objects that have ForegroundColor
                % Exclude boxpanels
                if isprop(obj,'ForegroundColor')
                    isBoxPanel = arrayfun(@(x)isa(x,'uix.BoxPanel'),hAll);
                    set(hAll( isprop(hAll,'ForegroundColor') & ~isBoxPanel ),...
                        'ForegroundColor',obj.ForegroundColor);
                    
                    % Set all objects that have FontColor
                    set(hAll( isprop(hAll,'FontColor') ),...
                        'FontColor',obj.ForegroundColor);
                end
                
                % Set all objects that have BackgroundColor
                if isprop(obj,'BackgroundColor')
                    hasBGColor = isprop(hAll,'BackgroundColor');
                    set(hAll( hasBGColor ),...
                        'BackgroundColor',obj.BackgroundColor);
                end
                
                
                % Also modify label
                obj.hLabel.BackgroundColor = obj.BackgroundColor;
                
            end %if obj.IsConstructed
            
        end %function
        
        
        function hAll = findHandleObjects(obj)
            
            % Look for all encapsulated graphics objects in "h" property
            %hEncapsulatedCell = struct2cell(obj.h);
            hEncapsulatedCell = [struct2cell(obj.h); struct2cell(obj.hLayout)];
            isGraphicsObj = cellfun(@ishghandle,hEncapsulatedCell,'UniformOutput',false);
            isGraphicsObj = cellfun(@all,isGraphicsObj,'UniformOutput',true);
            hAll = [hEncapsulatedCell{isGraphicsObj}]';
            
        end %function
        
        
        function onContainerBeingDestroyed(obj)
            % Triggered on container destroyed - subclass may override
            
            delete(obj);
            
        end %function
        
    end %methods
    
    
    %% Debugging methods
    methods
        
        function debugRedraw(obj)
            % For debugging only - trigger the widget's protected redraw method
            
            obj.redraw();
            
        end %function
        
        function debugResize(obj)
            % For debugging only - trigger the widget's protected redraw method
            
            obj.onResized();
            
        end %function
        
    end %methods
    
    
    %% Private methods
    methods (Access=private)
        
        function makeLabelVisible(obj)
            % Turns on the label visibility
            
            obj.LabelVisible_ = true;
            uiw.utility.setPropsIfDifferent(obj.hLabel,'Visible','on')
            obj.onContainerResized();
            
        end %function
        
    end %methods
    
    
    
    %% Sealed Protected methods
    methods (Sealed, Access=protected)
        
        function pos = getPixelPosition(obj,recursive)
            % Return the container's pixel position
            
            if strcmp(obj.Units,'pixels') && (nargin<2 || ~recursive)
                pos = obj.Position;
            else
                pos = getpixelposition(obj, recursive);
                pos = ceil(pos);
            end
            
        end %function
        
        
        function [w,h] = getPixelSize(obj)
            % Return the container's outer pixel size
            
            if strcmp(obj.Units,'pixels')
                pos = obj.Position;
            else
                pos = getpixelposition(obj,false);
            end
            w = max(pos(3), 10);
            h = max(pos(4), 10);
        end %function
        
        
        function [w,h] = getInnerPixelSize(obj)
            % Return the widget's inner pixel size
            
            h = obj.InnerSize_(2);
            w = obj.InnerSize_(1);
            
        end % getInnerPixelSize
        
        
        function onContainerResized(obj)
            % Triggered on resize of the widget's container
            
            % Get the outer container position
            [wC,hC] = obj.getPixelSize();
            spc = obj.LabelSpacing;
            pad = obj.Padding;
            wL = obj.LabelWidth;
            hL = obj.LabelHeight;
            
            % Place the label
            if obj.LabelVisible_
                
                switch obj.LabelLocation
                    case 'left'
                        posL = [pad+1 pad+1 wL hC-2*pad];
                        x0U = posL(1)+posL(3)+spc;
                        posU = [x0U pad+1 wC-pad-x0U+1 hC-2*pad];
                        
                    case 'top'
                        posL = [pad+1 hC-pad-hL+1 wC-2*pad hL];
                        hU = posL(2)-pad-spc-1;
                        posU = [pad+1 pad+1 wC-2*pad hU];
                        
                    case 'right'
                        posL = [wC-pad-wL+1 pad+1 wL hC-2*pad];
                        wU = posL(1)-pad-spc-1;
                        posU = [pad+1 pad+1 wU hC-2*pad];
                        
                    case 'bottom'
                        posL = [pad+1 pad+1 wC-2*pad hL];
                        y0U = posL(2)+posL(4)+spc;
                        posU = [pad+1 y0U wC-2*pad hC-pad-y0U+1];
                        
                    otherwise
                        error('Invalid LabelLocation: %s',obj.LabelLocation);
                end
                posU = max(posU,1);
                posL = max(posL,1);
                obj.hLabel.Position = posL;
                obj.hBasePanel.Position = posU;
            else
                % No Label
                posU = [1 1 wC hC];
                posU = max(posU,1);
                obj.hBasePanel.Position = posU;
            end
            
            % Store inner size of the hBasePanel for performance
            obj.InnerSize_ = max(posU(3:4), [10 10]);
            
            % Trigger resize for the rest of the widget
            obj.onResized();
            
        end % function
        
    end %methods
    
    
    
    %% Get/Set methods
    methods
        
        % Enable
        function set.Enable(obj,value)
            value = validatestring(value,{'on','off'});
            evt = struct('Property','Enable',...
                'OldValue',obj.Enable,...
                'NewValue',value);
            obj.Enable = value;
            obj.onEnableChanged(evt);
        end
        
        % Padding
        function set.Padding(obj,value)
            validateattributes(value,{'numeric'},{'real','nonnegative','scalar','finite'})
            obj.Padding = value;
            obj.onContainerResized();
        end
        
        % Spacing
        function set.Spacing(obj,value)
            validateattributes(value,{'numeric'},{'real','nonnegative','scalar','finite'})
            obj.Spacing = value;
            obj.onContainerResized();
        end
        
        % IsConstructed
        function value = get.IsConstructed(obj)
            value = isvalid(obj) && obj.IsConstructed;
        end
        
        % ForegroundColor
        function value = get.ForegroundColor(obj)
            value = obj.hBasePanel.ForegroundColor;
        end
        function set.ForegroundColor(obj,value)
            evt = struct('Property','ForegroundColor',...
                'OldValue',obj.ForegroundColor,...
                'NewValue',value);
            obj.hBasePanel.ForegroundColor = value;
            obj.onStyleChanged(evt);
        end
        
        % FontAngle
        function value = get.FontAngle(obj)
            value = obj.hBasePanel.FontAngle;
        end
        function set.FontAngle(obj,value)
            evt = struct('Property','FontAngle',...
                'OldValue',obj.FontAngle,...
                'NewValue',value);
            obj.hBasePanel.FontAngle = value;
            obj.onStyleChanged(evt);
        end
        
        % FontName
        function value = get.FontName(obj)
            value = obj.hBasePanel.FontName;
        end
        function set.FontName(obj,value)
            evt = struct('Property','',...
                'OldValue',obj.FontName,...
                'NewValue',value);
            obj.hBasePanel.FontName = value;
            obj.onStyleChanged(evt);
        end
        
        % FontSize
        function value = get.FontSize(obj)
            value = obj.hBasePanel.FontSize;
        end
        function set.FontSize(obj,value)
            evt = struct('Property','FontSize',...
                'OldValue',obj.FontSize,...
                'NewValue',value);
            obj.hBasePanel.FontSize = value;
            obj.onStyleChanged(evt);
        end
        
        % FontUnits
        function value = get.FontUnits(obj)
            value = obj.hBasePanel.FontUnits;
        end
        function set.FontUnits(obj,value)
            evt = struct('Property','FontUnits',...
                'OldValue',obj.FontUnits,...
                'NewValue',value);
            obj.hBasePanel.FontUnits = value;
            obj.onStyleChanged(evt);
        end
        
        % FontWeight
        function value = get.FontWeight(obj)
            value = obj.hBasePanel.FontWeight;
        end
        function set.FontWeight(obj,value)
            evt = struct('Property','FontWeight',...
                'OldValue',obj.FontWeight,...
                'NewValue',value);
            obj.hBasePanel.FontWeight = value;
            obj.onStyleChanged(evt);
        end
        
        function set.LabelSpacing(obj,value)
            obj.LabelSpacing = value;
            obj.makeLabelVisible();
        end
        
        function value = get.Label(obj)
            value = obj.hLabel.String;
        end
        function set.Label(obj, value)
            obj.hLabel.String = value;
            obj.makeLabelVisible();
        end
        
        function set.LabelLocation(obj, value)
            obj.LabelLocation = value;
            obj.makeLabelVisible();
        end
        
        function set.LabelWidth(obj, value)
            obj.LabelWidth = value;
            obj.makeLabelVisible();
        end
        
        function set.LabelHeight(obj, value)
            obj.LabelHeight = value;
            obj.makeLabelVisible();
        end
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Pass-through properties that modify the label uicontrol
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        function value = get.LabelVisible(obj)
            value = obj.hLabel.Visible;
        end
        function set.LabelVisible(obj,value)
            obj.hLabel.Visible = value;
            obj.makeLabelVisible();
        end
        
        function value = get.LabelForegroundColor(obj)
            value = obj.hLabel.ForegroundColor;
        end
        function set.LabelForegroundColor(obj,value)
            obj.hLabel.ForegroundColor = value;
        end
        
        function value = get.LabelFontAngle(obj)
            value = obj.hLabel.FontAngle;
        end
        function set.LabelFontAngle(obj,value)
            obj.hLabel.FontAngle = value;
        end
        
        function value = get.LabelFontName(obj)
            value = obj.hLabel.FontName;
        end
        function set.LabelFontName(obj,value)
            obj.hLabel.FontName = value;
        end
        
        function value = get.LabelFontSize(obj)
            value = obj.hLabel.FontSize;
        end
        function set.LabelFontSize(obj,value)
            obj.hLabel.FontSize = value;
        end
        
        function value = get.LabelFontUnits(obj)
            value = obj.hLabel.FontUnits;
        end
        function set.LabelFontUnits(obj,value)
            obj.hLabel.FontUnits = value;
        end
        
        function value = get.LabelFontWeight(obj)
            value = obj.hLabel.FontWeight;
        end
        function set.LabelFontWeight(obj,value)
            obj.hLabel.FontWeight = value;
        end
        
        function value = get.LabelHorizontalAlignment(obj)
            value = obj.hLabel.HorizontalAlignment;
        end
        function set.LabelHorizontalAlignment(obj,value)
            obj.hLabel.HorizontalAlignment = value;
        end
        
        function value = get.LabelTooltipString(obj)
            value = obj.hLabel.TooltipString;
        end
        function set.LabelTooltipString(obj,value)
            obj.hLabel.TooltipString = value;
        end
        
    end % Get/Set methods
    
    
    
    %% Display Customization
    methods (Access=protected)
        
        function propGroup = getPropertyGroups(obj)
            
            widgetProps = properties('uiw.abstract.WidgetContainer');
            thisProps = setdiff(properties(obj), widgetProps);
            propGroup = [
                obj.getWidgetPropertyGroup()
                obj.getLabelPropertyGroup()
                matlab.mixin.util.PropertyGroup(thisProps,'This Widget''s Properties:')
                ];
            
        end %function
        
        
        function propGroup = getWidgetPropertyGroup(obj)
            titleTxt = sprintf(['Common Widget Properties: (<a href = '...
                '"matlab: helpPopup %s">help on this widget</a>)'],class(obj));
            thisProps = {
                'Parent'
                'Enable'
                'Position'
                'Units'
                'Padding'
                'Spacing'
                'FontName'
                'FontSize'
                'FontWeight'
                'ForegroundColor'
                'BackgroundColor'
                'InvalidBackgroundColor'
                'InvalidForegroundColor'
                'Tag'};
            propGroup = matlab.mixin.util.PropertyGroup(thisProps,titleTxt);
        end %function
        
        
        function propGroup = getLabelPropertyGroup(~)
            titleTxt = 'Common Widget Label Properties:';
            thisProps = {
                'Label'
                'LabelLocation'
                'LabelHeight'
                'LabelWidth'
                'LabelFontName'
                'LabelFontSize'
                'LabelFontWeight'
                'LabelForegroundColor'
                'LabelHorizontalAlignment'
                'LabelTooltipString'
                'LabelLocation'
                'LabelHeight'
                'LabelWidth'
                'LabelSpacing'
                'LabelVisible'};
            propGroup = matlab.mixin.util.PropertyGroup(thisProps,titleTxt);
            
        end %function
        
    end %methods
    
end % classdef
