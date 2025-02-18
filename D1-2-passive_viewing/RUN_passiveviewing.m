clearvars; sca; clc


P = passiveviewing_doparams();

screens = Screen('Screens');

% Define black and white
white = WhiteIndex(max(screens));
black = BlackIndex(max(screens));
grey = white / 2;

[window, windowRect] = PsychImaging('OpenWindow', 0, grey);
