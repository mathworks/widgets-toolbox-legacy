classdef HasContainer < uiw.mixin.AssignPVPairs & matlab.mixin.SetGet & ...
        matlab.mixin.CustomDisplay
    % HasContainer - Mixin class for a graphical widget container
    %
    % This class provides common properties and methods that are used by a
    % widget, specifically those that may need to be inherited from
    % multiple related classes. They are defined here instead of
    % uiw.abstract.HasContainer, because we don't want the
    % uiw.abstract.HasContainer constructor to run multiple times for an
    % object that is using multiple inheritance.
    %
    
    %   Copyright 2017-2019 The MathWorks Inc.
    %
    % Auth/Revision:
    %   MathWorks Consulting
    %   $Author: rjackey $
    %   $Revision: 324 $
    %   $Date: 2019-04-23 08:05:17 -0400 (Tue, 23 Apr 2019) $
    % ---------------------------------------------------------------------
    
    %% Properties
    properties (Abstract, AbortSet)
        Enable char {mustBeMember(Enable,{'on','off'})} %Allow interaction with this widget [(on)|off]
        Padding (1,1) double %Pixel spacing around the widget (applies to some widgets)
        Spacing (1,1) double %Pixel spacing between controls (applies to some widgets)
    end %properties
    
    properties (Abstract, SetAccess=protected)
        h (1,1) struct %For widgets to store internal graphics objects
        hLayout (1,1) struct %For widgets to store internal layout objects
        IsConstructed (1,1) logical %Indicates widget has completed construction, useful for optimal performance to minimize redraws on launch, etc.
    end %properties
    
    
    %% Abstract Methods
    methods (Abstract, Access=protected)
        redraw(obj) %Handle state changes that may need UI redraw - subclass must override
        onResized(obj) %Handle changes to widget size - subclass must override
        onContainerResized(obj) %Triggered on resize of the widget's container - subclass must override
    end %methods
    
end % classdef
