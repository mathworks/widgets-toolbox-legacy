classdef (Hidden) FixedText < uiw.widget.Text
    % FixedText - For Backward Compatibility Only
    %
    % FixedText has been renamed to Text to accurately reflect its
    % functionality. This class is only for backward compatibility. Please
    % use Text instead.
    %
    
%   Copyright 2017-2020 The MathWorks Inc.
    %
    % 
    %   
    %   
    %   
    %   
    % ---------------------------------------------------------------------
    
    % This class is only for backward compatibility.
    % Please see uiw.widget.Text instead.
    
    
    %% Constructor / Destructor
    methods
        
        function obj = FixedText(varargin)
            obj@uiw.widget.Text(varargin{:});
        end %constructor
        
    end %methods - constructor/destructor
    
end % classdef
