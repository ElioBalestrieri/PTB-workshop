function E = movie_dotrial(P, E)


% Get an initial screen flip for timing
vbl = Screen('Flip', E.ptb.win); t1 = GetSecs();

% Start playback of movie. This will start
% the realtime playback clock and playback of audio tracks, if any.
% Play 'movie', at a playbackrate = 1, with endless loop=1 and
% 1.0 == 100% audio volume.
Screen('PlayMovie', E.ptb.movie.movie, P.movierate, 1, 1.0);
Screen('SetMovieTimeIndex', E.ptb.movie.movie, 0);  

nframes = 0;

% possible criteria for setting while loop:
%
% 1. time, based on duration of the movie duration
% while (GetSecs()-t1)<(E.ptb.movie.duration-E.ptb.ifi)
%
% 2. number of frames: 
% nframes_tot = E.ptb.movie.duration*E.ptb.movie.fps;
% while nframes<floor(nframes_tot)
%
% 3. try and error: 
% while nframes<38


while (GetSecs()-t1)<(E.ptb.movie.duration-E.ptb.ifi)

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
    vbl = Screen('Flip', E.ptb.win, vbl-E.ptb.slack);

    % update frame count
    nframes = nframes+1;

    % Release texture (very important to save memory)
    Screen('Close', tex);

end

% compute precise estimate of movie duration
time_elapsed = vbl-t1; fps = nframes/time_elapsed;

% Done. Stop playback:
Screen('PlayMovie', E.ptb.movie.movie, 0);

trialSummary = struct('movie_duration', time_elapsed,'nframes', nframes, ...
                      'fps', fps);

% grey screen again
Screen('FillRect', E.ptb.win, E.ptb.grey);
vbl = Screen('Flip', E.ptb.win);
WaitSecs('YieldSecs', P.timeInterTrial)


if ~isfield(E, 'log')
    E.log = trialSummary;
else
    E.log(end+1) = trialSummary;
end


end