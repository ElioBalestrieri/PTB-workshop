function P = npu_doparams()

P.subjID = strtrim(input('\nInsert Participant code:', 's'));
P.expType = strtrim(input('\nInsert experiment type [N/P/U]:', 's'));

%
P.timeFixCross = [1.750, 2.250]; % min-max jitter, in seconds
P.timeFace = .5;

% moviename
P.moviename = '/home/elio/postDoc/PTB-workshop/stims/D2-1/vid_scream -3db.avi';
% movie rate
P.movierate = 1;
P.movieblocking = 0;


% stim size (VA)
P.stimVA.FIX_extent = 1;
P.stimVA.FIX_thick  = .15;

% only for debug
P.debugRect = [0, 0, 960, 540];

% screen size
P.screenSize_m_XY = [344 193]; % fullscreen laptop; fullscreen office [528, 297]; 

% subject distance from screen
P.dist_subj = 600; % mm

% face types (f/m, fea/neu)
P.faceTypeGender = {'f', 'm'};
P.faceTypeEmo = {'fea', 'neu'};


% load images as RGB matrices & assign them to their filenames in a P cell
input_dir = '/home/elio/postDoc/PTB-workshop/stims/D1-2'; % remember to change for the current machine
fulllist = dir(input_dir); filelist = {fulllist(~[fulllist.isdir]).name}';
nImages = length(filelist); % length yields the number of entries along the longest dimension, use it cautiously with matrices...
for iFace = 1:nImages
    filelist{iFace, 2} = imread(fullfile(input_dir, filelist{iFace, 1})); 
end

% split images in three groups. the subset selected contains 76 images, so
% quickly cheat and prune the set to make it splittable in 3 subgroups
filelist = filelist(1:72, :);

%IMPORTANT! indexes should be assigned only once, at the first experimental
%call (N)

if P.expType == 'N'
    shuffld_idxs = randperm(72);
    save([P.subjID, '_shuffld_img_idxs.mat'], 'shuffld_idxs') % ideally, in a subject-specific datafolder
else
    load([P.subjID, '_shuffld_img_idxs.mat'], 'shuffld_idxs');
end


% generate all posibble combinations of gender/emotion. We need to do a
% loop for MATLAB versions <2023a (after that, check "combinations"
% function

coreCombs = cell(length(P.faceTypeGender)*length(P.faceTypeEmo), 3);

acc_comb = 0;
for iGender = 1:length(P.faceTypeGender)
    
    for iEmo = 1:length(P.faceTypeEmo)
        
        acc_comb = acc_comb+1;
        coreCombs{acc_comb, 1} = P.faceTypeGender{iGender};
        coreCombs{acc_comb, 2} = P.faceTypeEmo{iEmo};
        coreCombs{acc_comb, 3} = 'safe';
        
        
    end
    
end

% preallocate modules in the three exp conds
tmpl = repmat(coreCombs, 4, 1);
[N_conds, U_conds, P_conds] = deal(tmpl);

% change entries from safe to threat in N & U
U_conds(1:8, 3) = {'threat'};
P_conds(1:8, 3) = {'threat'};

% merge conds together, and assign filenames to them
cellConds = {N_conds, P_conds, U_conds};

duplicate_fnames = filelist(:, 1);
for iCond = 1:3
    
    thisCond = cellConds{iCond};
    
    for iTrial = 1:length(thisCond)
                
        tmp_fname = [thisCond{iTrial, 2}, '_', thisCond{iTrial, 1}];
        mask_name = cellfun(@(x) contains(x, tmp_fname), duplicate_fnames);
        
        idxs_name = Shuffle(find(mask_name));
        this_idx = idxs_name(1);
        thisCond{iTrial, 4} = this_idx;
        duplicate_fnames{this_idx} = 'NOTAVAILABLE';
        
    end
    
    cellConds{iCond} = thisCond;
    
end


%% experimental preallocation
% diversified based conditional on the experimental phase

% IMPORTANT: THIS PREALLOCATION IS JUST A PROOF OF CONCEPT!
% right now, different faces are shown in the 3 conditions, but they are
% not counterbalanced for identity, race, gender, or whichever other
% parameter might be of interest.

switch P.expType
    
    case 'N'
        
        thisCond = cellConds{1};
        idxs_safe =  cell2mat(thisCond(:, end))'; %  shuffld_idxs(1:24);        
        
        for iFace = idxs_safe
        
            if ~isfield(P, 'events')
                P.events = struct('event', 'face', 'type', 'safe', ...
                                 'detail',  filelist{iFace, 1}, ...
                                 'RGB_array', filelist{iFace, 2});
            else
                P.events(end+1) = struct('event', 'face', 'type', 'safe', ...
                                        'detail',  filelist{iFace, 1}, ...
                                        'RGB_array', filelist{iFace, 2});
            end
            
        end
        
    case 'U'
        
        thisCond = cellConds{3};
        idxs_all =  cell2mat(thisCond(:, end)); %  shuffld_idxs(1:24);        

        mask_safe = cellfun(@(x) strcmp(x, 'safe'), thisCond(:, 3));
        mask_threat = ~mask_safe;
        
        idxs_threat = idxs_all(mask_threat)';
        idxs_safe = idxs_all(mask_safe)';
        
        acc_safe = 0;
        for iFace = idxs_safe
        
            acc_safe = acc_safe+1;
            
            if mod(acc_safe, 5)==0
                
                % add 4 faces from the threat batch
                for iThreatFace = idxs_threat(1:3) % every 4 images?
                
                    P.events(end+1) =  struct('event', 'face', ...
                                             'type', 'threat', ...
                                             'detail',  filelist{iThreatFace, 1}, ...
                                             'RGB_array', filelist{iThreatFace, 2});
                end
                
                % add movie
                P.events(end+1) =  struct('event', 'movie', ...
                         'type', 'threat', ...
                         'detail',  'moviename', ...
                         'RGB_array', nan);

                % add the last image
                iThreatFace = 5;
                P.events(end+1) =  struct('event', 'face', ...
                                         'type', 'threat', ...
                                         'detail',  filelist{iThreatFace, 1}, ...
                                         'RGB_array', filelist{iThreatFace, 2});
                
                % since we don't want to repeat the threat faces, erase
                % them from the batch
                idxs_threat(1:5) = [];
                
            end    
            
            if ~isfield(P, 'events')
                P.events = struct('event', 'face', 'type', 'safe', ...
                                  'detail',  filelist{iFace, 1}, ...
                                  'RGB_array', filelist{iFace, 2});
            else
                P.events(end+1) = struct('event', 'face', 'type', 'safe', ...
                                         'detail',  filelist{iFace, 1}, ...
                                         'RGB_array', filelist{iFace, 2});
            end
            
        end

        
        
    case 'P'

        idxs_threat = shuffld_idxs(49:58);
        idxs_safe = shuffld_idxs(59:72);
        
        
        % repeat U, but by adding a warning image before the threat
        % sequence
        
end



end






