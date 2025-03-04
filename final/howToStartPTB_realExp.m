clearvars; sca; clc


%% how to start ptb

PsychDefaultSetup(2) 

% from documentation:

% A ‘featureLevel’ of 0 will do nothing but execute the AssertOpenGL command,
% to make sure that the Screen() mex file is properly installed and functional.
 
% A ‘featureLevel’ of 1 will additionally execute KbName(‘UnifyKeyNames’) to
% provide a consistent mapping of keyCodes to key names on all operating
% systems.

% A ‘featureLevel’ of 2 will additionally imply the execution of
% Screen(‘ColorRange’, window, 1, [], 1); immediately after and whenever
% PsychImaging(‘OpenWindow’,…) is called, thereby switching the default
% color range from the classic 0-255 integer number range to the normalized
% floating point number range 0.0 - 1.0 to unify color specifications
% across differently capable display output devices, e.g., standard 8 bit
% displays vs. high precision 16 bit displays. 


P.ptb.screens = Screen('Screens');

Screen('Preference', 'SkipSyncTests', 0);

% from https://psychtoolbox.discourse.group/t/input-for-skipping-synchronization-test/4296
% For proper data collection where timing matters, only default level 0 is 
% acceptable for full tests and error abort if anything problematic/wrong 
% is detected.

Screen('Preference', 'SyncTestSettings', 0.001, [], [], []);
Screen('Preference', 'VisualDebugLevel', 0);


[win, winRect] = PsychImaging('OpenWindow', whichScreen, BackgroundColor);
% (with PsychdefautSetup(2), Color should be float between 0-1, and not
% 0-255

% make sure, that the lines can be drawn smoothly/ anti-aliased
Screen('BlendFunction', win, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');



