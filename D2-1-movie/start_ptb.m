function ptb = start_ptb(P)

screens = Screen('Screens');

% Define black and white
ptb.white = WhiteIndex(max(screens));
ptb.black = BlackIndex(max(screens));
ptb.grey = ptb.white/2; 

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

% [movie, movieduration, fps, imgw, imgh, ~, ~, hdrStaticMetaData] = Screen('OpenMovie', win, moviename, [], preloadsecs, [], pixelFormat, maxThreads, movieOptions);

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





end