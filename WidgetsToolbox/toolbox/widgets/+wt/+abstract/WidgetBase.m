classdef (Abstract) WidgetBase < ...
        matlab.ui.componentcontainer.internal.ComponentContainer
    % WidgetBase - Base class for a graphical widget
    %
    % This class provides the basic properties needed for a panel that will
    % contain a group of graphics objects to build a complex widget.
    %
    
    %   Copyright 2020 The MathWorks Inc.
    %
    % Auth/Revision:
    %   MathWorks Consulting
    %   $Author: rjackey $
    %   $Revision: 324 $
    %   $Date: 2019-04-23 08:05:17 -0400 (Tue, 23 Apr 2019) $
    % ---------------------------------------------------------------------
    
    
    %% Properties
    properties (AbortSet)
        % Enable (1,1) matlab.lang.OnOffSwitchState = 'on'
    end %properties
    
    
    %% Internal Properties
    properties %(GetAccess = protected, SetAccess = private)
        Grid (1,1) matlab.ui.container.GridLayout
    end
    
    
    
    %% Protected methods
    methods (Access = protected)
        
        function setup(obj)
            % Configure the widget
            
            % Grid Layout to manage building blocks
            obj.Grid = uigridlayout(obj,...
                'ColumnWidth',{'1x'},...
                'RowHeight',{'1x'},...
                'ColumnSpacing',2,'Padding',1);
            
        end %function
        
    end %methods
    
    
end %classdef

