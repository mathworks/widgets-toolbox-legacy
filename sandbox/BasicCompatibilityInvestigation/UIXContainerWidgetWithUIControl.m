classdef UIXContainerWidgetWithUIControl < uix.Container
    
    % This widget works fine!
    %
    %     Turn on uicontrol redirect:
    %  
    % 	>> s = settings;
    % 	>> s.matlab.ui.internal.uicontrol.UseRedirect.TemporaryValue = 1;
    %   >> s.matlab.ui.internal.uicontrol.UseRedirectInUifigure.TemporaryValue = 1;
    
    properties
        Control
    end
    
    methods
        function obj = UIXContainerWidgetWithUIControl(varargin)
            obj@uix.Container(...
                'Units','pixels',...
                'Position',[20 20 60 20],...
                varargin{:});
            obj.Control = uicontrol(...
                'Parent',obj,...
                'Units','normalized',...
                'Position',[0 0 1 1]);
            
        end
    end

end