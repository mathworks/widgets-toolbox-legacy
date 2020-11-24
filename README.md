# Widgets Toolbox - Compatibility Support

WARNING - This version of Widgets Toolbox is intended to support forward compatibility of *existing* apps only.   If you are building new apps in MATLAB R2020b or later, please instead use the new "Widgets Toolbox - MATLAB App Building Components":

https://www.mathworks.com/matlabcentral/fileexchange/83328-widgets-toolbox-matlab-app-building-components
https://github.com/mathworks/widgets-toolbox

Starting in MATLAB R2020b, most existing apps that depend on Widgets Toolbox (uiw.* package) can be migrated from traditional figure windows (Java-based) into modern UI Figures (uifigure). There are known limitations and incompatibilities associated with migrating existing Widgets Toolbox content into uifigure. For this, please see the release notes at the end of the Getting Started Guide and begin testing migration of your apps into uifigure. 

It is recommended you install this as a toolbox to automatically set up the proper MATLAB and Java paths. If you install this manually, please review the installation directions in the Getting Started guide.

Need help upgrading a business-critical app? MathWorks Consulting can help: https://www.mathworks.com/services/consulting/proven-solutions/software-upgrade-service.html