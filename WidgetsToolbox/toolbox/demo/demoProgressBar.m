%% Progress Bar
%%
% 
%   Copyright 2017-2020 The MathWorks Inc.
%
%% Create the widget

f = figure(...
    'Toolbar','none',...
    'MenuBar','none',...
    'NumberTitle','off',...
    'Units','pixels',...
    'Position',[100 100 320 45]);
movegui(f,[100 -100])

w = uiw.widget.ProgressBar(...
    'Parent',f,...
    'Units','normalized',...
    'Position',[0 0 1 1]);


%% Start the progress bar

% Call this when the process is beginning. This sets progress to 0 and also
% initializes some internal states. In a future release, this may start a
% time remaining estimate.
w.startProgress('Starting...')

% If you call this without status text, it will CLEAR the last status text
w.startProgress()


%% Update the progress

w.setProgress(0.2, 'Step 1 begins')

% If you call this without status text, it will RETAIN the last status text
w.setProgress(0.2)


%% Mark the progress finished

w.finishProgress('DONE!')

% If you call this without status text, it will CLEAR the last status text
w.finishProgress()


%% Set the status text without using progress

% You can place any status message here too anytime
w.setStatusText('Status message here')


%% If you want a cancel button

% This enables the cancel button
w.AllowCancel = true;

% You must start the progress for it to show up
w.startProgress('Starting... you may cancel with this button ->');