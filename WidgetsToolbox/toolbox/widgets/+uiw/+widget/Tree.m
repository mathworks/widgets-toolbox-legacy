classdef Tree < uiw.abstract.JavaControl
    % Tree - A rich tree control
    %
    % Create a rich tree control based on Java JTree
    %
    % Syntax:
    %   nObj = uiw.widget.Tree('Property','Value',...)
    %
    
    %   Copyright 2012-2023 The MathWorks Inc.
    %
    % 
    %   
    %   
    %   
    % ---------------------------------------------------------------------
    
    
    %% Properties
    properties (AbortSet)
        
        %controls whether the tree node text is editable
        Editable (1,1) logical 
        
        %tree nodes that are currently selected
        SelectedNodes
        
        %selection mode ('single','discontiguous')
        SelectionType char {mustBeMember(SelectionType,...
            {'single','contiguous','discontiguous'})} = 'single' 
        
        %callback for a node being expanded
        NodeExpandedCallback 
        
        %callback for a node being collapsed
        NodeCollapsedCallback 
        
        %callback for a node being edited
        NodeEditedCallback 
        
        %callback for change in tree node selection
        SelectionChangeFcn 
        
        %Background color of the tree area
        TreeBackgroundColor = [1 1 1] 
        
    end
    
    
    
    %% Internal properties
    properties (SetAccess=protected, GetAccess=protected)
        JModel %Java model for tree (internal)
        JSelModel %Java tree selection model (internal)
        JDropTarget %Java drop target (internal)
        JTransferHandler %Java transfer handler for DND (internal)
        JCellRenderer %Java cell renderer (internal)
        IsBeingDeleted = false; %true when the destructor is active (internal)
    end
    
    properties (AbortSet, SetAccess={?uiw.widget.Tree, ?uiw.widget.TreeNode})
        
        %Child tree nodes (read-only)
        ChildNodes = uiw.widget.TreeNode.empty(0,1) 
        
    end
    
    %% Deprecated properties
    properties (Hidden)
        
        %controls whether drag and drop is enabled on the tree
        DndEnabled (1,1) logical 
        
        %callback for a key pressed event
        KeyPressedCallback 
        
        %callback when the mouse is clicked on the tree
        MouseClickedCallback 
        
        %callback while the mouse is being moved over the tree
        MouseMotionFcn 
        
        %callback for a node being dragged. A custom callback should return a logical true when the node being dragged over is a valid drop target.
        NodeDraggedCallback 
        
        %callback for a node being dropped. A custom callback should handle the data transfer. If not specified, dragging and dropping nodes just modifies the parent of the nodes that were dragged and dropped.
        NodeDroppedCallback 
        
        %whether the root is visible or not
        RootVisible (1,1) logical 
        
        %Background color of the full pane
        TreePaneBackgroundColor = [1 1 1] 
        
        %Foreground color of the selection in the tree
        SelectionForegroundColor = [0 0 0] 
        
        %Background color of the selection in the tree
        SelectionBackgroundColor = [.2 .6 1] 
        
    end
    
    properties (Hidden, SetAccess=protected)
        
        %the root tree node (uiw.widget.TreeNode or uiw.widget.CheckboxTreeNode)
        Root 
        
    end
    
    
    %% Constructor / Destructor
    methods
        
        function obj = Tree(varargin)
            % Construct the control
            
            % Call superclass method
            obj@uiw.abstract.JavaControl(varargin{:})
            
            % Create the root node if not already done
            if isempty(obj.Root)
                obj.Root = uiw.widget.TreeNode('Name','Root');
            end
            
        end % constructor
        
        
        function delete(obj)
            obj.IsBeingDeleted = true;
            obj.CallbacksEnabled = false;
            delete(obj.Root);
        end % destructor
        
    end %methods - constructor/destructor
    
    
    
    %% Protected Methods
    methods (Access=protected)
        
        function createComponent(obj,evt)
            % Create the component
            
            % Call superclass method
            obj.createComponent@uiw.abstract.JavaControl(evt)
            
        end %function
        
        
        function createWebControl(obj)
            % Create the graphics objects
            
            % Create tree
            obj.WebControl = uitree(...
                'Parent',obj.hBasePanel,...
                'Editable',obj.Editable,...
                'SelectionChangedFcn',@(h,e)onNodeSelection(obj,e),...
                'NodeTextChangedFcn',@(h,e)onNodeEdit(obj,e),...
                'ContextMenu',obj.UIContextMenu,...
                'Multiselect',~strcmpi(obj.SelectionType,'single'));
            
            if ~isequal(obj.DndEnabled,false)
                obj.throwDeprecatedWarning('DndEnabled');
            end
            
            if ~isempty(obj.KeyPressedCallback)
                obj.throwDeprecatedWarning('KeyPressedCallback');
            end
            
            if ~isempty(obj.MouseClickedCallback)
                obj.throwDeprecatedWarning('MouseClickedCallback');
            end
            
            if ~isempty(obj.MouseMotionFcn)
                obj.throwDeprecatedWarning('MouseMotionFcn');
            end
            
            if ~isempty(obj.NodeDraggedCallback)
                obj.throwDeprecatedWarning('NodeDraggedCallback');
            end
            
            if ~isempty(obj.NodeDroppedCallback)
                obj.throwDeprecatedWarning('NodeDroppedCallback');
            end
            
            if ~isequal(obj.RootVisible,false)
                obj.throwDeprecatedWarning('RootVisible');
            end
            
            if ~isequal(obj.SelectionForegroundColor,[0 0 0])
                obj.throwDeprecatedWarning('SelectionForegroundColor');
            end
            
            if ~isequal(obj.SelectionBackgroundColor,[.2 .6 1])
                obj.throwDeprecatedWarning('SelectionBackgroundColor');
            end
            
            if ~isequal(obj.TreePaneBackgroundColor,[1 1 1])
                obj.throwDeprecatedWarning('TreePaneBackgroundColor');
            end
            
        end %function
        
        
        function createJavaComponent(obj)
            % Create the graphics objects
            
            % Create the root node if not already done
            if isempty(obj.Root)
                obj.Root = uiw.widget.TreeNode('Name','Root');
            end
            
            % Create the tree on a scroll pane (unless subclass already
            % did)
            if isempty(obj.JControl)
                % Attach root
                obj.Root.createJavaComponent();
                obj.Root.Tree = obj; 
                obj.Root.IsConstructed = true; 
                obj.createScrollPaneJControl('javax.swing.JTree',obj.Root.JNode);
            end
            
            % Store the model
            obj.JModel = obj.JControl.getModel();
            javaObjectEDT(obj.JModel); % Put it on the EDT
            
            % Store the selection model
            obj.JSelModel = obj.JControl.getSelectionModel();
            javaObjectEDT(obj.JSelModel); % Put it on the EDT
            
            % Set defaults
            obj.SelectionType = 'single'; % Single selection
            obj.JControl.setRowHeight(-1); % Auto row height (for font changes)
            
            % Set the java tree callbacks
            CbProps = handle(obj.JControl,'CallbackProperties');
            %set(CbProps,'KeyPressedCallback',@(src,e)onKeyPressed(obj,e))
            set(CbProps,'MouseClickedCallback',@(src,e)onMouseEvent(obj,e))
            set(CbProps,'MousePressedCallback',@(src,e)onMouseEvent(obj,e))
            set(CbProps,'TreeWillExpandCallback',@(src,e)onExpand(obj,e))
            set(CbProps,'TreeCollapsedCallback',@(src,e)onCollapse(obj,e))
            set(CbProps,'MouseMovedCallback',@(src,e)onMouseEvent(obj,e))
            set(CbProps,'ValueChangedCallback',@(src,e)onNodeSelection(obj,e))
            
            % Set up editability callback
            CbProps = handle(obj.JModel,'CallbackProperties');
            set(CbProps,'TreeNodesChangedCallback',@(src,e)onNodeEdit(obj,e))
            
            % Set up drag and drop
            obj.JDropTarget = obj.constructJObj('java.awt.dnd.DropTarget');
            obj.JControl.setDropTarget(obj.JDropTarget);
            obj.JTransferHandler = obj.constructJObj(...
                'com.mathworks.consulting.widgets.tree.TreeTransferHandler');
            obj.JControl.setTransferHandler(obj.JTransferHandler);
            
            % Set up drop target callbacks
            CbProps = handle(obj.JDropTarget,'CallbackProperties');
            set(CbProps,'DropCallback',@(src,e)onNodeDND(obj,e));
            set(CbProps,'DragOverCallback',@(src,e)onNodeDND(obj,e));
            
            % Allow tooltips
            JTTipMgr = javaMethodEDT('sharedInstance','javax.swing.ToolTipManager');
            JTTipMgr.registerComponent(obj.JControl);
            
            % Use the custom renderer
            obj.JCellRenderer = obj.constructJObj(...
                'com.mathworks.consulting.widgets.tree.TreeCellRenderer');
            setCellRenderer(obj.JControl, obj.JCellRenderer);
            
            % Add properties to the java object for MATLAB data
            hTree = handle(obj.JControl);
            schema.prop(hTree,'Tree','MATLAB array');
            schema.prop(hTree,'UserData','MATLAB array');
            
            % Add a reference to this object
            hTree.Tree = obj;
            
            % Refresh the tree
            reload(obj, obj.Root);
            
            % Set properties
            obj.JControl.setEditable(obj.Editable);
            obj.JControl.setRootVisible(obj.RootVisible); %show/hide root
            obj.JControl.setShowsRootHandles(~obj.RootVisible); %hide/show top level handles
            obj.JControl.setDragEnabled(obj.DndEnabled);
            
            % Set selection mode
            switch obj.SelectionType
                case 'single'
                    mode = obj.JSelModel.SINGLE_TREE_SELECTION;
                case 'contiguous'
                    mode = obj.JSelModel.CONTIGUOUS_TREE_SELECTION;
                case 'discontiguous'
                    mode = obj.JSelModel.DISCONTIGUOUS_TREE_SELECTION;
            end
            obj.JSelModel.setSelectionMode(mode);
            
            % Set initial selection
            selNodes = obj.SelectedNodes;
            if isempty(selNodes)
                
                if ~isempty(obj.JControl.getSelectionPath)
                    obj.JControl.setSelectionPath([])
                end
                
            elseif isa(selNodes,'uiw.widget.TreeNode')
                
                if isscalar(selNodes)
                    obj.JControl.setSelectionPath(selNodes.JNode.getTreePath());
                else
                    for idx = numel(selNodes):-1:1 %preallocate by reversing
                        path(idx) = selNodes(idx).JNode.getTreePath();
                    end
                    obj.JControl.setSelectionPaths(path);
                end
                
            else
                
                error('Expected TreeNode or empty array');
                
            end
            
        end %function
        
        
        function onStyleChanged(obj,~)
            % Handle updates to style changes
            
            % Ensure the construction is complete
            if obj.IsConstructed && obj.FigureIsJava
                
                % Call superclass methods
                onStyleChanged@uiw.abstract.JavaControl(obj);
                
                % Set the background
                jColor = obj.rgbToJavaColor(obj.TreeBackgroundColor);
                obj.JControl.setBackground(jColor);
                
                jColor = obj.rgbToJavaColor(obj.TreePaneBackgroundColor);
                obj.JCellRenderer.setBackgroundNonSelectionColor(jColor);
                
                jColor = obj.rgbToJavaColor(obj.ForegroundColor);
                obj.JCellRenderer.setTextNonSelectionColor(jColor);
                
                jColor = obj.rgbToJavaColor(obj.SelectionForegroundColor);
                obj.JCellRenderer.setTextSelectionColor(jColor);
                
                jColor = obj.rgbToJavaColor(obj.SelectionBackgroundColor);
                obj.JCellRenderer.setBackgroundSelectionColor(jColor);
                
                obj.JControl.repaint();
                
            elseif obj.IsConstructed && ~obj.FigureIsJava
                
                obj.WebControl.BackgroundColor = obj.TreeBackgroundColor;
                obj.WebControl.FontColor = obj.ForegroundColor;
                
            end %if obj.IsConstructed
            
        end %function
        
        
        function onKeyPressed(obj,jEvent)
            % Triggered when any button is pressed in the keyboard
            
            % Call superclass method
            obj.onKeyPressed@uiw.abstract.JavaControl(jEvent);
            
            % Deprecated functionality (KeyPressedCallback)
            if ~isempty(obj.KeyPressedCallback)
                keyCode = jEvent.getKeyCode;
                e1 = struct('KeyPressed',keyCode,'SelectedNodes',obj.SelectedNodes);
                hgfeval(obj.KeyPressedCallback,obj,e1);
            end %if ~isempty(obj.KeyPressedCallback)
            
        end %function onKeyPressed
        
    end %methods
    
    
    
    %% Public Methods
    methods
        function collapseNode(obj,nObj)
            % collapseNode - Collapse a TreeNode within the tree
            % -------------------------------------------------------------------------
            % Abstract: Collapse the specified tree node
            %
            % Syntax:
            %           obj.collapseNode(nObj)
            %
            % Inputs:
            %           obj - Tree object
            %           nObj - TreeNode object
            %
            % Outputs:
            %           none
            %
            
            if ~obj.IsConstructed
                % Do nothing
            elseif obj.FigureIsJava
                obj.CallbacksEnabled = false;
                collapsePath(obj.JControl, nObj.JNode.getTreePath());
                obj.CallbacksEnabled = true;
            else
                collapse(nObj.WNode);
            end
            
        end %function
        
        
        function expandNode(obj,nObj)
            % expandNode - Expand a TreeNode within the tree
            % -------------------------------------------------------------------------
            % Abstract: Expand the specified tree node
            %
            % Syntax:
            %           obj.expandNode(nObj)
            %
            % Inputs:
            %           obj - Tree object
            %           nObj - TreeNode object
            %
            % Outputs:
            %           none
            %
            
            if ~obj.IsConstructed
                % Do nothing
            elseif obj.FigureIsJava
                obj.CallbacksEnabled = false;
                expandPath(obj.JControl, nObj.JNode.getTreePath());
                obj.CallbacksEnabled = true;
            else
                expand(nObj.WNode);
            end
            
        end %function
        
        
        function s = getJavaObjects(obj)
            % Return the Java objects of the tree (for debugging only)
            
            s = struct(...
                'JControl',obj.JControl,...
                'JModel',obj.JModel,...
                'JSelModel',obj.JSelModel,...
                'JScrollPane',obj.JScrollPane,...
                'JDropTarget',obj.JDropTarget,...
                'JTransferHandler',obj.JTransferHandler,...
                'HGJContainer',obj.HGJContainer);
            
        end %function
        
        
        function [str,data] = onCopy(obj)
            % Get the currently selected data, useful for implementing Copy
            % in an application.
            
            data = [obj.SelectedNodes];
            str = strjoin({obj.SelectedNodes.Name},', ');
            
        end %function
        
        
        function [str,data] = onCut(obj)
            % Cut the currently selected data from the tree, useful for
            % implementing Cut in an application.
            
            data = [obj.SelectedNodes];
            str = strjoin({obj.SelectedNodes.Name},', ');
            obj.SelectedNodes.Parent = [];
            
        end %function
        
    end %methods
    
    
    
    %% Special Access Methods
    methods (Access={?uiw.widget.Tree, ?uiw.widget.TreeNode})
        
        function reload(obj,nObj)
            % Reload the specified tree node
            
            if ~isempty([obj.JModel]) && ishandle(nObj.JNode)
                obj.CallbacksEnabled = false;
                obj.JModel.reload(nObj.JNode);
                obj.CallbacksEnabled = true;
            end
            
        end %function
        
        
        function nodeChangedJava(obj,nObj)
            % Triggered on node changes from Java
            
            if ~isempty([obj.JModel]) && ishandle(nObj.JNode)
                obj.CallbacksEnabled = false;
                obj.JModel.nodeChanged(nObj.JNode);
                obj.CallbacksEnabled = true;
            end
            
        end %function
        
        
        function insertNode(obj,nObj,pObj,idx)
            % Insert a node at the specified location
            
            if obj.IsConstructed && obj.FigureIsJava
                
                obj.CallbacksEnabled = false;
                
                % Insert this node
                obj.JModel.insertNodeInto(nObj.JNode, pObj.JNode, idx-1);
                
                % Insert any children
                insertChildrenJava(nObj)
                
                % If this is the first and only child, we need to reload the
                % tree node so it renders correctly
                if all(pObj.Children == nObj)
                    obj.JModel.reload(pObj.JNode);
                end
                
                obj.CallbacksEnabled = true;
                
            elseif obj.IsConstructed && ~obj.FigureIsJava
                
                % Is the parent a tree or another node?
                if isa(pObj,'uiw.widget.Tree')
                    % It's a tree
                    siblings = [pObj.ChildNodes.WNode];
                    nObj.WNode.Parent = pObj.WebControl;
                else
                    % It's a node
                    siblings = [pObj.Children.WNode];
                    nObj.WNode.Parent = pObj.WNode;
                end
                
                if idx == numel(siblings)+1
                    % Do nothing
                elseif idx == 1
                    move(nObj.WNode, siblings(1), 'before');
                else
                    move(nObj.WNode, siblings(idx-1), 'after');
                end
                
                % Insert any children
                insertChildrenWeb(nObj)
                
            end %if obj.IsConstructed && obj.FigureIsJava
            
            
            function insertChildrenWeb(nObj)
                % Recursively add children to the tree
                
                allWNode = [nObj.Children.WNode];
                set(allWNode,'Parent',nObj.WNode);
                
                for cIdx = 1:numel(nObj.Children)
                    if ~isempty(nObj.Children(cIdx).Children)
                        insertChildrenWeb(nObj.Children(cIdx));
                    end
                end
                
            end %function insertChildren(nObj)
            
            
            function insertChildrenJava(nObj)
                % Recursively add children to the tree
                
                for cIdx = 1:numel(nObj.Children)
                    obj.JModel.insertNodeInto(...
                        nObj.Children(cIdx).JNode,...
                        nObj.JNode,...
                        cIdx-1);
                    
                    if ~isempty(nObj.Children(cIdx).Children)
                        insertChildrenJava(nObj.Children(cIdx));
                    end
                end
                
            end %function insertChildren(nObj)
            
        end %function
        
        
        function removeNodeJava(obj,nObj,~)
            % Remove the specified node
            
            if ~isempty(obj) && isvalid(obj) && ...
                    ~isempty([obj.JModel]) && ishandle(nObj.JNode)
                obj.CallbacksEnabled = false;
                obj.JModel.removeNodeFromParent(nObj.JNode);
                % If all children were removed, reload the node
                %if isempty(pObj.Children) && ~isempty(pObj.Tree)
                %    obj.JModel.reload(pObj.JNode);
                %end
                obj.CallbacksEnabled = true;
            end
            
        end %function
        
    end %special access methods
    
        
    
    %% Sealed Protected methods
    methods (Sealed, Access=protected)
        
        
        function evt = getMouseEventData(obj,jEvent)
            % Interpret a Java mouse event and return MATLAB data
            
            % Prepare eventdata
            evt = obj.getMouseEventData@uiw.abstract.JavaControl(jEvent);

            % Add tree-specific things
            addprop(evt,'Nodes');
            evt.Nodes = getNodeFromMouseEvent(obj,jEvent);

        end %function
    
    end %methods


    
    %% Private Methods
    methods (Access=private)
        
        function nObj = getNodeFromMouseEvent(obj,jEvent)
            % Retrieve the tree node from a mouse event from Java
            
            % Was a tree node clicked?
            treePath = obj.JControl.getPathForLocation(jEvent.getX, jEvent.getY);
            if isempty(treePath)
                nObj  = uiw.widget.TreeNode.empty(0,1);
            else
                nObj = get(treePath.getLastPathComponent,'TreeNode');
            end
            
        end %function
        
        
        function onExpand(obj,e)
            % Triggered when a node is expanded
            
            % Is there a custom NodeExpandedCallback?
            if obj.isvalid() && obj.CallbacksEnabled && ~isempty(obj.NodeExpandedCallback)
                
                % Get the tree node that was expanded
                CurrentNode = get(e.getPath.getLastPathComponent,'TreeNode');
                
                % Call the custom callback
                e1 = struct('Nodes',CurrentNode);
                hgfeval(obj.NodeExpandedCallback,obj,e1);
                
            end %if ~isempty(obj.NodeExpandedCallback)
            
        end %function onExpand
        
        
        function onCollapse(obj,e)
            % Triggered when a node is collapsed
            
            % Is there a custom NodeCollapsedCallback?
            if obj.isvalid() && obj.CallbacksEnabled && ~isempty(obj.NodeCollapsedCallback)
                
                % Get the tree node that was collapsed
                CurrentNode = get(e.getPath.getLastPathComponent,'TreeNode');
                
                % Call the custom callback
                e1 = struct('Nodes',CurrentNode);
                hgfeval(obj.NodeCollapsedCallback,obj,e1);
                
            end %if ~isempty(obj.NodeCollapsedCallback)
            
        end %function onCollapse
        
        
        function onMouseEvent(obj,jEvent)
            % Triggered when the mouse is clicked within the pane
            
            if obj.isvalid() && obj.CallbacksEnabled

                % Trigger the appropriate callback and notify
                switch jEvent.getID()

                    case 500 %ButtonClicked

                        % Get mouse event data
                        mEvent = obj.getMouseEventData(jEvent);

                        % Callback
                        hgfeval(obj.MouseClickedCallback,obj,mEvent)

                        % Launch context menu in certain cases
                        if mEvent.SelectionType == "alt" && ~(mEvent.ControlOn && mEvent.Button==1)

                            % If the node was not previously selected, do it
                            if ~isempty(mEvent.Nodes) && ...
                                    ~any(obj.SelectedNodes == mEvent.Nodes)
                                % Call right to Java, so we trigger node
                                % selection callback in this unique case
                                if mEvent.ControlOn
                                    obj.JControl.addSelectionPath(mEvent.Nodes.JNode.getTreePath());
                                else
                                    obj.JControl.setSelectionPath(mEvent.Nodes.JNode.getTreePath());
                                end
                            end

                            % Default to the standard context menu
                            cMenu = obj.UIContextMenu;

                            % Is there a node-specific context menu?
                            if ~isempty(mEvent.Nodes)

                                % Get the custom context menus for selected nodes
                                NodeCMenus = [obj.SelectedNodes.UIContextMenu];

                                % See if there is a common context menu
                                ThisCMenu = unique(NodeCMenus);

                                % Is there a common context menu across all
                                % selected nodes?
                                if ~isempty(NodeCMenus) &&...
                                        numel(NodeCMenus) == numel(obj.SelectedNodes) &&...
                                        all(NodeCMenus(1) == NodeCMenus)

                                    % Use the custom context menu
                                    cMenu = ThisCMenu;
                                end

                            end %if ~isempty(evt.Nodes)

                            % Launch the context menu
                            obj.showContextMenu(cMenu)

                            %elseif isempty(mEvent.Nodes) && ~mEvent.ControlOn && ~mEvent.ShiftOn
                            % Click in white space - deselect everything

                            %    obj.JControl.setSelectionPath([]);

                        end %if mEvent.SelectionType == "alt" && ~mEvent.ControlOn

                    case 501 %ButtonDown

                        if event.hasListener(obj, "ButtonDown")

                            % Get mouse event data
                            mEvent = obj.getMouseEventData(jEvent);

                            % Notify listeners
                            obj.notify('ButtonDown',mEvent);

                        end %if

                    case 502 %ButtonUp
                        % Do nothing - no callback defined

                    case 503 %ButtonMotion

                        if event.hasListener(obj, "MouseMotion")

                            % Get mouse event data
                            mEvent = obj.getMouseEventData(jEvent);

                            % Notify listeners
                            obj.notify('MouseMotion',mEvent);

                        end %if

                    case 506 %ButtonDrag

                        % Currently not called as we have a separate method onNodeDND
                        if event.hasListener(obj, "MouseDrag")

                            % Get mouse event data
                            mEvent = obj.getMouseEventData(jEvent);

                            % Notify listeners
                            obj.notify('MouseDrag',mEvent);

                        end %if

                end %switch jEvent.getID()

            end %if obj.isvalid() && obj.CallbacksEnabled

        end %function onMouseEvent
        
        
        function onMouseMotion(obj,jEvent)
            % Triggered when the mouse moves within the pane
            
            % Only do this if there is a custom MouseMotionFcn
            if obj.isvalid() && obj.CallbacksEnabled && ~isempty(obj.MouseMotionFcn)
                
                obj.onMouseEvent(jEvent);
                
            end %if ~isempty(obj.MouseMotionFcn)
            
        end %function onMouseMotion
        
        
        function onNodeSelection(obj,e)
            % Triggered when the selection of tree paths (nodes) changes
            
            % Has the constructor completed running?
            % Has a treeCallback been specified?
            
            %RAJ - tried a few things here to enable right-clicks for
            %context to call this first to select the node first. It will
            %result in callback firing when programmatically changing nodes
            %though.
            
            
            if obj.isvalid() && obj.CallbacksEnabled && ~isempty(obj.SelectionChangeFcn)
                
                if obj.FigureIsJava
                    
                    % Figure out what nodes were added or removed to/from the
                    % selection
                    p = e.getPaths;
                    AddedNodes = uiw.widget.TreeNode.empty(0,1);
                    RemovedNodes = uiw.widget.TreeNode.empty(0,1);
                    for idx = 1:numel(p)
                        nObj = get(p(idx).getLastPathComponent(),'TreeNode');
                        if isvalid(nObj)
                            if e.isAddedPath(idx-1) %zero-based index
                                AddedNodes(end+1) = nObj; %#ok<AGROW>
                            else
                                RemovedNodes(end+1) = nObj; %#ok<AGROW>
                            end
                        end
                    end
                    
                else
                    selNodes = [e.SelectedNodes.NodeData];
                    prevNodes = [e.PreviousSelectedNodes.NodeData];
                    AddedNodes = setdiff(selNodes,prevNodes);
                    RemovedNodes = setdiff(prevNodes,selNodes);
                end
                
                % Prepare eventdata for the callback
                e1 = struct(...
                    'Nodes', obj.SelectedNodes,...
                    'AddedNodes',AddedNodes,...
                    'RemovedNodes',RemovedNodes);
                
                % Call the treeCallback
                hgfeval(obj.SelectionChangeFcn,obj,e1);
            end
            
        end %function onNodeSelection
        
        
        function onNodeEdit(obj,e)
            % Triggered when a node is edited
            
            % Is there a custom NodeEditedCallback?
            if obj.isvalid() && obj.CallbacksEnabled && ~isempty(obj.NodeEditedCallback)
                
                if obj.FigureIsJava
                    
                    % Get the tree nodes that were edited
                    c = e.getChildren;
                    EditedNode = uiw.widget.TreeNode.empty(0,1);
                    for idx = 1:numel(c)
                        EditedNode = get(c(idx),'TreeNode');
                    end
                    
                    % Get the parent node of the edit
                    ParentNode = get(e.getTreePath.getLastPathComponent,'TreeNode');
                    
                    
                    EditedNode.Name = EditedNode.JNode.getUserObject();
                    
                else
                    
                    EditedNode = e.Node.NodeData;
                    ParentNode = EditedNode.Parent;
                    EditedNode.Name = e.Text;
                    
                end
                
                
                % Call the custom callback
                e1 = struct(...
                    'Nodes',EditedNode,...
                    'ParentNode',ParentNode);
                hgfeval(obj.NodeEditedCallback,obj,e1);
                
            end %if ~isempty(obj.NodeEditedCallback)
            
        end %function onNodeEdit
        
        
        function onNodeDND(obj,e)
            % Triggered when a node is dragged or dropped on the tree
            
            % The Transferable object is available only during drag
            persistent Transferable
            
            if obj.isvalid() && obj.CallbacksEnabled
                
                try %#ok<TRYNC>
                    % The Transferable object is available only during drag
                    Transferable = e.getTransferable;
                    javaObjectEDT(Transferable); % Put it on the EDT
                end
                
                % Catch errors if unsupported items are dragged onto the
                % tree
                try
                    DataFlavors = Transferable.getTransferDataFlavors;
                    TransferData = Transferable.getTransferData(DataFlavors(1));
                catch %#ok<CTCH>
                    TransferData = [];
                end
                
                % Get the source node(s)
                SourceNode = uiw.widget.TreeNode.empty(0,1);
                for idx = 1:numel(TransferData)
                    SourceNode(idx) = get(TransferData(idx),'TreeNode');
                end
                
                % Filter descendant source nodes. If dragged nodes are
                % descendants of other dragged nodes, they should be
                % excluded so the hierarchy is maintained.
                idxRemove = isDescendant(SourceNode,SourceNode);
                SourceNode(idxRemove) = [];
                
                % Get the target node
                Loc = e.getLocation();
                treePath = obj.JControl.getPathForLocation(...
                    Loc.getX + obj.JScrollPane.getHorizontalScrollBar().getValue(), Loc.getY + obj.JScrollPane.getVerticalScrollBar().getValue());
                if isempty(treePath)
                    % If no target node, the target is the background of
                    % the tree. Assume the root is the intended target.
                    TargetNode = obj.Root;
                else
                    TargetNode = get(treePath.getLastPathComponent,'TreeNode');
                end
                
                % Get the operation type
                switch e.getDropAction()
                    case 0
                        DropAction = 'link';
                    case 1
                        DropAction = 'copy';
                    case 2
                        DropAction = 'move';
                    otherwise
                        DropAction = '';
                end
                
                % Create event data for user callback
                e1 = struct(...
                    'Source',SourceNode,...
                    'Target',TargetNode,...
                    'DropAction',DropAction);
                % Check if the source/target are valid
                % Check the node is not dropped onto itself
                % Check a node may not be dropped onto a descendant
                TargetOk = ~isempty(TargetNode) &&...
                    ~isempty(SourceNode) && ...
                    ~any(SourceNode==TargetNode) && ...
                    ~any(isDescendant(SourceNode,TargetNode));
                
                % A move operation may not drop a node onto its parent
                if TargetOk && strcmp(DropAction,'move')
                    TargetOk = ~any([SourceNode.Parent]==TargetNode);
                end
                
                % Is this the drag or the drop event?
                if e.isa('java.awt.dnd.DropTargetDragEvent')
                    %%%%%%%%%%%%%%%%%%%
                    % Drag Event
                    %%%%%%%%%%%%%%%%%%%
                    
                    % Is there a custom NodeDraggedCallback to call?
                    if TargetOk && ~isempty(obj.NodeDraggedCallback)
                        TargetOk = hgfeval(obj.NodeDraggedCallback,obj,e1);
                    end
                    
                    % Is this a valid target?
                    if TargetOk
                        e.acceptDrag(e.getDropAction);
                    else
                        e.rejectDrag();
                    end
                    
                elseif e.isa('java.awt.dnd.DropTargetDropEvent')
                    %%%%%%%%%%%%%%%%%%%
                    % Drop Event
                    %%%%%%%%%%%%%%%%%%%
                    
                    % Is there a custom NodeDraggedCallback to call?
                    if TargetOk && ~isempty(obj.NodeDraggedCallback)
                        TargetOk = hgfeval(obj.NodeDraggedCallback,obj,e1);
                    end
                    
                    % Should we process the drop?
                    if TargetOk
                        
                        % Is there a custom NodeDroppedCallback to call?
                        if ~isempty(obj.NodeDroppedCallback)
                            hgfeval(obj.NodeDroppedCallback,obj,e1);
                        else
                            % Just move the node to the new destination, and expand
                            switch DropAction
                                case 'copy'
                                    NewSourceNode = copy(SourceNode,TargetNode);
                                    expand(TargetNode)
                                    expand(SourceNode)
                                    expand(NewSourceNode)
                                case 'move'
                                    set(SourceNode,'Parent',TargetNode)
                                    expand(TargetNode)
                                    expand(SourceNode)
                                otherwise
                                    % Do nothing
                            end
                        end
                        
                    end
                    
                    % Tell Java the drop is complete
                    e.dropComplete(true)
                    
                end
                
            end %if obj.isvalid() && obj.CallbacksEnabled
            
        end %function onNodeDND
        
    end %methods
    
    
    %% Get/Set methods
    methods
        
        % DndEnabled
        function value = get.DndEnabled(obj)
            if obj.IsConstructed && obj.FigureIsJava
                value = obj.JControl.getDragEnabled();
            else
                value = obj.DndEnabled;
            end
        end
        function set.DndEnabled(obj,value)
            if ischar(value) || ( isscalar(value) && isstring(value) )
                value = strcmp(value,'on');
            end
            validateattributes(value,{'numeric','logical'},{'scalar'});
            obj.DndEnabled = logical(value);
            if ~obj.IsConstructed
                % Do nothing
            elseif obj.FigureIsJava
                obj.JControl.setDragEnabled(value);
            else
                obj.throwDeprecatedWarning('DndEnabled');
            end
        end
        
        
        % Editable
        function set.Editable(obj,value)
            validateattributes(value,{'numeric','logical'},{'scalar'});
            obj.Editable = logical(value);
            if ~obj.IsConstructed
                % Do nothing
            elseif obj.FigureIsJava
                obj.JControl.setEditable(obj.Editable);
            else
                obj.WebControl.Editable = obj.Editable;
            end
        end
        
        
        % Root
        function value = get.Root(obj)
            if obj.IsConstructed && ~obj.FigureIsJava
                value = obj;
            else
                value = obj.Root;
            end
        end
        
        
        % RootVisible
        function value = get.RootVisible(obj)
            if obj.IsConstructed && obj.FigureIsJava
                value = get(obj.JControl,'rootVisible');
            else
                value = obj.RootVisible;
            end
        end
        function set.RootVisible(obj,value)
            if ischar(value) || ( isscalar(value) && isstring(value) )
                value = strcmp(value,'on');
            end
            validateattributes(value,{'numeric','logical'},{'scalar'});
            obj.RootVisible = logical(value);
            if ~obj.IsConstructed
                % Do nothing
            elseif obj.FigureIsJava
                obj.JControl.setRootVisible(value); %show/hide root
                obj.JControl.setShowsRootHandles(~value); %hide/show top level handles
            else
                obj.throwDeprecatedWarning('RootVisible');
            end
        end
        
        
        % SelectedNodes
        function value = get.SelectedNodes(obj)
            
            if ~obj.IsConstructed
                
                value = obj.SelectedNodes;
                
            elseif obj.FigureIsJava
                
                value = uiw.widget.TreeNode.empty(0,1);
                srcPaths = obj.JControl.getSelectionPaths();
                for idx = 1:numel(srcPaths)
                    value(idx) = get(srcPaths(idx).getLastPathComponent,'TreeNode');
                end
            else
                
                if isempty(obj.WebControl.SelectedNodes)
                    value = uiw.widget.TreeNode.empty(0,1);
                else
                    value = [obj.WebControl.SelectedNodes.NodeData];
                end
                
            end
            
        end
        
        function set.SelectedNodes(obj,value)
            
            if ~obj.IsConstructed
                
                obj.SelectedNodes = value;
                 
            elseif obj.FigureIsJava
                
                obj.CallbacksEnabled = false;
                
                if isempty(value)
                    
                    if ~isempty(obj.JControl.getSelectionPath)
                        obj.JControl.setSelectionPath([])
                    end
                    
                elseif isa(value,'uiw.widget.TreeNode')
                    
                    if isscalar(value)
                        obj.JControl.setSelectionPath(value.JNode.getTreePath());
                    else
                        for idx = numel(value):-1:1 %preallocate by reversing
                            path(idx) = value(idx).JNode.getTreePath();
                        end
                        obj.JControl.setSelectionPaths(path);
                    end
                    
                else
                    
                    error('Expected TreeNode or empty array');
                    
                end
                
                obj.CallbacksEnabled = true;
                
            else
                
                obj.WebControl.SelectedNodes = [value.WNode];
                
            end
            
        end
        
        % SelectionType
        function value = get.SelectionType(obj)
            if obj.IsConstructed && obj.FigureIsJava
                value = obj.JSelModel.getSelectionMode();
                switch value
                    case 1
                        value = 'single';
                    case 2
                        value = 'contiguous';
                    case 4
                        value = 'discontiguous';
                end
            else
                value = obj.SelectionType;
            end
        end
        function set.SelectionType(obj,value)
            obj.SelectionType = validatestring(value,{'single','contiguous','discontiguous'});
            if obj.IsConstructed && obj.FigureIsJava
                switch obj.SelectionType
                    case 'single'
                        mode = obj.JSelModel.SINGLE_TREE_SELECTION; %#ok<MCSUP>
                    case 'contiguous'
                        mode = obj.JSelModel.CONTIGUOUS_TREE_SELECTION; %#ok<MCSUP>
                    case 'discontiguous'
                        mode = obj.JSelModel.DISCONTIGUOUS_TREE_SELECTION; %#ok<MCSUP>
                end
                obj.CallbacksEnabled = false;
                obj.JSelModel.setSelectionMode(mode); %#ok<MCSUP>
                obj.CallbacksEnabled = true;
            else
                if strcmpi(obj.SelectionType,'contiguous')
                    obj.throwDeprecatedWarning('SelectionType','contiguous');
                end
                if obj.IsConstructed && ~obj.FigureIsJava
                    isMultiSelect = ~strcmpi(obj.SelectionType,'single');
                    obj.WebControl.Multiselect = isMultiSelect;
                end
            end
        end
        
        
        % SelectionForegroundColor
        function set.SelectionForegroundColor(obj, value)
            value = uiw.utility.interpretColor(value);
            evt = struct(...
                'Source',obj,...
                'Property','SelectionForegroundColor',...
                'OldValue',obj.SelectionForegroundColor,...
                'NewValue',value);
            obj.SelectionForegroundColor = value;
            if obj.IsConstructed && obj.FigureIsJava
                obj.onStyleChanged(evt);
            elseif obj.IsConstructed && ~obj.FigureIsJava
                obj.throwDeprecatedWarning('SelectionForegroundColor');
            end
        end
        
        % SelectionBackgroundColor
        function set.SelectionBackgroundColor(obj, value)
            value = uiw.utility.interpretColor(value);
            evt = struct(...
                'Source',obj,...
                'Property','SelectionBackgroundColor',...
                'OldValue',obj.SelectionBackgroundColor,...
                'NewValue',value);
            obj.SelectionBackgroundColor = value;
            if obj.IsConstructed && obj.FigureIsJava
                obj.onStyleChanged(evt);
            elseif obj.IsConstructed && ~obj.FigureIsJava
                obj.throwDeprecatedWarning('SelectionBackgroundColor');
            end
        end
        
        % TreeBackgroundColor
        function set.TreeBackgroundColor(obj, value)
            value = uiw.utility.interpretColor(value);
            evt = struct(...
                'Source',obj,...
                'Property','TreeBackgroundColor',...
                'OldValue',obj.TreeBackgroundColor,...
                'NewValue',value);
            obj.TreeBackgroundColor = value;
            obj.onStyleChanged(evt);
        end
        
        % TreePaneBackgroundColor
        function set.TreePaneBackgroundColor(obj, value)
            value = uiw.utility.interpretColor(value);
            evt = struct(...
                'Source',obj,...
                'Property','TreeBackgroundColor',...
                'OldValue',obj.TreePaneBackgroundColor,...
                'NewValue',value);
            obj.TreePaneBackgroundColor = value;
            if obj.IsConstructed && obj.FigureIsJava
                obj.onStyleChanged(evt);
            elseif obj.IsConstructed && ~obj.FigureIsJava
                obj.throwDeprecatedWarning('TreePaneBackgroundColor');
            end
        end
        
        
        function set.KeyPressedCallback(obj, value)
            obj.KeyPressedCallback = value;
            if obj.IsConstructed && ~obj.FigureIsJava
                obj.throwDeprecatedWarning('KeyPressedCallback');
            end
        end
        
        function set.MouseClickedCallback(obj, value)
            obj.MouseClickedCallback = value;
            if obj.IsConstructed && ~obj.FigureIsJava
                obj.throwDeprecatedWarning('MouseClickedCallback');
            end
        end
        
        function set.MouseMotionFcn(obj, value)
            obj.MouseMotionFcn = value;
            if obj.IsConstructed && ~obj.FigureIsJava
                obj.throwDeprecatedWarning('MouseMotionFcn');
            end
        end
        function set.NodeDraggedCallback(obj, value)
            obj.NodeDraggedCallback = value;
            if obj.IsConstructed && ~obj.FigureIsJava
                obj.throwDeprecatedWarning('NodeDraggedCallback');
            end
        end
        function set.NodeDroppedCallback(obj, value)
            obj.NodeDroppedCallback = value;
            if obj.IsConstructed && ~obj.FigureIsJava
                obj.throwDeprecatedWarning('NodeDroppedCallback');
            end
        end
        
    end %get/set methods
    
end %classdef
