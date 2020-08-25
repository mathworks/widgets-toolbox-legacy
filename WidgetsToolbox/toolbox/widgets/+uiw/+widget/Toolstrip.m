classdef (Hidden) Toolstrip < uiw.widget.Toolbar
    % Toolstrip - For Backward Compatibility Only
    %
    % Toolstrip has been renamed to Toolbar to accurately reflect its
    % functionality. This class is only for backward compatibility. Please
    % use Toolbar instead.
    %
    
%   Copyright 2017-2019 The MathWorks Inc.
    %
    % 
    %   
    %   
    %   
    %   
    % ---------------------------------------------------------------------
    
    % This class is only for backward compatibility. 
    % Please see uiw.widget.Toolbar instead.
    
    
    %% Constructor / Destructor
    methods
        
        function obj = Toolstrip(varargin)
            obj@uiw.widget.Toolbar(varargin{:});
        end %constructor
        
    end %methods - constructor/destructor
    
end %classdef