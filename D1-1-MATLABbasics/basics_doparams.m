function P = basics_doparams()

P.jitterTime = .6; % seconds
P.killTrialTime = 1.5; % seconds
P.nBlocks = 3;
P.nTrialsXblock = 4;
P.expConds = {'left', 'right'}';
P = local_preallocate_conds(P);

% keys definition
P.leftKey = KbName('y');
P.rightKey = KbName('m');

end

%% ################### LOCAL FUNCTIONS

function P = local_preallocate_conds(P)
% TASK: create a function that preallocates experimental conditions in a
% balanced fashion for each block. This function should:

% 1. check that the number of trials x block is adequate to contain all the
% experimental conditions in equal number (HINT: see function "mod")
% 2. for each block, create a cell of experimental conditions with the
% expected number of trialsXblock (HINT: see function "repmat")
% 3. randomize order of trials (HINT: generate random indexes with
% "randperm")


nLeftOut = mod(P.nTrialsXblock, length(P.expConds));

if nLeftOut~=0
    error('number of experimental conditions incompatible with trialsXblock')
else
    nRepsCond = P.nTrialsXblock/length(P.expConds);
end

for iBlock = 1:P.nBlocks

    tmp_ = repmat(P.expConds, nRepsCond, 1);
    rnd_idxs = randperm(P.nTrialsXblock);
    P.preallocBlocks{iBlock} = tmp_(rnd_idxs);

end

end