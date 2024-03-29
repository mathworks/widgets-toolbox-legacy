% makeToolboxRelease - Make a release of this toolbox
%

% Copyright 2018-2023 The MathWorks, Inc.
% ---------------------------------------------------------------------

%% Files the author should manually edit for each release:
%
%   ..\toolboxPackagerProject.prj: Package Toolbox project file - update 
%       the revision number, project description, etc.
%
%   \...\functionSignatures.json: (Optional) For code completion and
%       code analyzer - Place one in each folder containing function files,
%       and modify.
%
%   \doc\GettingStarted.mlx: Live editor version of Getting Started Guide -
%       accessible in Add-On Manager  ** CONTAINS RELEASE NOTES! **

verNum = '1.5'; % Major.Minor software revision number
revNum = 1; %Revision number from source control system
mlVer = 'R2023a'; % MATLAB version to display

%% Files the author should manually edit initially:
%
%   \myToolbox: folder name used for toolbox identifier. Rename to
%       another valid name. Used if you do: ver('myToolbox') or
%       verLessThan('myToolbox') to check installed toolbox and
%       version.
%
%   \info.xml: Toolbox Name, MATLAB Release number
%
%   \doc\helptoc.xml: Documentation outline and links to HTML pages
%
%   \doc\GettingStarted.mlx: Live editor version of Getting Started Guide -
%       accessible in Add-On Manager

%% Files updated automatically:
%   \demos.xml: generated based on setting 
%   \demo\html: generated based on setting in Package Toolbox project file
%   \doc\helpsearch-v3: generated by builddocsearchdb
%   \toolbox\DesktopToolset.xml: generated for apps included and listed in  
%       Package Toolbox project file 

%% Review and modify these settings before running this file

% Get the toolbox root directory
toolboxRoot = fileparts( which('makeToolboxRelease') );

% Get the date
verDate = datestr(now,1); % Today's date

% Define input file locations
demoPath = fullfile(toolboxRoot,'toolbox', 'demo');
docInputPath = fullfile(toolboxRoot,'doc_input');
toolboxPath = fullfile(toolboxRoot,'toolbox');

% Output locations
docOutputPath = fullfile(toolboxRoot,'toolbox','doc');
demoDocOutputPath = fullfile(toolboxRoot,'toolbox','demo','html');
outputFile = fullfile(toolboxRoot,'release',sprintf('Widgets Toolbox %s.%d.mltbx',verNum,revNum));
contentsPath = fullfile(toolboxRoot,'toolbox','widgets','Contents.m');

% Toolbox Packager Project File - Don't forget to open this file manually
% and update the revision number, description, and other info.
projectFile = fullfile(toolboxRoot,'toolboxPackagerProject.prj');

% Add toolbox to path
% addpath(genpath(toolboxPath));

% Add Java paths
jarFile = fullfile(widgetsRoot,'resource','MathWorksConsultingWidgets.jar');
javaaddpath(jarFile);

%% Run unit tests
testResult = runToolboxUnitTests;
if ~all([testResult.Passed])
    error('Unit tests failed.');
end

%% Write contents file
% This file registers the toolbox and the "ver" command will list it
fid = fopen(contentsPath,'w');
fprintf(fid, '%% Widgets Toolbox - Compatibility Support\n%% Version %s.%d (%s) %s\n', verNum, revNum, mlVer, verDate );
fprintf(fid, "%%\n%% Copyright 2018-%s The MathWorks Inc.\n", datestr(now,'yyyy') );
fprintf(fid, "%%\n%% This is an autogenerated file, please do not modify\n");
fclose(fid);

%% Publish *.mlx help documents to HTML
% Publish each *.mlx file from doc_input into doc as html
docFileInfo = what(docInputPath);
inputFiles = fullfile(docInputPath, docFileInfo.mlx);
outputFiles = fullfile(docOutputPath, strrep(docFileInfo.mlx,'.mlx','.html'));
for idx = 1:numel(inputFiles)
    inputFileInfo = dir(inputFiles{idx});
    outputFileInfo = dir(outputFiles{idx});
    % If the output file does not already exist or is older, publish
    if isempty(outputFileInfo) || outputFileInfo.datenum < inputFileInfo.datenum
        fprintf('Publishing %s\n', outputFiles{idx});
        matlab.internal.liveeditor.openAndConvert(inputFiles{idx}, outputFiles{idx});
    end
end

%% Publish class reference doc

% sectionList = {
%     'uiw'           'Class Reference for Widgets Toolbox uiw Package'
%     'uiw.abstract'  'Abstract Classes (Application and Widget Superclasses)'
%     'uiw.dialog'    'Dialogs'
%     'uiw.enum'      'Enumeration Classes (Enumerations used internally by certain widgets)'
%     'uiw.event'     'Event Classes (Events used internally by certain widgets)'
%     'uiw.mixin'     'Mixin Classes (Mixins that may be added to apps, widgets, etc.)'
%     'uiw.model'     'Model Classes (Data models: Preferences, etc.)'
%     'uiw.tool'      'Tool Classes (Related tools: Logger, LogMessage, etc.)'
%     'uiw.utility'   'Utilities (Various utilities for conversions, validation, etc.)'
%     'uiw.widget'    'Widgets'
%     };
% 
% for idx = 1:size(sectionList,1)
%     
%     % Generate the help doc
%     html = help2html(sectionList{idx,:},'-doc');
%     thisFile = fullfile(docOutputPath,[sectionList{idx,1} '.html']);
%     
%     % Add copyright notice
%     t = datetime;
%     if t.Year>2018
%         copyrightText = sprintf('Copyright 2018-%d The MathWorks, Inc.',t.Year);
%     else
%         copyrightText = 'Copyright 2018 The MathWorks, Inc.';
%     end
%     html = strrep(html,'</html>',[copyrightText newline '</html>']);
%     
%     % Write the HTML file
%     fid = fopen(thisFile,'w');
%     fprintf(fid,'%s',html);
%     fclose(fid);
%     
% end

%% Build search database
builddocsearchdb(docOutputPath)

%% Package Toolbox
matlab.addons.toolbox.packageToolbox(projectFile, outputFile)
fprintf('Successfully generated toolbox: %s\n', outputFile);
close all force

