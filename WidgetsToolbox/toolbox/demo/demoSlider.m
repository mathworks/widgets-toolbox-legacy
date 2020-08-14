%% Slider
%%
% 
%   Copyright 2017-2019 The MathWorks Inc.
%
%% Create the widget

f = uifigure(...
    'Toolbar','none',...
    'MenuBar','none',...
    'NumberTitle','off',...
    'Units','pixels',...
    'Position',[100 100 520 60]);
movegui(f,[100 -100])

w = uiw.widget.Slider(...
    'Parent',f,...
    'Min',0,...
    'Max',100,...
    'Value',0,...
    'Callback',@(h,e)disp(e),...
    'Label','Select a value:',...
    'LabelLocation','left',...
    'LabelWidth',90,...
    'Units','normalized',...
    'Position', [0 0 1 1]);
%% Change the limits

w.Min = 2;
w.Max = 25;
%% Move edit box to the other side

w.FlipText = true;
%% Allow entering text values outside range

w.EnforceRange = false;
% Enter 4 in edit box, it should turn yellow
%% Make it vertical

f.Position(3:4) = [120 440];
movegui(f,[100 -100])

w.Orientation = 'vertical';
w.LabelLocation = 'top';
%% Back to Normal

f.Position(3:4) = [520 60];
movegui(f,[100 -100])

w.Orientation = 'horizontal';
w.LabelLocation = 'left';
w.FlipText = false;