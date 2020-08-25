function redrawSelections(obj)
% redrawSelections - Updates selections in the viewer display
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


%% Prepare the data to display

% Get the selections
plotType = obj.DataModel.PlotType;
delayType = obj.DataModel.DelayType;

carrierFilter = obj.DataModel.CarrierFilter;
originFilter = obj.DataModel.OriginFilter;
destinationFilter = obj.DataModel.DestinationFilter;

enableDelaySlider = plotType ~= demoAppPkg.enum.PlotType.Mean;
delayTime = obj.DataModel.DelayTime;
 

%% Update the view

obj.h.PlotTypePopup.Value = plotType;
obj.h.DelayTypePopup.Value = delayType;

obj.h.CarrierPopup.Value = carrierFilter;
obj.h.OriginPopup.Value = originFilter;
obj.h.DestinationPopup.Value = destinationFilter;

obj.h.DelayTimeSlider.Value = delayTime;
obj.h.DelayTimeSlider.Enable = uiw.utility.tf2onoff(enableDelaySlider);
