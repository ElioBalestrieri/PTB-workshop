function E = npu_dotrial(P, E)

% determine ITI jitter
possibleJitters = P.timeFixCross(1):E.ptb.ifi:P.timeFixCross(2);
timeFixCross = possibleJitters(randi(length(possibleJitters)));

% shortcut to center definition
Xc = E.ptb.cntr.X; Yc = E.ptb.cntr.Y;

% define fixation
XY_horbar = [Xc-E.ptb.stimPIX.FIX_extent/2, Yc-E.ptb.stimPIX.FIX_thick/2, ...
    Xc+E.ptb.stimPIX.FIX_extent/2, Yc+E.ptb.stimPIX.FIX_thick/2];
XY_verbar = [Xc-E.ptb.stimPIX.FIX_thick/2, Yc-E.ptb.stimPIX.FIX_extent/2, ...
    Xc+E.ptb.stimPIX.FIX_thick/2, Yc+E.ptb.stimPIX.FIX_extent/2];

% extract current event type 
switch P.events(E.iTrl).event
    
    case 'face'
        
        this_image = P.events(E.iTrl).RGB_array;
        img_name = P.events(E.iTrl).detail;
        face_type = P.events(E.iTrl).type;
        
        % Make the image into a texture
        imageTexture = Screen('MakeTexture', E.ptb.win, this_image);

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
        trialSummary = struct('fix_duration', vbl_fix - vbl_start,...
                              'face_duration', vbl_face - vbl_fix, ...
                              'face_code', img_name, ...
                              'type', face_type, ...   
                              'movie_duration', nan, ...
                              'fps', nan, ...
                              'nframes_movie', nan);
                          
    case 'movie'
        
        % draw fixation
        Screen('FillRect', E.ptb.win, E.ptb.grey)
        Screen('FillRect', E.ptb.win, E.ptb.white, XY_horbar)
        Screen('FillRect', E.ptb.win, E.ptb.white, XY_verbar)

        % Get an initial screen flip for timing
        vbl_start = Screen('Flip', E.ptb.win);

        % Flip to the screen
        vbl_fix  = Screen('Flip', E.ptb.win, vbl_start + timeFixCross - E.ptb.slack);        

        % Start playback of movie. This will start
        % the realtime playback clock and playback of audio tracks, if any.
        % Play 'movie', at a playbackrate = 1, with endless loop=1 and
        % 1.0 == 100% audio volume.
        Screen('PlayMovie', E.ptb.movie.movie, P.movierate, 1, 1.0);
        Screen('SetMovieTimeIndex', E.ptb.movie.movie, 0);  

    nframes = 0;
    while (GetSecs()-vbl_fix)<(E.ptb.movie.duration-E.ptb.ifi)

        tex = Screen('GetMovieImage', E.ptb.win, E.ptb.movie.movie, P.movieblocking);

        % Valid texture returned?
        if tex<0
            % No, and there won't be any in the future, due to some error (or 
            % movie end. Abort playback loop:
            break
        end

        if tex == 0
            % No new frame in polling wait (blocking == 0). Just sleep
            % a bit and then retry.
            WaitSecs(.005);
            continue;
        end

        % Draw the new texture immediately to screen:
        Screen('DrawTexture', E.ptb.win, tex) % , [], dstRect, [], [], [], [], shader);
        if nframes == 0        
            vbl = Screen('Flip', E.ptb.win, vbl_fix-E.ptb.slack);
        else
            vbl = Screen('Flip', E.ptb.win, vbl-E.ptb.slack);
        end
            
        % update frame count
        nframes = nframes+1;

        % Release texture (very important to save memory)
        Screen('Close', tex);

    end

    % compute precise estimate of movie duration
    time_elapsed = vbl-vbl_fix; fps = nframes/time_elapsed;

    % Done. Stop playback:
    Screen('PlayMovie', E.ptb.movie.movie, 0);

    % log 
    trialSummary = struct('fix_duration', vbl_fix - vbl_start,...
                          'face_duration', nan, ...
                          'face_code', nan, ...
                          'type', nan, ...   
                          'movie_duration', time_elapsed, ...
                          'fps', fps, ...
                          'nframes_movie', nframes);        

end
                      
if ~isfield(E, 'log')
    E.log = trialSummary;
else
    E.log(end+1) = trialSummary;
end





end