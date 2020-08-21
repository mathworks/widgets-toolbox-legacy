%% Tree
%%
% 
%   Copyright 2012-2019 The MathWorks Inc.
%
%% Create the widget

f = uifigure(...
    'Toolbar','none',...
    'MenuBar','none',...
    'NumberTitle','off',...
    'Units','pixels',...
    'Position',[100 100 220 320]);
movegui(f,[100 -100])
drawnow

w = uiw.widget.Tree(...
    'Parent',f,...
    'SelectionChangeFcn',@(h,e)disp(e),...
    'Label','Tree:', ...
    'LabelLocation','top',...
    'LabelHeight',18,...
    'Units', 'normalized', ...
    'Position', [0 0 1 1]);

topNode =  uiw.widget.TreeNode('Name','TopNode','Parent',w.Root);
branchA = uiw.widget.TreeNode('Name','BranchA','Parent',w.Root);
branchB = uiw.widget.TreeNode('Name','BranchB','Parent',w.Root);

for idx = 1:5
    nodesA(idx) = uiw.widget.TreeNode('Name',sprintf('NodeA %d',idx),'Parent',branchA); %#ok<SAGROW>
    nodesB(idx) = uiw.widget.TreeNode('Name',sprintf('NodeB %d',idx),'Parent',branchB); %#ok<SAGROW>
end


%% Expand branches
branchA.expand();
branchB.expand();


%% Change selection mode
w.SelectionType = 'discontiguous';
w.SelectionChangeFcn = @(h,e)disp({h.SelectedNodes.Name}');


%% Select nodes programmatically
w.SelectedNodes = [nodesA(2) nodesB(4)];


%% Toggle Enable
w.Enable = 'off';


%% Toggle Enable back on
w.Enable = 'on';


%% Change some node properties

% Rename a node
topNode.Name = 'TopNode (renamed)';

% Set an icon
branchIcon = fullfile(matlabroot,'toolbox','matlab','icons','pagesicon.gif');
nodeIcon = fullfile(matlabroot,'toolbox','matlab','icons','pageicon.gif');
setIcon(branchA,branchIcon);
setIcon(topNode,nodeIcon);


%% Allow interactively renaming a node

% Not working consistently
w.Editable = true;
w.NodeEditedCallback = @(h,e)disp({h.SelectedNodes.Name}');


%% Relocate nodes

% Move nodes around
nodesB(1).Parent = nodesA(1);


%% Add context menus

% For the whole tree
treeContextMenu = uicontextmenu('Parent',f);
uimenu(treeContextMenu,'Label','Refresh');
set(w,'UIContextMenu',treeContextMenu)

% For nodesA only
nodesAContextMenu = uicontextmenu('Parent',f);
uimenu(nodesAContextMenu,'Label','Nodes A');
set(nodesA,'UIContextMenu',nodesAContextMenu)

