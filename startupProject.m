function startupProject()
%   Copyright 2020-2023 The MathWorks Inc.

% Disable warnings
warnState = warning('off','MATLAB:javaclasspath:jarAlreadySpecified');
warning('off','MATLAB:GENERAL:JAVARMPATH:NotFoundInPath');
setpref('WidgetsToolbox','ShowLegacyWarning',false);

% Disable installed Widgets Toolbox
try %#ok<TRYNC>
    matlab.addons.disableAddon("b0bebf59-856a-4068-9d9c-0ed8968ac9e6");
end

% Restore warning
warning(warnState);

% Leave off javacomponent warning
warning('off','MATLAB:ui:javacomponent:FunctionToBeRemoved');


% Is Java path added?
try
    com.mathworks.consulting.widgets.table.TableModel; %#ok<JAPIMATHWORKS>
catch
    jarPath = fullfile(widgetsRoot,'resource','MathWorksConsultingWidgets.jar');
    javaaddpath(jarPath);
end
