function E = passiveviewing_dotrial(P, E)

% extract current index, image, and image name 
this_idx = P.preallocBlocks{E.iBlock}(E.iTrl);
this_image = P.imgs{this_idx, 2}; img_name = P.imgs{this_idx, 1};

% Make the image into a texture
imageTexture = Screen('MakeTexture', E.ptb.win, this_image);

% Get an initial screen flip for timing
vbl = Screen('Flip', E.ptb.win);

% Draw the image to the screen, unless otherwise specified PTB will draw
% the texture full size in the center of the screen. 
Screen('DrawTexture', E.ptb.win, imageTexture); % , [], [], 0);

% Flip to the screen
vbl  = Screen('Flip', E.ptb.win, vbl + P.timeFace - E.ptb.slack);

% grey screen again
Screen('FillRect', E.ptb.win, E.ptb.grey);
vbl = Screen('Flip', E.ptb.win);


end