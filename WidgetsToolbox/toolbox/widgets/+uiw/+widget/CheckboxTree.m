classdef CheckboxTree < uiw.widget.Tree
    % CheckboxTree - A rich tree control with checkboxes for each node
    %
    % Create a rich tree widget based on Java JTree, supporting checkbox nodes
    %
    % Syntax:
    %           obj = uiw.widget.CheckboxTree
    %           obj = uiw.widget.CheckboxTree('Property','Value',...)
    %
    
%   Copyright 2012-2020 The MathWorks Inc.
    %
    % 
    %   
    %   
    %   
    % ---------------------------------------------------------------------
    
    
    %% Properties
    properties
        
        % Callback when a checkbox value is changed
        CheckboxClickedCallback 
        
    end
    
    properties (Dependent)
        
        % Clicking on label toggles checkbox (true|false)
        ClickInCheckBoxOnly (1,1) logical = true 
        
        % Selection of a branch also checks all children (true|false)
        DigIn (1,1) logical = true  
        
    end
    
    properties (Dependent, SetAccess=immutable)
        
        % Tree nodes that are currently checked. In DigIn mode, this will not contain the children of fully selected branches. (read-only)
        CheckedNodes 
        
    end
    
    
    %% Internal properties
    properties (SetAccess=protected, GetAccess=protected)
        
        % Java checkbox selection model (internal)
        JCBoxSelModel %Java checkbox selection model (internal)
        
    end
    
    
    
    %% Constructor / Destructor
    methods
        
        function obj = CheckboxTree(varargin)
            % Construct the control
            
            % Call superclass constructor
            obj = obj@uiw.widget.Tree(varargin{:});
            
        end % constructor
        
    end %methods - constructor/destructor
    
    
    
    %% Public Methods
    methods
        
        function s = getJavaObjects(obj)
            % Return the Java objects of the tree (for debugging only)
            
            s = getJavaObjects@uiw.widget.Tree(obj);
            s.JCBoxSelModel = obj.JCBoxSelModel;
            
        end
        
    end %public methods
    
    
    
    %% Protected Methods
    methods (Access=protected)
        
        function createWebControl(~)
            % Create the graphics objects
            
            error('widgets:Java:DeprecatedCheckboxTree',...
                'CheckboxTree not supported with figures created with the uifigure function');
            
        end %function
        
        
        function createJavaComponent(obj)
            % Override the createJavaComponent method to make a checkbox tree
            
            % Create the root node
            obj.Root = uiw.widget.CheckboxTreeNode('Name','Root');
            
            % Create the tree on a scroll pane (unless subclass already
            % did)
            % Attach root
            obj.Root.createJavaComponent();
            obj.Root.Tree = obj;
            obj.createScrollPaneJControl(...
                'com.mathworks.consulting.widgets.tree.CheckBoxTree',obj.Root.JNode);
            
            % Call superclass create method to finish up
            obj.createJavaComponent@uiw.widget.Tree();
            
            % Store the checkbox selection model
            obj.JCBoxSelModel = obj.JControl.getCheckBoxTreeSelectionModel();
            %obj.JCBoxSelModel.setSingleEventMode(1);
            javaObjectEDT(obj.JCBoxSelModel);
            
            % Configure the tree
            obj.JControl.setDigIn(logical(obj.DigIn));
            obj.JControl.setClickInCheckBoxOnly(logical(obj.ClickInCheckBoxOnly));
            
            % Set the callbacks
            CbProps = handle(obj.JCBoxSelModel,'CallbackProperties'); 
            set(CbProps,'ValueChangedCallback',@(src,e)onCheckboxClicked(obj,e));
            
        end
        
        
        function onStyleChanged(obj,~)
            % Handle updates to style changes
            
            % Ensure the construction is complete
            if obj.IsConstructed
                
                % Adjust font in cell renderer
                r = obj.JControl.getCellRenderer();
                r.setFont(obj.getJFont());

                % Call superclass methods
                onStyleChanged@uiw.widget.Tree(obj);
                
            end %if obj.IsConstructed
        end %function
        
        
        function onCheckboxClicked(obj,e)
            % Triggered on checkbox click
            
            if obj.isvalid() && obj.CallbacksEnabled
                
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                % Prepare event data for user callback
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                
                % In non DigIn mode, provide the node that was changed. In
                % DigIn mode, the java event is difficult to use because we
                % get multiple events in some cases. (Single event mode did
                % not work correctly.)  The events may come in the wrong
                % order, giving wrong information. So instead, we just
                % provide the selection paths.
                if obj.DigIn
                    
                    % Filter out clicks that trigger two events by checking
                    % for changes in the selection path. Note equals is
                    % defined as long as jOldSelPath is nonempty.
                    jNewSelPath = e.getNewLeadSelectionPath();
                    jOldSelPath = e.getOldLeadSelectionPath();
                    if ~isempty(jOldSelPath) && equals(jOldSelPath,jNewSelPath)
                        return
                    end
                    
                    % Prepare the event data
                    e1 = struct('SelectionPaths',obj.CheckedNodes);
                    
                else %not DigIn mode
                    
                    % Figure out what paths were added or removed by eventdata
                    jChangedPath = e.getPath;
                    jPath = jChangedPath.getLastPathComponent();
                    ChangedPath = get(jPath,'TreeNode');
                    
                    % Prepare the event data
                    e1 = struct(...
                        'Nodes',ChangedPath,...
                        'SelectionPaths',obj.CheckedNodes);
                    
                end %if obj.DigIn
                
                % Is there a custom CheckboxClickedCallback?
                if ~isempty(obj.CheckboxClickedCallback)
                    
                    % Call the custom callback
                    hgfeval(obj.CheckboxClickedCallback,obj,e1);
                    
                end %if ~isempty(obj.CheckboxClickedCallback)
                
            end %if obj.isvalid() && obj.CallbacksEnabled
            
        end
        
    end %protected methods
    
    
    
    %% Special Access Methods
    methods (Access={?uiw.widget.Tree, ?uiw.widget.TreeNode})
        
        function tf = isNodeChecked(obj,nObj)
            % Return whether a node is checked
            jTreePath = nObj.JNode.getTreePath;
            if nObj.Tree == obj
                tf = obj.JCBoxSelModel.isPathSelected(jTreePath,obj.DigIn);
            else
                tf = NaN;
            end
        end
        
        function tf = isNodePartiallyChecked(obj,nObj)
            % Return whether a node is partially checked
            jTreePath = nObj.JNode.getTreePath;
            if nObj.Tree == obj
                tf = obj.JCBoxSelModel.isPartiallySelected(jTreePath);
            else
                tf = NaN;
            end
        end
        
        function setChecked(obj,nObj,value)
            % Set whether a node is checked
            validateattributes(nObj,{'uiw.widget.TreeNode'},{'vector'});
            validateattributes(value,{'numeric','logical'},{'vector'});
            if isequal(size(value),size(nObj))
                value = logical(value);
            elseif numel(value)==1
                value = repmat(logical(value),size(nObj));
            else
                error('CheckboxTree:setChecked:inputs',...
                    'Size of value must match size of input nodes to be set.');
            end
            RemNodes = nObj(~value);
            AddNodes = nObj(value);
            if ~isempty(RemNodes)
                for idx = numel(RemNodes):-1:1 %backwards to preallocate
                    RemPaths(idx) = RemNodes(idx).JNode.getTreePath();
                end
                obj.JCBoxSelModel.removeSelectionPaths(RemPaths);
            end
            if ~isempty(AddNodes)
                for idx = numel(AddNodes):-1:1 %backwards to preallocate
                    AddPaths(idx) = AddNodes(idx).JNode.getTreePath();
                end
                obj.JCBoxSelModel.addSelectionPaths(AddPaths);
            end
        end
        
    end %special access methods
    
    
    
    %% Get/Set methods
    methods
        
        % ClickInCheckBoxOnly
        function value = get.ClickInCheckBoxOnly(obj)
            value = get(obj.JControl,'ClickInCheckBoxOnly');
        end
        function set.ClickInCheckBoxOnly(obj,value)
            validateattributes(value,{'numeric','logical'},{'scalar'});
            if obj.IsConstructed && obj.FigureIsJava
                obj.JControl.setClickInCheckBoxOnly(logical(value));
            end
        end
        
        % DigIn
        function value = get.DigIn(obj)
            value = get(obj.JControl,'DigIn');
        end
        function set.DigIn(obj,value)
            validateattributes(value,{'numeric','logical'},{'scalar'});
            if obj.IsConstructed && obj.FigureIsJava
                obj.JControl.setDigIn(logical(value));
            end
        end
        
        % CheckedNodes
        function value = get.CheckedNodes(obj)
            value = uiw.widget.TreeNode.empty(0,1);
            if obj.IsConstructed && obj.FigureIsJava
                p = obj.JCBoxSelModel.getSelectionPaths;
                for idx = 1:numel(p)
                    nObj = get(p(idx).getLastPathComponent(),'TreeNode');
                    value(end+1) = nObj; %#ok<AGROW>
                end
            end
        end
        
    end %get/set methods
    
    
end %classdef
