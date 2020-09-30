function idx = validateIndicesOf(idx,array,allowDuplicates)
% validateIndicesOf - validate indices into an array
% -------------------------------------------------------------------------
%
% Syntax:
%   idx = uiw.utility.validateIndicesOf(idx,array,allowDuplicates)
%
%       
%

%   Copyright 2017-2020 The MathWorks Inc.
%
% 
%   
%   
%   
% ---------------------------------------------------------------------

narginchk(2,3)

maxIdx = numel(array);

if islogical(idx)
    validateattributes(idx,{'logical'},{'numel','<=',maxIdx});
    idx = find(idx);
else
    validateattributes(idx,{'numeric'},...
        {'positive','integer','finite','<=',numel(array)});
    if nargin>2 && allowDuplicates
        if numel(unique(idx))~=numel(idx)
           error('Duplicate indices into an array that are not allowed.'); 
        end
    end
end
