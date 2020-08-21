classdef TreeNode < uiw.mixin.AssignPVPairs & matlab.mixin.Heterogeneous
    % TreeNode - Node for a tree control
    %
    % Create a tree node object to be placed on a uiw.widget.Tree control.
    %
    % Syntax:
    %   obj = uiw.widget.TreeNode
    %   obj = uiw.widget.TreeNode('Property','Value',...)
    %
    
%   Copyright 2012-2019 The MathWorks Inc.
    %
    % Auth/Revision:
    %   MathWorks Consulting
    %   $Author: rjackey $
    %   $Revision: 324 $  $Date: 2019-04-23 08:05:17 -0400 (Tue, 23 Apr 2019) $
    % ---------------------------------------------------------------------
    %#ok<*MCSUP>
    
    %% Properties
    properties (AbortSet)
        Name char %Name to display on the tree node
        TooltipString char %Tooltip text on mouse hover
        Parent = uiw.widget.TreeNode.empty(0,1) %Parent tree node
        UIContextMenu %context menu to show when clicking on this node
        UserData %User data to store in the tree node
    end
    
    properties (Hidden, AbortSet)
        Value %User value to store in the tree node (deprecated)
    end
    
    properties (AbortSet, SetAccess={?uiw.widget.Tree, ?uiw.widget.TreeNode})
        Children = uiw.widget.TreeNode.empty(0,1) %Child tree nodes (read-only)
        Tree = uiw.widget.Tree.empty(0,1) %Tree on which this node is attached (read-only)
    end
    
    
    %% Internal properties
    
    % The node needs to be accessible by the tree and nodes
    properties (SetAccess={?uiw.widget.Tree, ?uiw.widget.TreeNode},...
            GetAccess={?uiw.widget.Tree, ?uiw.widget.TreeNode})
        IsBeingDeleted = false; %true when the destructor is active (internal)
        IsConstructed (1,1) logical = false;
        JNode %Java object for tree node
        WNode %Web object for tree node
    end
    
    
    %% Constructor / Destructor
    methods
        
        function obj = TreeNode(varargin)
            
            % Set properties from P-V pairs
            obj.assignPVPairs(varargin{:});
            
        end % constructor
        
        
        function delete(obj)
            obj.IsBeingDeleted = true;
            delete(obj.Children(isvalid(obj.Children)))
            if ~isempty(obj.Parent) && isvalid(obj.Parent) && ~obj.Parent.IsBeingDeleted
                obj.Parent(:) = [];
            end
            try %#ok<TRYNC>
                delete(obj.JNode);
            end
        end % destructor
        
    end %methods - constructor/destructor
    
    
    
    
    %% Protected Methods
    methods (Access={?uiw.widget.Tree, ?uiw.widget.TreeNode})
        
        function createComponent(obj)
            % Create the internal node model
            
            if ~isempty(obj.Tree) && isvalid(obj.Tree) && obj.Tree.IsConstructed
                
                if obj.Tree.FigureIsJava && isempty(obj.JNode)
                    
                    warnState = warning('off','MATLAB:ui:javacomponent:FunctionToBeRemoved');
                    obj.createJavaComponent()
                    warning(warnState);
                    
                elseif ~obj.Tree.FigureIsJava && isempty(obj.WNode)
                    
                    obj.createWebControl();
                    
                end
                
                obj.IsConstructed = true;
                
            end %if
            
        end %function
        
        
        function createJavaComponent(obj)
            % Create the graphics objects
            
            % Create a tree node for this element
            obj.JNode = javaObjectEDT(...
                'com.mathworks.consulting.widgets.tree.TreeNode', obj.Name);
            
            % Add a reference to this object. This is used in Java
            % callbacks to MATLAB that need to know what node was touched.
            obj.JNode = handle(obj.JNode);
            schema.prop(obj.JNode,'TreeNode','MATLAB array');
            obj.JNode.TreeNode = obj;
            
        end %function
        
        
        function createWebControl(obj)
            % Create the graphics objects
            
            obj.WNode = uitreenode(...
                'Parent',[],...
                'Text',obj.Name,...
                'ContextMenu',obj.UIContextMenu,...
                'NodeData',obj);
            
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
        
    end %methods
    
            
    
    %% Public Methods
    methods
        
        function nObjCopy = copy(obj,NewParent)
            % copy - Copy a TreeNode object
            %
            % Abstract: Copy a TreeNode object, including any children
            %
            % Syntax:
            %           obj.copy()
            %           obj.copy(NewParent)
            %
            % Inputs:
            %           obj - TreeNode object to copy
            %           NewParent - new parent TreeNode object
            %
            % Outputs:
            %           nObjCopy - copy of TreeNode object
            %
            for idx = 1:numel(obj)
                
                % Allow subclasses to instantiate copies of the same type
                fNodeConstructor = str2func(class(obj(idx)));
                
                % Create a new node, and copy properties
                nObjCopy(idx) = fNodeConstructor(...
                    'Name',obj(idx).Name,...
                    'Value',obj(idx).Value,...
                    'TooltipString',obj(idx).TooltipString,...
                    'UserData',obj(idx).UserData,...
                    'UIContextMenu',obj(idx).UIContextMenu); %#ok<AGROW>
                
                % Copy the icon's java object
                jIcon = getIcon(obj(idx).JNode);
                setIcon(nObjCopy(idx).JNode,jIcon);
                
                % Set the parent, if specified
                if nargin>1
                    set(nObjCopy(idx),'Parent',NewParent);
                end
                
                % Recursively copy children and assign new parent
                % Need to loop in case children are of heterogeneous type
                ChildNodes = obj(idx).Children;
                for cIdx = 1:numel(ChildNodes)
                    copy(ChildNodes(cIdx), nObjCopy(idx));
                end
            end
        end %function
        
        
        function collapse(obj)
            % collapse - Collapse a TreeNode within a tree
            %
            % Abstract: Collapses the TreeNode
            %
            % Syntax:
            %           obj.collapse()
            %
            % Inputs:
            %           obj - TreeNode object
            %
            % Outputs:
            %           none
            %
            for idx = 1:numel(obj)
                if ~isempty(obj(idx).Tree)
                    collapseNode(obj(idx).Tree, obj(idx));
                end
            end
        end %function collapse()
        
        
        function expand(obj)
            % expand - Expands a TreeNode within a tree
            %
            % Abstract: Expands the TreeNode
            %
            % Syntax:
            %           obj.expand()
            %
            % Inputs:
            %           obj - TreeNode object
            %
            % Outputs:
            %           none
            %
            for idx = 1:numel(obj)
                if ~isempty(obj(idx).Tree)
                    expandNode(obj(idx).Tree, obj(idx));
                end
            end
        end %function expand()
        
        
        function tf = isAncestor(nObj1,nObj2)
            % isAncestor - checks if another node is an ancestor
            %
            % Abstract: checks if node2 is an ancestor of node 1
            %
            % Syntax:
            %           tf = nObj1.isAncestor(nObj2)
            %
            % Inputs:
            %           nObj1 - TreeNode object
            %           nObj2 - TreeNode object
            %
            % Outputs:
            %           tf - logical result
            %
            validateattributes(nObj1,{'uiw.widget.TreeNode'},{'vector'})
            validateattributes(nObj2,{'uiw.widget.TreeNode'},{'vector'})
            
            tf = false(size(nObj1));
            for idx = 1:numel(nObj1)
                while ~tf(idx) && ~isempty(nObj1(idx).Parent)
                    tf(idx) = any(nObj1(idx).Parent == nObj2);
                    nObj1(idx) = nObj1(idx).Parent;
                end
            end
            
        end %function isAncestor()
        
        
        function tf = isDescendant(nObj1,nObj2)
            % isDescendant - checks if another node is a descendant
            %
            % Abstract: checks if another node is a descendant of this one
            %
            % Syntax:
            %           tf = nObj1.isDescendant(nObj2)
            %
            % Inputs:
            %           nObj1 - TreeNode object
            %           nObj2 - TreeNode object
            %
            % Outputs:
            %           tf - logical result
            %
            
            tf = isAncestor(nObj2,nObj1);
            
        end %function isDescendant()
        
        
        function setIcon(obj,icon)
            % setIcon - Set icon of TreeNode
            %
            % Abstract: Changes the icon displayed on a TreeNode
            %
            % Syntax:
            %           obj.setIcon(IconFilePath)
            %
            % Inputs:
            %           obj - TreeNode object
            %           icon - path to the icon file (16x16 px)
            %
            % Outputs:
            %           none
            %
            % Examples:
            %   t = uiw.widget.Tree;
            %   n = uiw.widget.TreeNode('Name','Node1','Parent',t);
            %   setIcon(n,which('matlabicon.gif'));
            
            validateattributes(icon,{'char'},{})
            
            if ~obj.IsConstructed || isempty(obj.Tree)
                
                % Do nothing
                
            elseif obj.Tree.FigureIsJava
                
                % Create a java icon
                IconData = javaObjectEDT('javax.swing.ImageIcon',icon);
                
                % Update the icon in the node
                setIcon(obj.JNode, IconData);
                
                % Notify the model about the update
                nodeChangedJava(obj.Tree, obj)
                
            else
                
                obj.WNode.Icon = icon;
                
            end
            
        end %function setIcon()
        
        
        function s = getJavaObjects(obj)
            % getJavaObjects - Returns underlying java objects
            %
            % Abstract: (For debugging use only) Returns the underlying
            % Java objects.
            %
            % Syntax:
            %           s = getJavaObjects(obj)
            %
            % Inputs:
            %           obj - TreeNode object
            %
            % Outputs:
            %           s - struct of Java objects
            %
            
            s = struct('JNode',obj.JNode);
            
        end %function
        
    end %public methods
    
    
    
    %% Special Access Methods
    methods (Access={?uiw.widget.Tree, ?uiw.widget.TreeNode})
        
        function newParent = updateParent(obj,newParent)
            % Handle updating the parent of the specified node
            
            % What action was taken?
            if obj.IsBeingDeleted %Node is being deleted
                
                newParent = [];
                
                % Remove parent references to this child, if parent is not
                % being deleted
                if ~isempty(obj.Parent) && ~obj.Parent.IsBeingDeleted
                    ChildIdx = find(obj.Parent.Children == obj,1);
                    obj.Parent.Children(ChildIdx) = [];
                    if ~isempty(obj.Tree) && isvalid(obj.Tree) ...
                            && obj.Tree.FigureIsJava
                        obj.Tree.removeNodeJava(obj, obj.Parent);
                    end
                end
                
                
            elseif isempty(newParent) %New parent is empty
                
                % Always make the parent an empty TreeNode, in case empty
                % [] was passed in
                newParent = uiw.widget.TreeNode.empty(0,1);
                
                % Is there an old parent to clean up?
                if ~isempty(obj.Parent)
                    ChildIdx = find(obj.Parent.Children == obj,1);
                    obj.Parent.Children(ChildIdx) = [];
                    obj.Tree.removeNodeJava(obj, obj.Parent);
                    
                    % Update the reference to the tree in the hierarchy
                    updateTreeReference(obj, newParent)
                end
                
            else % A new parent was provided
                
                % Get the tree for the parent
                if isa(newParent,'uiw.widget.Tree')
                    newTree = newParent;
                else
                    newTree = newParent.Tree;
                end 
                
                % If new parent is a JTree, parent is the Root
                if isa(newParent,'uiw.widget.Tree') && newParent.FigureIsJava
                    newParent = newParent.Root;
                end
                
                % Is there an old parent to clean up?
                if ~isempty(obj.Parent)
                    ChildIdx = find(obj.Parent.Children == obj,1);
                    obj.Parent.Children(ChildIdx) = [];
                    obj.Tree.removeNodeJava(obj, obj.Parent);
                end
                
                % Update the reference to the tree in the hierarchy
                if ~isequal(obj.Tree, newTree)
                    updateTreeReference(obj, newTree)
                end
                
                % Update the list of children in the parent
                if isa(newParent,'uiw.widget.Tree')
                    ChildIdx = numel(newParent.ChildNodes) + 1;
                else
                    ChildIdx = numel(newParent.Children) + 1;
                    newParent.Children(ChildIdx) = obj;
                end
                
                % Add this node to the parent node
                if ~isempty(obj.Tree) && isvalid(obj.Tree)
                    obj.Tree.insertNode(obj, newParent, ChildIdx);
                end
                
            end %if isempty(newParent)
            
            % This internal function updates the tree reference in the
            % hierarchy
            function updateTreeReference(obj,Tree)
                for idx=1:numel(obj)
                    obj(idx).Tree = Tree;
                    if ~isempty(obj(idx).Children)
                        updateTreeReference(obj(idx).Children, Tree);
                    end
                end
            end
            
        end %function updateParent()
        
    end %special access methods
    
    
    
    %% Get/Set methods
    methods
        
        % Name
        function set.Name(obj,value)
            obj.Name = value;
            if ~isempty(obj.WNode)
                obj.WNode.Text = value;
            elseif ~isempty(obj.JNode)
                obj.JNode.setUserObject(value);
                nodeChangedJava(obj.Tree,obj);
            end
        end
        
        % TooltipString
        function set.TooltipString(obj,value)
            obj.TooltipString = value;
            if ~isempty(obj.WNode)
                obj.throwDeprecatedWarning('TooltipString');
            elseif ~isempty(obj.JNode)
                obj.JNode.setTooltipString(java.lang.String(value));
            end
        end
        
        % Parent
        function set.Parent(obj,newParent)
            % Update the parent/child relationship
            if obj.IsBeingDeleted
                updateParent(obj,newParent);
            else
                newParent = updateParent(obj,newParent);
                % Set the parent value
                obj.Parent = newParent;
            end
        end
        
        % UIContextMenu
        function set.UIContextMenu(obj,value)
            obj.UIContextMenu = value;
            if ~isempty(obj.WNode)
                obj.WNode.ContextMenu = value;
            end
        end
        
        % Tree
        function set.Tree(obj,value)
            obj.Tree = value;
            obj.createComponent();
        end
        
    end %get/set methods
    
end %classdef
