clearvars; sca; clc;

P = basics_doparams();
E = [];

for iBlock = 1:P.nBlocks

    E.iBlock = iBlock;

    for iTrial = 1:P.nTrialsXblock

        E.iTrial = iTrial;
        E = basics_dotrial(P, E);

    end

end

log = struct2table(E.log);
writetable(log, 'logfile.csv')
