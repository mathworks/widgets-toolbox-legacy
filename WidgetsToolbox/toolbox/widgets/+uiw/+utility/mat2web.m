function wData = mat2web(mData)
% mat2Web - Utility to convert MATLAB array to Web array
% 
% Abstract: This utility will convert MATLAB arrays to a Web equivalent
%
% Syntax:
%           wData = uiw.utility.mat2Web(mData)
%
% Inputs:
%           mData - the MATLAB array
%
% Outputs:
%           wData - the Web array
%
% Examples:
%           none
%
% Notes: none
%

%   Copyright 2020 The MathWorks Inc.
%
% Auth/Revision:
%   MathWorks Consulting
%   $Author: rjackey $
%   $Revision: 324 $  $Date: 2019-04-23 08:05:17 -0400 (Tue, 23 Apr 2019) $
% ---------------------------------------------------------------------

% Validate input
validateattributes(mData,{'numeric','logical','char','cell','datetime'},{'2d'})


%% What type of data is this?

switch class(mData)
    
    case 'cell'
        
        % Requres recursion in each cell
        wData = cell(size(mData));
        for idx=1:numel(mData)
            wData{idx} = uiw.utility.mat2Web(mData{idx});
        end
        
    case 'datetime'
        
        wData = char(mData);
        
    case 'color'
        
        wData = mat2str(mData);
        
    case 'popuplist'
        
        wData = WebObject('Web.lang.Double',mData);
        
    case 'single'
        
        wData = WebObject('Web.lang.Float',mData);
        
    case 'int64'
        
        wData = WebObject('Web.lang.Long',mData);
        
    case 'int32'
        
        wData = WebObject('Web.lang.Integer',mData);
        
    case 'int16'
        
        wData = WebObject('Web.lang.Short',mData);
        
    case 'int8'
        
        wData = WebObject('Web.lang.Byte',mData);
        
    case {'uint8','uint16','uint32','uint64'}
        
        warning('mat2Web:unsigned','Web does not support unsigned types.');
        
        % Leave as-is
        wData = mData;
        
    case 'logical'
        
        wData = WebObject('Web.lang.Boolean',mData);
        
    otherwise
        
        % Leave as-is
        wData = mData;
        
end %switch class(mData)

end %function mat2Web
