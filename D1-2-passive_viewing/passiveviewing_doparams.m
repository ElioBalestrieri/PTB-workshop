function P = passiveviewing_doparams()

%
P.timeFixCross = [1.750, 2.250]; % min-max jitter, in seconds
P.timeFace = .5;

% stim size (VA)
P.stimVA.FIX_extent = 1;
P.stimVA.FIX_thick  = .15;

% only for debug
P.debugRect = [0, 0, 960, 540];

% screen size
P.screenSize_m_XY = [344 193]; % fullscreen laptop; fullscreen office [528, 297]; 

% subject distance from screen
P.dist_subj = 600; % mm


% load images as RGB matrices & assign them to their filenames in a P cell
input_dir = '/home/elio/postDoc/PTB-workshop/stims/D1-2'; % remember to change for the current machine
fulllist = dir(input_dir); filelist = {fulllist(~[fulllist.isdir]).name}';
nImages = length(filelist); % length yields the number of entries along the longest dimension, use it cautiously with matrices...
for iFace = 1:nImages
    filelist{iFace, 2} = imread(fullfile(input_dir, filelist{iFace, 1})); 
end
P.imgs = filelist;

% define batches of images such as each face is only represented once in
% the batch, but each batch features a shuffled order of images. 
% N batch = N reps of images
% BUT! batch ~= block. One block can be composed of different batches. The
% opposite can also be true, but I would not recommend so: better leave the
% structure as modular as possible, such that each block should be an exact
% miniature of the experiment, where all the conditions & stimuli are
% represented correctly

% define number of repetitions per image
P.nReps = 4;

% number of blocks
P.nBlocks = 2; % 2 repetition of each image in each block. 

P.preallocBlocks = cell(P.nBlocks, 1);
tmp_ = [];
for iBatch = 1:P.nReps

    tmp_ = [tmp_; randperm(nImages)'];

    if mod(iBatch, P.nBlocks)==0
        P.preallocBlocks{iBatch/P.nBlocks} = tmp_;
        tmp_ = [];
    end

end


end

