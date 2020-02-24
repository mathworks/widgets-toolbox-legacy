classdef ComponentContainerWidgetWithUIControl < ...
        matlab.ui.componentcontainer.ComponentContainer
    
    % This works!
    %
    %   f = uifigure; w = ComponentContainerWidgetWithUIControl(f);
    
    properties
        Control
    end
    
    
    methods (Access=protected)
        function setup(obj)
            
            obj.Control = uicontrol(...
                'Parent',obj,...
                'Units','normalized',...
                'Position',[0 0 1 1]);
            
        end
    end
    
end

