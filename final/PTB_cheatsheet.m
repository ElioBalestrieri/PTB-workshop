%% PTB cheatsheet
% this is not a real code. So if you try running, it
% will throw errors. 


%% hardware control and performance

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
% also, we don't specify screen size, as we want the window to be opened
% fullscreen

% make sure, that the lines can be drawn smoothly/ anti-aliased
Screen('BlendFunction', win, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');


%% keyboard

 KbName('UnifyKeyNames'); % against OS incompatibilities


% stop getting input from keyboard
% WARNING: this is a critical command, as it will make you incapable of
% control script execution with your keyboard. 
ListenChar(-1)

ListenChar(0)
% to regain control


% ListenChar is temporarily overridden by KbCheck:
ListenChar(-1)

WaitSecs(2)

[keyIsDown, ~, keyCode] = KbCheck()

WaitSecs(2)

ListenChar(0)


% you can understand that the combination of a stuck fullscreen, together
% with lack of keyboard control can be dramatic. For this reason, both
% window opening as well as ListenChar(-1) should be part of a try-catch
% statement...


% set highest Priority for the current code so that other processes will
% not interfere
Priority(MaxPriority(win)) % beginning of the script

Priority(0) % end of the script


% hide-show cursor
HideCursor() % screenID, mouseID
WaitSecs(6)
ShowCursor()


%% writing text

% change font and textsize, if needed
Screen('TextFont', P.ptb.win, 'Ariel');
Screen('TextSize', P.ptb.win, P.textsize);

str_break = ['Zeit für eine kurze Pause!\n', ...
    'Bitte bleiben Sie ruhig sitzen und ruhen Sie sich kurz aus.\n\n'];
    
Screen('FillRect', win, grey);
DrawFormattedText(win, str_break, 'center',  'center');
Screen('Flip', win);

%% EEG Trigger

% from the Gospel of Wanja Mössing
% https://github.com/wanjam/Easy-TTL-trigger

%% Eyelink

% from the Gospel of Wanja Mössing, again
% https://github.com/wanjam/Easy-Eyelink-Interface


