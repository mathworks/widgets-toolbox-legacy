function redraw(obj)
% redraw - Updates all parts of the viewer display
% -------------------------------------------------------------------------
%
% Notes: none
%

%   Copyright 2018-2020 The MathWorks Inc.
%
% 
%   
%   
%   
% ---------------------------------------------------------------------

% Can only run if app construction is complete
if ~obj.IsConstructed
    return
end


%% Set the current model to each component

obj.h.BarChart.DataModel = obj.Session;
obj.h.PlotSelector.DataModel = obj.Session;
obj.h.DisplayTable.DataModel = obj.Session;