%% Toolbar
%%
% 
%   Copyright 2017-2020 The MathWorks Inc.
%
%% Create the widget

% Performance Tip: For best launch performance, instantiate the toolbar
% with no Parent and/or Visible 'off'. Set Parent and Visible 'on' after
% all sections and buttons have been added.

% Positioning: Normally, you should have a fixed height for the toolbar.
% The width may adjust on resize. This example just uses normalized to
% demonstrate the width resizing, but the height resizing will look odd.

f = figure(...
    'Toolbar','none',...
    'MenuBar','none',...
    'NumberTitle','off',...
    'Units','pixels',...
    'Position',[100 100 880 160]);
movegui(f,[100 -100])

% Figure color (green screen to visualize toolbar better)
f.Color = [0 0.6 0];

w = uiw.widget.Toolbar(...
    'Parent',f,... %Normally start with this empty, until later
    'Visible','on',... %Normally start with this 'off'
    'Callback',@(h,e)disp(e),...
    'Units','normalized',...
    'Position',[0 .5 1 .5]);

% Initially, the toolbar will be blank
%% Add a section

w.addSection('FILES');
w.addButton('folder_24.png','Folder');
w.addButton('folder_file_24.png','FolderFile');
w.addButton('folder_file_open_24.png','FolderFileOpen');
w.addButton('save_24.png','Save');
w.addButton('save_all_24.png','SaveAll');
w.addButton('save_as_24.png','SaveAs');
%% Add a toggle section

w.addToggleSection('ARROWS',4); %Priority=4: lower gets space first
w.addToggleButton('arrow_down_24.png','Down');
w.addToggleButton('arrow_left_24.png','Left');
w.addToggleButton('arrow_right_24.png','Right');
w.addToggleButton('arrow_up_24.png','Up');
%% Add a section

w.addSection('VISUALIZE',1); %Priority=1: lower gets space first
w.addButton('play_24.png','Play');
% Store the handle of this button:
visButton = w.addButton('visualize_24.png','Plot');
%% Add a section

w.addSection('LISTS');
w.addButton('add_24.png','Add');
w.addButton('check_24.png','Check');
w.addButton('close_24.png','Close');
w.addButton('delete_24.png','Delete');
w.addButton('edit_24.png','Edit');
w.addButton('report_24.png','Report');


% Now is when you would set Parent and Visible, if they were not already
w.Parent = f;
w.Visible = 'on';
%% Toggle a button's Enable

visButton.Enable = 'off';
%% Hide a section

w.SectionIsVisible(2) = false;
%% Show it again

w.SectionIsVisible(2) = true;