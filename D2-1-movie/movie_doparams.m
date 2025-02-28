function P = movie_doparams(P)

%
P.timeFixCross = [1.750, 2.250]; % min-max jitter, in seconds
P.timeFace = .5;
P.timeInterTrial = 1;


% only for debug
P.debugRect = [0, 0, 960, 540];

% movie rate
P.movierate = 1;
P.movieblocking = 1;


%
switch P.movietype

    case 1
        P.moviename = '/home/balestrieri/Projects/PTB-workshop/stims/D2-1/montoya.mp4';
    case 2
        P.moviename = '/home/balestrieri/Projects/PTB-workshop/stims/D2-1/cat.mp4';
    otherwise
        P.moviename = '/home/balestrieri/Projects/PTB-workshop/stims/D2-1/vid_scream -3db.avi';
        

end




end

