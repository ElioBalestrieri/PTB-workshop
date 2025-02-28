clearvars; sca; clc

P.movietype = input('which movie? [1/2]: ');

% parameters definition
P = movie_doparams(P);

% start defining the Experiment structure (E) from the ptb (Psychtoolbox)
% subfield
E.ptb = start_ptb(P);

% main experiment struct

for iBlock = 1

    E.iBlock = iBlock;
    for iTrl = 1:6

        E.iTrl = iTrl;

        E = movie_dotrial(P, E);

        disp(iTrl)

    end

end


sca