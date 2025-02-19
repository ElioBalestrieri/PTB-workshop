function ptb = start_ptb(P)

screens = Screen('Screens');

% Define black and white
ptb.white = WhiteIndex(max(screens));
ptb.black = BlackIndex(max(screens));
ptb.grey = ptb.white/2; 

% EXERCISE: we define grey as the midway between black (0) and white (255)
% how do we know that this is the correct background of our images? How do
% we make the background adherent to the images? Do we have to cut all of
% them with photoshop?

% HINT: when loading the images, go look in the data matrix...

%
[ptb.win, ptb.winRect] = PsychImaging('OpenWindow', max(screens), ptb.grey, P.debugRect);
[ptb.cntr.X, ptb.cntr.Y] = RectCenter(ptb.winRect);

% get inter frame interval (IFI)
ptb.ifi = Screen('GetFlipInterval', ptb.win);

% buffer time (slack) for precise flip
ptb.slack = ptb.ifi * (2/3);

% keyboard entries
ptb.keys.y = KbName('y');
ptb.keys.m = KbName('m');
ptb.keys.ESC = KbName('ESCAPE');
ptb.keys.SPACE = KbName('SPACE');





end