function shutdownProject()
%   Copyright 2020 The MathWorks Inc.

% Close all figures
close all force

% Re-enable installed Widgets Toolbox
try %#ok<TRYNC>
    matlab.addons.enableAddon("b0bebf59-856a-4068-9d9c-0ed8968ac9e6");
end


% Restore javacomponent warning
warning('on','MATLAB:ui:javacomponent:FunctionToBeRemoved');