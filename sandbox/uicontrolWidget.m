classdef uicontrolWidget < uix.Container
    
    properties
        Table
    end
    
    methods
        function obj = uicontrolWidget(varargin)
            obj@uix.Container('Units','pixels',varargin{:});
            
            
        end
    end
        
    
    methods (Access=protected)
        function setup(obj)
            
            uicontrol(obj)
            
        end
    end
    
end

