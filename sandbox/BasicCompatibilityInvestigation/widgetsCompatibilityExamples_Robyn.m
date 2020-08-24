% The following examples show challenges in rebuilding widgets and/or
% support of legacy widgets in both figure types

%% New Widget Example - Text Edit Field in UIFigure
% This is my first pass at a new format for future development. The "wt"
% package would be all new with no plans for backward compatibility with
% traditional figures.

f = uifigure("Position",[1 1100 560 420],'Color','white');
g = uigridlayout(f,'RowHeight',{25},'ColumnWidth',{'1x',50});
w = wt.TextEditField(g)



%% Issue 1: I would like to be able to set some property values before setup method

f = uifigure("Position",[1 1100 560 420],'Color','white');
g = uigridlayout(f,'RowHeight',{25},'ColumnWidth',{'1x'});

% If TrackHistory is true, I'd like to set it prior to the setup method so
% it becomes a dropdown instead of edit field. This helps keep common code
% and makes the development a little easier, since there's no need for the
% file/folder selector to change between an edit field and dropdown after
% creation.

w = wt.FolderSelectorConfigurable(g,'TrackHistory',true)


%% Issue 1: Resolution

% I was able to work around this by switching between edit/dropdown
% controls in a separate method that is triggered on property
% "TrackHistory" being changed. It's not too big of a workaround, though it
% would still be nice if there was an easy way to set designated properties
% before setup.

f = uifigure("Position",[1 1100 560 420],'Color','white');
g = uigridlayout(f,'RowHeight',{25},'ColumnWidth',{'1x'});

w = wt.FolderSelectorConfigurable2(g,'TrackHistory',true)

% To toggle:
% w.TrackHistory = ~w.TrackHistory;



%% Issue 2: Inheritance and UsedInUpdate


% In this case, my widget has multiple inheritance, and
% the superclass wt.abstract.HasTextEditField is not a subclass of
% ComponentContainer. 

f = uifigure();
g = uigridlayout(f,'RowHeight',{27},'ColumnWidth',{'1x',50});
w = wt.FolderSelector(g,'RootDirectory',pwd);

% After creation, set a breakpoint in the update function
drawnow
dbstop in wt.FolderSelector at 99 %Within the update function

%% Issue 2: Now try to change a property in the superclass
% Notice changing the property "Value" of wt.abstract.HasTextEditField does
% not trigger update:

w.Value = 'abc'

% It doesn't trigger update.  However, if we move the "Value" property into
% wt.FolderSelector (or even if it's abstract in
% wt.abstract.HasTextEditField  and defined in wt.FolderSelector), then it
% does trigger update as expected.


%% Compatibility mode: Turn on uicontrol redirect

% For compatibility with old widgets, we can turn on uicontrol redirect

% Enable uicontrol redirect
s = settings;
s.matlab.ui.internal.uicontrol.UseRedirect.TemporaryValue = 1;
s.matlab.ui.internal.uicontrol.UseRedirectInUifigure.TemporaryValue = 1;

% Note: If you want all figures created in matlab to launch a web figure,
% start matlab with the -webfigures flag.


%% Issue 3: Legacy figure support 

% This very simple example works to show I can create a uicontrol in a
% ComponentContainer and place in a traditional figure and a uifigure
f = figure;
t = uicontrolWidget(f);

uf = uifigure;
t = uicontrolWidget(uf);



%% Issue 3: Legacy figure support

% This legacy widget does not launch. I've fixed a few things such as removing
% "FontUnits". It errors on trying to set uicontrols to have the widget as
% its parent. I'm stumped as to why this fails.

f = uifigure("Position",[1 1100 560 420],'Color','white');
w = uiw.widget.Popup('Parent',f);

% Error using uiw.abstract.BasePanel (line 47)
% Popup cannot be a parent of Panel.
% 
% Error in uiw.abstract.WidgetContainer (line 35)
%             obj@uiw.abstract.BasePanel();
% 
% Error in uiw.widget.Popup
% 
% Error in widgetsCompatibilityExamples_Robyn (line 88)
% w = uiw.widget.Popup('Parent',f);


%% Issue 4: New widget - "Show all properties" not working

% This particular widget has an issue with displaying results when you
% click "Show all properties" after displaying it in the command window.

f = uifigure("Position",[1 1100 560 420],'Color','white');
g = uigridlayout(f,'RowHeight',{25},'ColumnWidth',{'1x',50});
w = wt.TextEditField(g)

% w = 
% 
%   TextEditField with properties:
% 
%     Position: [100 100 100 100]
% 
%   Show all properties
% 
% Unable to display properties for variable w because it has been cleared or is no longer scalar.