clearvars; sca; clc

% parameters definition
P = npu_doparams();

% start defining the Experiment structure (E) from the ptb (Psychtoolbox)
% subfield
E.ptb = start_ptb(P);

% main experiment struct

for iBlock = 1

    E.iBlock = iBlock;
    for iTrl = 1:10

        E.iTrl = iTrl;

        E = npu_dotrial(P, E);


    end

end


sca