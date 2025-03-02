function E = passiveviewing_dotrial(P, E)

% determine ITI jitter
possibleJitters = P.timeFixCross(1):E.ptb.ifi:P.timeFixCross(2);
timeFixCross = possibleJitters(randi(length(possibleJitters)));

% extract current index, image, and image name 
this_idx = P.preallocBlocks{E.iBlock}(E.iTrl);
this_image = P.imgs{this_idx, 2}; img_name = P.imgs{this_idx, 1};

% Make the image into a texture
imageTexture = Screen('MakeTexture', E.ptb.win, this_image);

% shortcut to center definition
Xc = E.ptb.cntr.X; Yc = E.ptb.cntr.Y;

% define fixation
XY_horbar = [Xc-E.ptb.stimPIX.FIX_extent/2, Yc-E.ptb.stimPIX.FIX_thick/2, ...
    Xc+E.ptb.stimPIX.FIX_extent/2, Yc+E.ptb.stimPIX.FIX_thick/2];
XY_verbar = [Xc-E.ptb.stimPIX.FIX_thick/2, Yc-E.ptb.stimPIX.FIX_extent/2, ...
    Xc+E.ptb.stimPIX.FIX_thick/2, Yc+E.ptb.stimPIX.FIX_extent/2];

% draw fixation
Screen('FillRect', E.ptb.win, E.ptb.grey)
Screen('FillRect', E.ptb.win, E.ptb.white, XY_horbar)
Screen('FillRect', E.ptb.win, E.ptb.white, XY_verbar)


% Get an initial screen flip for timing
vbl_start = Screen('Flip', E.ptb.win);

% Draw the image to the screen, unless otherwise specified PTB will draw
% the texture full size in the center of the screen. 
Screen('DrawTexture', E.ptb.win, imageTexture); % , [], [], 0);

% Flip to the screen
vbl_fix  = Screen('Flip', E.ptb.win, vbl_start + timeFixCross - E.ptb.slack);

% grey screen again
Screen('FillRect', E.ptb.win, E.ptb.grey);

% Flip to the screen
vbl_face  = Screen('Flip', E.ptb.win, vbl_fix + P.timeFace - E.ptb.slack);
% vbl = Screen('Flip', E.ptb.win);

% log 
trialSummary = struct('fix_duration', vbl_fix-vbl_start ,...
                      'face_duration', vbl_face-vbl_fix);

if ~isfield(E, 'log')
    E.log = trialSummary;
else
    E.log(end+1) = trialSummary;
end





end