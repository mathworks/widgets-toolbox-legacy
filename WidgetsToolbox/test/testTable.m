function tests = testTable()
% Unit Test - Implements a unit test for a widget or component

% Copyright 2018 The MathWorks,Inc.
%
% Auth/Revision:
% MathWorks Consulting
% $Author: rjackey $
% $Revision: 324 $
% $Date: 2019-04-23 08:05:17 -0400 (Tue, 23 Apr 2019) $
% ---------------------------------------------------------------------

% Indicate to test the local functions in this file
tests = functiontests(localfunctions);

end %function

% Setup once for each test
function setup(testCase)

    testCase.TestData.Figure = figure();
    
end %function

% Teardown once for each test
function teardown(testCase)

    delete(testCase.TestData.Figure);
    
end %function


%% Test Basic Construction
function testDefaultConstructor1(testCase)

fcn = @()uiw.widget.Table();

verifyWarningFree(testCase,fcn)

end %function


%% Test Construction with Inputs
function testConstructionArguments(testCase)

fcn = @()uiw.widget.Table(...
    'Parent',testCase.TestData.Figure,...
    'ForegroundColor',[0 1 0],...
    'BackgroundColor',[0.5 0.5 0.5],...
    'FontAngle','normal',...
    'FontName','MS Sans Serif',...
    'FontSize',12,...
    'FontWeight','normal',...
    'Units','pixels',...
    'Position',[10 10 200 50],...
    'Tag','Test',...
    'Label','Unit Test:',...
    'Visible','on');

verifyWarningFree(testCase,fcn)

end %function


%% Test Numeric Data Format
function testNumericFormat(testCase)

data = [1 3; 2 4];
t = uiw.widget.Table(...
    'Parent',testCase.TestData.Figure,...
    'Data',data );
assert( isa(t.getCell(1,1),'double') );
assert( isa(t.Data,'double') );
assert( isequal(t.Data,data) );

% Change the value
data = [5, 6; 7, 8];
t.Data = data;
assert( isa(t.getCell(1,1),'double') );
assert( isa(t.Data,'double') );
assert( isequal(t.Data,data) );

% Change the size of the value
data = [5, 6, 7; 8, 9, 10];
t.Data = data;
assert( isa(t.getCell(1,1),'double') );
assert( isa(t.Data,'double') );
assert( isequal(t.Data,data) );

% Test setting a single cell
data = rand;
t.setCell(1,1,data);
cellData = t.getCell(1,1);
assert( isa(cellData,'double') );
assert( isequal(cellData,data) );
assert( isa(t.Data,'double') );

% Finally, test that onTableModelChanged doesn't error
data = rand;
t.JControl.getModel().setValueAt(data,0,0)

end %function


%% Test Cell Data Format
function testCellFormat(testCase)

Data = num2cell([1 3; 2 4]);
t = uiw.widget.Table(...
    'Parent',testCase.TestData.Figure,...
    'Data',Data );

assert( isa(t.getCell(1,1),'double') );
assert( isa(t.Data,'cell') );
assert( isequal(t.Data,Data) );

end %function


%% Test String Data Format
function testStringFormat(testCase)

str = reshape(string(num2cell('A':'F')),2,[]);
t = uiw.widget.Table(...
    'Parent',testCase.TestData.Figure,...
    'Data',str );

% Verify it set correctly
assert( isequal(t.Data,str) );

% Set a cell
newValue = "dd";
t.setCell(2,2,newValue)
value = t.getCell(2,2);
assert( isequal(value, char(newValue)) );

% Flip the data and set again
str = flipud(str);
t.Data = str;
assert( isequal(t.Data,str) );

% Set data as table
strTable = array2table(str);
t.DataTable = strTable;
assert( isequal(t.DataTable,strTable) );
assert( isequal(t.Data,table2cell(strTable) ) );

end %function


%% Test Date Formats
function testDateFormat(testCase)
dt = datetime();
dates = {
    dt - days(1)
    dt
    dt + days(1)
    dt + days(1) + hours(1)
    };
Data = repmat(dates,4,1);

fcn = @()uiw.widget.Table(...
    'Parent',testCase.TestData.Figure,...
    'ColumnName',{'Date Format 0','Date Format 00','Date Format 1','Date Format 2'},...
    'ColumnFormat',{'date','date','date','date'},...
    'ColumnFormatData',{[],'','yyyy-MM-dd','MMMM dd, yyyy'},...
    'Data',Data,...
    'Units','normalized', ...
    'Position',[0 0 1 1]);

t = verifyWarningFree(testCase,fcn);

% Test setting a single cell
data = dt + days(10);
t.setCell(1,1,data)
cellData = t.getCell(1,1);
assert( isa(cellData,'datetime') );
assert( isequal(cellData,data) );
assert( isa(t.Data,'cell') );

