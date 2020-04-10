function tests = testTree()
% Unit Test - Implements a unit test for a widget or component

% Copyright 2018 The MathWorks,Inc.
%
% Auth/Revision:
% MathWorks Consulting
% $Author: rjackey $
% $Revision: 55 $
% $Date: 2018-02-27 13:41:05 -0500 (Tue, 27 Feb 2018) $
% ---------------------------------------------------------------------

% Indicate to test the local functions in this file
tests = functiontests(localfunctions);

end %function

% Setup once for each test
function setup(testCase)

testCase.TestData.Figure = figure();

end %function

% Teardown once for each test
function teardown(testCase)

delete(testCase.TestData.Figure);

end %function


%% Test Basic Construction
function testDefaultConstructor1(testCase)

fcn = @()uiw.widget.Tree();

verifyWarningFree(testCase,fcn)

end %function


%% Test Construction with Inputs
function testConstructionArguments(testCase)

fcn = @()uiw.widget.Tree(...
    'Parent',testCase.TestData.Figure,...
    'DndEnabled',false,...
    'RootVisible',true,...
    'SelectedNodes',[],...
    'SelectionType','single',...
    'KeyPressedCallback',@()disp('KeyPressedCallback'),...
    'MouseClickedCallback',@()disp('MouseClickedCallback'),...
    'MouseMotionFcn',@()disp('MouseMotionFcn'),...
    'NodeDraggedCallback',@()true(1),...
    'NodeDroppedCallback',@()disp('NodeDroppedCallback'),...
    'NodeExpandedCallback',@()disp('NodeExpandedCallback'),...
    'NodeCollapsedCallback',@()disp('NodeCollapsedCallback'),...
    'NodeEditedCallback',@()disp('NodeEditedCallback'),...
    'SelectionChangeFcn',@()disp('SelectionChangeFcn'),...
    'TreeBackgroundColor',[0.8 0.8 0.8],...
    'TreePaneBackgroundColor',[0.9 0.9 0.9],...
    'SelectionForegroundColor',[0.1 0.1 0.1],...
    'SelectionBackgroundColor',[0.2 0.5 0.9],...
    'ForegroundColor',[0 1 0],...
    'BackgroundColor',[0.5 0.5 0.5],...
    'FontAngle','normal',...
    'FontName','MS Sans Serif',...
    'FontSize',12,...
    'FontWeight','normal',...
    'Units','pixels',...
    'Position',[10 10 200 50],...
    'Tag','Test',...
    'Label','Unit Test:',...
    'Visible','on');

verifyWarningFree(testCase,fcn)

end %function


%% Test add nodes
function testAddNodes(testCase)

w = uiw.widget.Tree('Parent',testCase.TestData.Figure);

% Add nodes
node_1 = uiw.widget.TreeNode('Name','Node_1','Parent',w.Root);
node_1_1 = uiw.widget.TreeNode('Name','Node_1_1','Parent',node_1,'TooltipString','Node1_1'); %#ok<NASGU>
node_1_2 = uiw.widget.TreeNode('Name','Node_1_2','Parent',node_1,'TooltipString','Node1_2');
node_2 = uiw.widget.TreeNode('Name','Node_2','Parent',w.Root); %#ok<NASGU>

% Move nodes around
verifyWarningFree(testCase, @()set(node_1_2,'Parent',w) )

end %function


%% Test node icons
function testNodeIcons(testCase)

w = uiw.widget.Tree('Parent',testCase.TestData.Figure);
node_1 = uiw.widget.TreeNode('Name','Node_1','Parent',w.Root);
node_2 = uiw.widget.TreeNode('Name','Node_2','Parent',w.Root);

icon1 = fullfile(matlabroot,'toolbox','matlab','icons','pagesicon.gif');
icon2 = fullfile(matlabroot,'toolbox','matlab','icons','pageicon.gif');

verifyWarningFree(testCase, @()node_1.setIcon(icon1) )
verifyWarningFree(testCase, @()node_2.setIcon(icon2) )

end %function


%% Test node rename
function testNodeRename(testCase)

w = uiw.widget.Tree('Parent',testCase.TestData.Figure);
node_1 = uiw.widget.TreeNode('Name','Node_1','Parent',w.Root);

verifyWarningFree(testCase, @()set(node_1,'Name','Node_1_1 (renamed)') )

end %function


%% Test enable/disable
function testEnableDisable(testCase)

w = uiw.widget.Tree('Parent',testCase.TestData.Figure);
node_1 = uiw.widget.TreeNode('Name','Node_1','Parent',w.Root);%#ok<NASGU>

verifyWarningFree(testCase, @()set(w,'Enable','off') )
verifyWarningFree(testCase, @()set(w,'Enable','on') )

end %function


%% Test selection modes
function testSelectionModes(testCase)

w = uiw.widget.Tree('Parent',testCase.TestData.Figure);
node_1 = uiw.widget.TreeNode('Name','Node_1','Parent',w.Root);
node_1_1 = uiw.widget.TreeNode('Name','Node_1_1','Parent',node_1,'TooltipString','Node1_1');
node_1_2 = uiw.widget.TreeNode('Name','Node_1_2','Parent',node_1,'TooltipString','Node1_2'); %#ok<NASGU>

node_2 = uiw.widget.TreeNode('Name','Node_2','Parent',w.Root);
verifyWarningFree(testCase, @()set(w,'SelectionType','discontiguous') )
verifyWarningFree(testCase, @()set(w,'SelectedNodes',[node_1_1, node_2]) )

end %function


%% Test selection modes
function testHideRoot(testCase)

w = uiw.widget.Tree('Parent',testCase.TestData.Figure);

verifyWarningFree(testCase, @()set(w,'RootVisible',false) )

end %function


%% Test context menus
function testContextMenus(testCase)

w = uiw.widget.Tree('Parent',testCase.TestData.Figure);
node_1 = uiw.widget.TreeNode('Name','Node_1','Parent',w.Root);%#ok<NASGU>
node_2 = uiw.widget.TreeNode('Name','Node_2','Parent',w.Root);

% Tree context menu
tree_menu = uicontextmenu('Parent',testCase.TestData.Figure);
uimenu(tree_menu,'Label','Refresh');

verifyWarningFree(testCase, @()set(w,'UIContextMenu',tree_menu) )

% Node context menu
node_menu = uicontextmenu('Parent',testCase.TestData.Figure);
uimenu(node_menu,'Label','Node1');

verifyWarningFree(testCase, @()set(node_2,'UIContextMenu',node_menu) )

end %function


%% Test drag and drop
function testDragDrop(testCase)

w = uiw.widget.Tree('Parent',testCase.TestData.Figure);
node_1 = uiw.widget.TreeNode('Name','Node_1','Parent',w.Root); %#ok<NASGU>
node_2 = uiw.widget.TreeNode('Name','Node_2','Parent',w.Root); %#ok<NASGU>

verifyWarningFree(testCase, @()set(w,'DndEnabled',true) )

end %function