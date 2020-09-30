function create(obj)
% create - Creates all parts of the viewer display
% -------------------------------------------------------------------------
%
% Notes: none
%

%   Copyright 2018-2020 The MathWorks Inc.
%
% 
%   
%   
%   
% ---------------------------------------------------------------------


%% Create the layout

obj.hLayout.MainBox = uix.Panel(...
    'Parent',obj.hBasePanel,...
    'FontSize',10,...
    'Title','Data Table');


%% Create the widgets

colInfo = {
    'Year'              'custom'    '###0  '
    'Carrier'           'char'      ''
    'Flight Num'        'custom'    '###0  '
    'Origin'            'char'      ''
    'Destination'       'char'      ''
    'Departure Delay'   'numeric'   ''
    'Arrival Delay'     'numeric'   ''
    };

obj.h.Table = uiw.widget.Table(...
    'Parent',obj.hLayout.MainBox,...
    'Tag','DataTable',...
    'ColumnName',colInfo(:,1),...
    'ColumnFormat',colInfo(:,2),...
    'ColumnFormatData',colInfo(:,3),...
    'Editable',false);