% Finally, test that onTableModelChanged doesn't error
data = t.JControl.getModel().getValueAt(0,1);
t.JControl.getModel().setValueAt(data,0,0);

end %function


%% Test Color Format
function testColorFormat(testCase)

data = {false [1 0 0]; true [0 1 0]};

fcn = @()uiw.widget.Table(...
    'Parent',testCase.TestData.Figure,...
    'ColumnName',{'Logical','Color'},...
    'ColumnFormat',{'logical','color'},...
    'Data',data,...
    'Units','normalized', ...
    'Position',[0 0 1 1]);

t = verifyWarningFree(testCase,fcn);


% Change the value
data = flipud(data);
t.Data = data;
assert( isa(t.getCell(1,2),'double') );
assert( isa(t.getCell(1,1),'logical') );
assert( isa(t.Data,'cell') );
assert( isequal(t.Data,data) );

% Change the size of the value
data = repmat(data,2,1);
t.Data = data;
assert( isa(t.getCell(4,2),'double') );
assert( isa(t.getCell(4,1),'logical') );
assert( isa(t.Data,'cell') );
assert( isequal(t.Data,data) );

% Set a logical value (bug reported)
t.Data{1,1} = false;

% Test setting a single cell
data = [0 1 1];
t.setCell(1,2,data)
cellData = t.getCell(1,2);
assert( isa(cellData,'double') );
assert( isequal(cellData,data) );
assert( isa(t.Data,'cell') );

% % Finally, test that onTableModelChanged doesn't error
% data = t.JControl.getModel().getValueAt(0,1);
% t.JControl.getModel().setValueAt(data,0,0);

end %function


%% Test sorting
function testSorting(testCase)

Data = [1 3; 2 4];
t = uiw.widget.Table(...
    'Parent',testCase.TestData.Figure,...
    'Data',Data );


verifyWarningFree(testCase, @()set(t,'Sortable',true) );
verifyWarningFree(testCase, @()sortColumn(t,2) );
verifyWarningFree(testCase, @()sortColumn(t,1,true,true) );

end %function


%% Test Changing Data Format
function testChangeFormat(testCase)

Data = [1 3; 2 4];
t = uiw.widget.Table(...
    'Parent',testCase.TestData.Figure,...
    'Data',Data );
t.setCell(1,1,'abc');
assert( isa(t.getCell(1,1),'char') );
assert( isa(t.Data,'cell') );
assert( isa(t.Data{1,1},'char') );
assert( isa(t.Data{1,2},'double') );

end %function


%% Test Data smaller/larger than number of columns


%% Test all column format options

function testAllColumnFormats(testCase)

ColumnFormat = {'','logical','integer','numeric','bank','date','char','longchar','popup','popuplist','color','imageicon'};
ColFData([5 9 10]) = { '$ #,##0.00', {'apples','oranges','bananas'}, {'fork','spoon','knife','spatula'} };
LongStr = repmat('abcdefg ',1,100); % A really long string
[~,IconPath1] = uiw.utility.loadIcon('save_24.png');
[~,IconPath2] = uiw.utility.loadIcon('open_24.png');
data = {
    %default logical integer numeric bank    date      char      longchar  popup      popupcheckbox              color    imageicon
    20       false	 int64(20) 20    20      datetime  'abc'     'abc'     'bananas'  'fork'                     [0 1 1]  IconPath1
    1.5      true    1.5     1.5     1.5     datetime  ''        LongStr   'apples'   {'fork','knife','spatula'} [1 1 0]  IconPath1
    22/7	 false   10000   22/7	 3.256	 datetime  'defgh'   LongStr   'oranges'  {}                         [0 0 0]  IconPath2
    true	 true	 1e9     0.525	 1000.2	 datetime  'ddd'     'efghi'   'apples'   {'spoon'}                  [1 1 1]  IconPath1
    'abc'    true	 50      1e9     -3      datetime  'lmnp'    ''        'apples'   {'knife','spoon'}          [1 0 0]  IconPath2
    };

t = uiw.widget.Table('Parent',testCase.TestData.Figure,...
    'ColumnName',ColumnFormat,...
    'ColumnFormat',ColumnFormat,...
    'ColumnFormatData',ColFData,...
    'ColumnResizePolicy','off',...
    'Data',data);
t.sizeColumnsToData();


assert( isequal(t.Data,data) );
assert( isa(t.Data,'cell') );
assert( isa(t.Data{1,1},'double') );
assert( isa(t.Data{1,6},'datetime') );
assert( isa(t.Data{1,3},'int64') );

end %function


%% Test DataTable output

function testDataTable(testCase)

dataTable = table([10;20],{'M';'F'});
dataTable.Properties.VariableNames = {'Age','Gender'};

t = uiw.widget.Table('Parent',testCase.TestData.Figure,...
    'DataTable',dataTable);

assert( isequal(t.DataTable, dataTable) );

end %function