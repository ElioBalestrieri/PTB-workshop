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


% Open movie file and retrieve basic info about movie:
[movie, movieduration, fps, ...
 imgw, imgh, ~, ~, ...
 hdrStaticMetaData] = Screen('OpenMovie', ptb.win, P.moviename);

ptb.movie.movie = movie;
ptb.movie.duration = movieduration;
ptb.movie.fps = fps;
ptb.movie.imgw = imgw;
ptb.movie.imgh = imgh;
ptb.movie.hdrStaticMetaData = hdrStaticMetaData;



%% convert from visual angles to pixels
% nice explanation at https://elvers.us/perception/visualAngle/va.html


% get an estimate of the size of each mm in pixels

% IMPORTANT! this size estimation is based ON THE WINDOW ACTUALLY OPENED
% in our debug window, it will be not consisternt with the actual size
pixDIVmm = mean(ptb.winRect(3:4)./P.screenSize_m_XY); 

% anonymous function for conversion dva -> pixels
dva2PIX = @(xdeg) round(2*P.dist_subj*tand(xdeg/2)*... V = 2*arctan(S/2D) --> S = 2*D*tan(V/2)
                        pixDIVmm); % this is to pass from mm2PIX
% convert va in pixels
% apply anonymous function to the stim substructure
ptb.stimPIX = structfun(dva2PIX, P.stimVA, 'UniformOutput', 0);


end