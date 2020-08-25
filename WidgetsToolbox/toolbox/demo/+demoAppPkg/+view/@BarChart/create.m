function create(obj)
% create - Creates all parts of the viewer display
% -------------------------------------------------------------------------
%
% Notes: none
%

%   Copyright 2018-2019 The MathWorks Inc.
%
% 
%   
%   
%   
% ---------------------------------------------------------------------


%% Create the layout

obj.hLayout.MainBox = uix.BoxPanel(...
    'Parent',obj.hBasePanel,...
    'FontSize',10,...
    'Title','Bar Chart');

% Axes should be inside a container, in case colorbar or legend are added
obj.hLayout.AxesContainer = uicontainer('Parent',obj.hLayout.MainBox);


%% Create the widgets

obj.h.Axes = axes(...
    'Parent',obj.hLayout.AxesContainer);

obj.h.BarPlot = gobjects(0);

