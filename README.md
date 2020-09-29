# Widgets Toolbox (Legacy)

This version of Widgets Toolbox is intended for legacy support of existing MATLAB apps. For new app development using web figures (uifigure), please use the new Widgets Toolbox (Web Figures).
<New File Exchange URL>
https://github.com/mathworks/widgets-toolbox

Widgets Toolbox helps you efficiently develop advanced user interfaces in MATLAB. The toolbox provides additional UI controls and higher-level modules that implement common building blocks needed in MATLAB apps. Widgets combine existing control functionalities together into a larger, reusable, common functionality to accelerate development of graphical user interfaces. Existing users of GUI Layout Toolbox will find Widgets Toolbox pairs nicely with GUI Layout Toolbox.

Example components are:
- A file selection control, consisting of a label, edit field, and browse button
- A listbox control combined with a label and a set of buttons for managing the list composition and ordering
- A tree control providing advanced functionalities like drag and drop, and checkbox nodes

Widgets Toolbox also provides
- Superclasses for a whole application, to provide and manage saving and loading session state to and from a MAT-file
- Dialog windows for several typical kinds of user selection (and more to come in future development)
- A logger, especially useful for complex or deployed apps, that will store application events/data (of a configurable severity level) to a log file and display them in the command window
- Framework for efficiently building your own widgets

Widgets Toolbox is most applicable to users who are writing hand code to develop complex, modular applications with hand code using object-oriented programming in MATLAB. This toolbox currently only supports traditional MATLAB figure windows (Java-based) and does not support web graphics used in uifigure containers or App Designer. Widgets may be added programmatically to a GUIDE-generated app, but they will not show up in the graphical GUIDE editor.

It is recommended you install this as a toolbox to automatically set up the proper MATLAB and Java paths. If you install this manually, please review the installation directions in the Getting Started guide.

Planning a complex or business-critical app? MathWorks Consulting can advise you on design and architecture: https://www.mathworks.com/services/consulting/proven-solutions/software-development-with-matlab.html



