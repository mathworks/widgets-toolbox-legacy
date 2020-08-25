%% Toolbar with Dark Background Theme
%%
% 
%   Copyright 2018-2020 The MathWorks Inc.
%
%% Create the widget

demoToolbar;
%% Set the colors

% Colors
BGCOLOR = 0.3 * [1 1 1]; %Background
FGCOLOR = 0.8 * [1 1 1]; %Foreground (text)
LABELBGCOLOR = 0.2 * [1 1 1]; %Background

set(w,...
    'BackgroundColor', BGCOLOR,...
    'ForegroundColor', FGCOLOR,...
    'LabelForegroundColor',FGCOLOR,...
    'LabelBackgroundColor', LABELBGCOLOR);