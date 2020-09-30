function startupProject()
%   Copyright 2020 The MathWorks Inc.

% Disable warning
warnState = warning('off','MATLAB:javaclasspath:jarAlreadySpecified');
warning('off','MATLAB:GENERAL:JAVARMPATH:NotFoundInPath');

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
    com.mathworks.consulting.widgets.table.TableModel;
catch
    jarPath = fullfile(widgetsRoot,'resource','MathWorksConsultingWidgets.jar');
    javaaddpath(jarPath);
end

% Turn on uicontrol redirect
if ~verLessThan('matlab','9.9')
    s = settings;
    s.matlab.ui.internal.uicontrol.UseRedirect.TemporaryValue = 1;
    s.matlab.ui.internal.uicontrol.UseRedirectInUifigure.TemporaryValue = 1;
end
