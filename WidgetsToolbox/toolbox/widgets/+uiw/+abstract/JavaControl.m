classdef (Abstract) JavaControl < uiw.abstract.WidgetContainer & uiw.mixin.HasKeyEvents
    % JavaControl - Base class for widgets with a Java control
    %
    % This is an abstract base class and cannot be instantiated. It
    % provides the basic properties and methods needed for a widget with a
    % Java control. It also has a label which may optionally be used. The
    % label will be shown once any Label* property has been set.
    %
    % For UI figures compatibility, the component is not created until
    % it's placed into a figure. If the component is placed in a
    % traditional figure, the createWebControl method is called. If
    % placed in a uifigure, the createJavaComponent is called. Detection of
    % the placement in a figure is achieved by listening for the event
    % LocationChanged. The detection ceases once there is an ancestor
    % figure for the component.
    %
    
    %   Copyright 2009-2023 The MathWorks Inc.
    
    
    %% Properties
    properties (Hidden, SetAccess=protected)
        WebControl % The web control (if UI figures used)
        JControl % The main Java control (if traditional figures used)
        JavaObj % The raw Java control object without MATLAB callbacks
        JScrollPane % The Java scrollpane (applies to some controls)
        JEditor % The editor component of the Java control (applies to some controls)
        HGJContainer % The container for the Java control
        
        FigurePlacementListener % Used to track when the component is first placed in a figure
        FigureIsJava (1,1) logical = false
        JavaFrameListener
        ControllerListener
    end
    
    properties (AbortSet, Hidden, SetAccess=protected)
        CallbacksEnabled logical = true % Are callbacks active or should then be suspended? (in case updating a java widget would trigger undesired callbacks)
    end
    
    
    %% Events
    events
        MouseDrag %Triggered on mouse drag over the control
        MouseMotion %Triggered on mouse motion over the control
    end
    
    
    %% Abstract Methods
    methods (Abstract, Access = protected)
        createJavaComponent(obj)
        createWebControl(obj)
    end
    
    
    %% Constructor / Destructor
    methods
        function obj = JavaControl(varargin)
            
            % Call superclass constructors
            obj@uiw.mixin.HasKeyEvents();
            obj@uiw.abstract.WidgetContainer()
            
            obj.FigurePlacementListener = event.listener(obj,...
                'LocationChanged',@(h,e)onLocationChanged(obj,e));
            
            % Apply parent last
            [parentArgs,remArgs] = obj.splitArgs({'Parent'},varargin{:});
            
            % Set properties from P-V pairs
            obj.assignPVPairs(remArgs{:},parentArgs{:});
            
        end % constructor
    end %methods - constructor/destructor
    
    
    
    %% Public methods
    methods
        % These may be implemented by subclass if desired
        
        function [str,data] = onCopy(obj) %#ok<STOUT>
            % Triggered on copy interaction - subclass may override
            error('Copy not implemented for %s',class(obj));
        end
        
        function [str,data] = onCut(obj) %#ok<STOUT>
            % Triggered on cut interaction - subclass may override
            error('Cut not implemented for %s',class(obj));
        end
        
        function onPaste(obj,~)
            % Triggered on paste interaction - subclass may override
            error('Paste not implemented for %s',class(obj));
        end
        
        function requestFocus(obj)
            if obj.IsConstructed && obj.FigureIsJava
                obj.JControl.requestFocusInWindow();
            end
        end
        
    end %methods
    
    
    %% Sealed Protected methods
    methods (Sealed, Access=protected)
        
        function createScrollPaneJControl(obj,JavaClassName,varargin)
            % Create the Java control on a scroll pane, and set any additional properties
            
            jControl = obj.constructJObj(JavaClassName,varargin{:});
            obj.JScrollPane = createJControl(obj,'com.mathworks.mwswing.MJScrollPane',jControl);
            obj.JControl = jControl;
            obj.JavaObj = java(jControl);
            
        end %function
        
        
        function [jControl,hgContainer] = createJControl(obj, JavaClassName, varargin)
            % Create the Java control and set any additional properties
            
            [jControl, hgContainer] = javacomponent([{JavaClassName},varargin],...
                [1 1 100 100], obj.hBasePanel); %#ok<JAVCM>
            set(hgContainer,'Units','Pixels','Position',[1 1 100 25]);
            if nargout<2
                obj.HGJContainer = hgContainer;
                if nargout<1
                    obj.JControl = jControl;
                    obj.JavaObj = java(jControl);
                end
            end
            
            % Set focusability of the object
            obj.setFocusProps(jControl);
            
        end % createControl
        
        
        function setInteractions(obj)
            % Set Java control interactions
            
            % Set keyboard callbacks
            
            if obj.FigureIsJava
                obj.JControl.KeyPressedCallback = @(h,e)onKeyPressed(obj,e);
                obj.JControl.KeyReleasedCallback = @(h,e)onKeyReleased(obj,e);
            else
                if isprop(obj.WebControl,'KeyPressFcn')
                    obj.WebControl.KeyPressFcn = @(h,e)onKeyPressed(obj,e);
                    obj.WebControl.KeyReleaseFcn = @(h,e)onKeyReleased(obj,e);
                end
            end
            
        end % setFocusProps
        
        
        function setFocusProps(obj,jControl)
            % Set Java control focusability and tab order
            
            if obj.FigureIsJava
                jControl.putClientProperty('TabCycleParticipant', true);
                jControl.setFocusable(true);
                
                CbProps = handle(jControl,'CallbackProperties');
                CbProps.FocusGainedCallback = @(h,e)onFocusGained(obj,h,e);
                CbProps.FocusLostCallback = @(h,e)onFocusLost(obj,h,e);
            else
                % Not Applicable
            end
            
        end % setFocusProps
        
        
        function value = getJFont(obj)
            % Return a Java font object matching the widget's font settings
            
            jStyle = 0;
            if strcmp(obj.FontWeight,'bold')
                jStyle = jStyle + java.awt.Font.BOLD;
            end
            if strcmp(obj.FontAngle,'italic')
                jStyle = jStyle + java.awt.Font.ITALIC;
            end
            % Convert value from points to pixels
            %http://stackoverflow.com/questions/6257784/java-font-size-vs-html-font-size
            % Java font is in pixels, and assumes 72dpi. Windows is
            % typically 96dpi and up, depending on display settings.
            jSize = round(obj.FontSize * obj.getJavaDPI() / 72);
            value = javax.swing.plaf.FontUIResource(obj.FontName, jStyle, jSize);
            
        end %function
        
        
        function evt = getMouseEventData(obj,jEvent)
            % Interpret a Java mouse event and return MATLAB data
            
            % Prepare eventdata
            evt = uiw.event.MouseEvent();
            evt.HitObject = obj;

            % Get info on the click location and type
            evt.Position = [jEvent.getX() jEvent.getY()];
            evt.ControlOn = jEvent.isControlDown();
            evt.ShiftOn = jEvent.isShiftDown();
            evt.AltOn = jEvent.isAltDown();
            evt.MetaOn = jEvent.isMetaDown();
            evt.Button = jEvent.getButton();
            evt.NumClicks = jEvent.getClickCount();

            if (evt.MetaOn || evt.ControlOn) && ~evt.ShiftOn
                evt.SelectionType = "alt";
            elseif  (evt.ShiftOn && ~evt.MetaOn)
                evt.SelectionType = "extend";
            elseif evt.NumClicks > 1
                evt.SelectionType = "open";
            else
                evt.SelectionType = "normal";
            end
            
            switch jEvent.getID()
                case 500
                    evt.Interaction = "ButtonClicked";
                case 501
                    evt.Interaction = "ButtonDown";
                case 502
                    evt.Interaction = "ButtonUp";
                case 503
                    evt.Interaction = "ButtonMotion";
                case 506
                    evt.Interaction = "ButtonDrag";
            end %switch jEvent.getID()
            
        end %function
        
        
        function evt = getKeyboardEventData(~,jEvent)
            % Interpret a Java keyboard event and return MATLAB data
            
            % Get info on the key event
            ctrlOn = jEvent.isControlDown();
            shiftOn = jEvent.isShiftDown();
            altOn = jEvent.isAltDown();
            modifier = {'shift','control','alt'};
            modifier = modifier([shiftOn ctrlOn altOn]);
            
            character = jEvent.getKeyChar();
            paramStr = jEvent.paramString();
            tokens = regexp(char(paramStr),'^(\w*).*keyText=([^,]*)','tokens','once');
            
            key = lower(tokens{2});
            
            % Prepare eventdata
            evt = uiw.event.KeyboardEvent(...
                'Character',character,...
                'Modifier',modifier,...
                'Key',key);
            
        end %function
        
        
        function showContextMenu(obj,cMenu)
            
            % Default to normal context menu
            if nargin<2
                cMenu = obj.UIContextMenu;
            end
            
            % Display the context menu
            if ~isempty(cMenu)
                tPos = getpixelposition(obj.HGJContainer,true);
                jmPos = obj.JControl.getMousePosition();
                if ~isempty(jmPos)
                    dpiAdj = 96/obj.getJavaDPI();
                    mx = jmPos.getX() * dpiAdj;
                    my = jmPos.getY() * dpiAdj;
                    if isempty(obj.JScrollPane)
                        xScroll = 0;
                        yScroll = 0;
                    else
                        xScroll = obj.JScrollPane.getHorizontalScrollBar().getValue() * dpiAdj;
                        yScroll = obj.JScrollPane.getVerticalScrollBar().getValue() * dpiAdj;
                    end
                    mPos = [mx+tPos(1)-xScroll tPos(2)+tPos(4)-my+yScroll];
                    set(cMenu,'Position',mPos,'Visible','on');
                end
            end
            
        end %function
        
    end % Sealed Protected methods
    
    
    
    %% Protected methods
    methods (Access=protected)
        
        function createComponent(obj,~)
            
            fig = ancestor(obj.Parent,'figure');
            
            if isempty(fig)
                warning('No ancestor figure to place component %s',class(obj));
            else
                
                % Is it a Java figure or web uifigure?
                obj.FigureIsJava = verLessThan('matlab','9.9') || ~matlab.ui.internal.isUIFigure(fig);
                
                if obj.FigureIsJava
                    
                    % Turn off javacomponent warning
                    warnState = warning('off','MATLAB:ui:javacomponent:FunctionToBeRemoved');
                    
                    % Call abstract method that must create the component
                    obj.createJavaComponent()
                    
                    % Restore warning
                    warning(warnState);
                    
                else
                    % It's a web uifigure
                    
                    % obj.HGJContainer = uicontainer(...
                    %     'Parent',obj.hBasePanel,...
                    %     'Units','Pixels',...
                    %     'Position',[1 1 100 25]);
                    
                    % Call abstract method that must create the component
                    obj.createWebControl();
                    
                end %if obj.FigureIsJava
                
                % Set interactions
                obj.setInteractions();
                
                % Stop listening for placement in a figure
                delete(obj.FigurePlacementListener);
                
                % Assign the construction flag
                obj.IsConstructed = true;
                
                % Redraw the widget
                obj.onResized();
                obj.onEnableChanged();
                obj.onStyleChanged();
                obj.redraw();
                
            end %if isempty(fig)
            
        end %function
        
        
        function onFocusGained(obj,~,~)
            % Triggered on focus on the control, sets this widget as the figure's current object
            
            if obj.FigureIsJava
                hFigure = ancestor(obj,'figure');
                hFigure.CurrentObject = obj;
            end
            
        end
        
        
        function onFocusLost(~,~,~)
            % Triggered on focus lost from the control - subclass may override
            
        end
        
        
        function onKeyPressed(obj,jEvent)
            
            % Get the keyboard event data
            evt = obj.getKeyboardEventData(jEvent);
            
            % Call superclass method
            obj.onKeyPressed@uiw.mixin.HasKeyEvents(evt);
            
        end %function
        
        
        function onKeyReleased(obj,jEvent)
            
            % Get the keyboard event data
            evt = obj.getKeyboardEventData(jEvent);
            
            % Call superclass method
            obj.onKeyReleased@uiw.mixin.HasKeyEvents(evt);
            
        end %function
        
        
        function onResized(obj)
            % Handle changes to widget size - subclass may override
            
            % Ensure the construction is complete
            if obj.IsConstructed 
                
                % Get widget dimensions
                [w,h] = obj.getInnerPixelSize();
                
                if obj.FigureIsJava
                    % Adjust the java control, due to positioning issues
                    set(obj.HGJContainer,'Units','pixels','Position',[2 2 w-2 h-2]);
                else
                    % Position the web control
                    obj.WebControl.Position = [1 1 w h];
                end
                
            end %if obj.IsConstructed
            
        end %function
        
        
        function onEnableChanged(obj,~)
            % Handle updates to Enable state - subclass may override
            
            % Ensure the construction is complete
            if obj.IsConstructed
                
                % Call superclass methods
                onEnableChanged@uiw.abstract.WidgetContainer(obj);
                
                % Enable/Disable the Java control
                IsEnable = strcmp(obj.Enable,'on');
                for idx = 1:numel(obj.JScrollPane)
                    sb1 = get(obj.JScrollPane(idx),'VerticalScrollBar');
                    sb2 = get(obj.JScrollPane(idx),'HorizontalScrollBar');
                    sb1.setEnabled(IsEnable);
                    sb2.setEnabled(IsEnable);
                end
                for idx = 1:numel(obj.JControl)
                    obj.JControl(idx).setEnabled(IsEnable);
                end
                
            end %if obj.IsConstructed
            
        end % onEnableChanged
        
        
        function onStyleChanged(obj,~)
            % Handle updates to style - subclass may override
            
            % Ensure the construction is complete
            if obj.IsConstructed
                
                % Call superclass methods
                onStyleChanged@uiw.abstract.WidgetContainer(obj);
                
                % Set the font
                if obj.FigureIsJava
                    for idx = 1:numel(obj.JControl)
                        j = obj.JControl(idx);
                        j.setFont(obj.getJFont());
                        j.setBackground( obj.rgbToJavaColor(obj.BackgroundColor) );
                        j.setForeground( obj.rgbToJavaColor(obj.ForegroundColor) );
                    end
                else
                    
                    if isprop(obj.WebControl,'FontName')
                        obj.WebControl.FontName = obj.FontName;
                        obj.WebControl.FontSize = obj.FontSize;
                        obj.WebControl.FontWeight = obj.FontWeight;
                        obj.WebControl.FontAngle = obj.FontAngle;
                    end
                    
                    
                    if isprop(obj.WebControl,'FontColor')
                        obj.WebControl.FontColor = obj.ForegroundColor;
                    elseif  isprop(obj.WebControl,'ForegroundColor')
                        obj.WebControl.ForegroundColor = obj.ForegroundColor;
                    end
                    
                    if isprop(obj.WebControl,'BackgroundColor')
                        obj.WebControl.BackgroundColor = obj.BackgroundColor;
                    end
                    
                end %if obj.FigureIsJava
                
            end %if obj.IsConstructed
            
        end %function
        
        
        function throwDeprecatedWarning(obj,propName,value)
            
            warnId = 'widgets:Java:DeprecatedProperty';
            if isprop(propName,obj)
                type = 'Property';
            else
                type = 'Method';
            end
            if nargin >= 3
                message = '%s "%s" set to "%s" of widget "%s" is deprecated and is not used in uifigure widgets. To disable this warning, use "warning(''off'',%s)".';
                warning(warnId,message,type,propName,value,class(obj),warnId);
            else
                message = '%s "%s" of widget "%s" is deprecated and is not used in uifigure widgets. To disable this warning, use "warning(''off'',%s)".';
                warning(warnId,message,type,propName,class(obj),warnId);
            end
            
        end %function
        
    end % Protected methods
    
    
    %% Static Protected methods
    methods (Static)
        
        function jObj = constructJObj(JavaClass, varargin)
            % Create the Java object on the Event Dispatch Thread (EDT)
            
            jObj = javaObjectEDT(JavaClass,varargin{:});
            
            % Add callback properties
            jObj = handle(jObj,'CallbackProperties');
            
        end %function
        
        
        function jColor = rgbToJavaColor(rgbColor)
            % Convert a MATLAB RGB vector into a Java color resource
            
            validateattributes(rgbColor,{'double'},{'<=',1,'>=',0,'numel',3})
            jColor = javax.swing.plaf.ColorUIResource(rgbColor(1),rgbColor(2),rgbColor(3));
            
        end %function
        
        
        function rgbColor = javaColorToRGB(jColor)
            % Convert a MATLAB RGB vector into a Java color resource
            
            validateattributes(jColor,{'javax.swing.plaf.ColorUIResource'},...
                {'scalar'})
            rgbColor = double([jColor.getRed(), jColor.getGreen(), jColor.getBlue()])/255;
            
        end %function
        
        
        function value = getJavaDPI()
            
            persistent dpi
            if isempty(dpi)
                defaultToolkit = java.awt.Toolkit.getDefaultToolkit();
                dpi = defaultToolkit.getScreenResolution();
            end
            value = dpi;
            
        end %function
        
    end %methods


    %% Private Methods
    methods (Access = private)
        
        function onLocationChanged(obj,evt)
            if ~obj.IsConstructed && ~isempty(ancestor(obj,'figure'))
                obj.createComponent(evt);
            end
        end

    end %methods
    
    
    %% Get/Set methods
    methods
        
        % CallbacksEnabled
        function value = get.CallbacksEnabled(obj)
            value = obj.IsConstructed && obj.CallbacksEnabled;
        end
        function set.CallbacksEnabled(obj,value)
            if isvalid(obj) && obj.IsConstructed
                if value && obj.FigureIsJava %#ok<MCSUP>
                    drawnow;
                end
                obj.CallbacksEnabled = value;
            end
        end
        
        
        function set.WebControl(obj,value)
            validateattributes(value,{'matlab.graphics.Graphics'},{'scalar'});
            obj.WebControl = value;
        end
        
    end %methods
    
end % classdef