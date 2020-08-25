function importFile(obj,fileName)
% importFile - import a data file
% -------------------------------------------------------------------------
%
% Notes: none
%

%   Copyright 2018-2019 The MathWorks Inc.
%
% 
%   
%   
%   
% ---------------------------------------------------------------------


%% Set import options

opts = detectImportOptions(fileName);

selVars = {
    'Year'
    'UniqueCarrier'
    'FlightNum'
    'Origin'
    'Dest'
    'ArrDelay'
    'DepDelay'
    };
    
opts.SelectedVariableNames = selVars; 
opts.MissingRule = 'fill';
opts = setvaropts(opts,{'ArrDelay','DepDelay'},'TreatAsMissing','NA');
opts = setvaropts(opts,{'ArrDelay','DepDelay'},'FillValue',0);
opts = setvartype(opts,{'UniqueCarrier','Origin','Dest'},'categorical');

% Rename this one
opts.VariableNames{9} = 'Carrier';


%% Read in the table

t = readtable(fileName,opts);


%% Set the table

obj.Table = t;