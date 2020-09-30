# Widgets Toolbox (Legacy)

This version of Widgets Toolbox is intended for legacy support of existing MATLAB apps. For new app development using web figures (uifigure), please use the new Widgets Toolbox (Web Figures):
<New File Exchange URL>
https://github.com/mathworks/widgets-toolbox

Most existing apps that depend on Widgets Toolbox (uiw.* package) can now be migrated from traditional figure windows (Java-based) into modern UI Figures (uifigure). There are known limitations and incompatibilities associated with migrating existing Widgets Toolbox content into uifigure. For this, please see the release notes at the end of the Getting Started Guide and begin testing migration of your apps (or portions of it) into uifigure. 

If you are building new content and can use R2020b or later, please instead use the components in Widgets Toolbox (UI Figure Apps) listed above. The new components use the wt.* package to avoid confusion.


Widgets Toolbox helps you efficiently develop advanced user interfaces in MATLAB. The toolbox provides additional UI controls and higher-level modules that implement common building blocks needed in MATLAB apps. Widgets combine existing control functionalities together into a larger, reusable, common functionality to accelerate development of graphical user interfaces. Existing users of GUI Layout Toolbox will find Widgets Toolbox pairs nicely with GUI Layout Toolbox.

Widgets Toolbox is most applicable to users who are writing hand code to develop complex, modular applications with hand code using object-oriented programming in MATLAB. 

It is recommended you install this as a toolbox to automatically set up the proper MATLAB and Java paths. If you install this manually, please review the installation directions in the Getting Started guide.


Need help upgrading a business-critical app? MathWorks Consulting can help: https://www.mathworks.com/services/consulting/proven-solutions/software-upgrade-service.html