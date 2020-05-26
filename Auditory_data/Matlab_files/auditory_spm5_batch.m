% This batch script analyses the Auditory fMRI dataset available from the SPM site:
% http://www.fil.ion.ucl.ac.uk/spm/data/auditory/
% as described in the manual Chapter 28.

% Copyright (C) 2008 Wellcome Trust Centre for Neuroimaging

% Guillaume Flandin
% $Id: auditory_spm5_batch.m 30 2008-05-20 11:16:55Z guillaume $

%% Path containing data
%--------------------------------------------------------------------------
data_path = 'C:\work\data\auditory';

%% Set Matlab path
%--------------------------------------------------------------------------
addpath('C:\work\spm5');
addpath('C:\work\misc'); % directory containing editfilenames.m

%% Initialise SPM defaults
%--------------------------------------------------------------------------
spm('Defaults','fMRI');

spm_jobman('initcfg'); % useful in SPM8 only

%% WORKING DIRECTORY (useful for .ps only)
%--------------------------------------------------------------------------
clear jobs
jobs{1}.util{1}.cdir.directory = cellstr(data_path);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SPATIAL PREPROCESSING
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Select functional and structural scans
%--------------------------------------------------------------------------
f = spm_select('FPList', fullfile(data_path,'fM00223'), '^f.*\.img$') ;
a = spm_select('FPList', fullfile(data_path,'sM00223'), '^s.*\.img$') ;

%% REALIGN
%--------------------------------------------------------------------------
jobs{2}.spatial{1}.realign{1}.estwrite.data{1} = cellstr(f);

%% COREGISTER
%--------------------------------------------------------------------------
jobs{2}.spatial{2}.coreg{1}.estimate.ref = editfilenames(f(1,:),'prefix','mean');
jobs{2}.spatial{2}.coreg{1}.estimate.source = cellstr(a);

%% SEGMENT
%--------------------------------------------------------------------------
jobs{2}.spatial{3}.preproc.data = cellstr(a);

%% NORMALIZE
%--------------------------------------------------------------------------
jobs{2}.spatial{4}.normalise{1}.write.subj.matname  = editfilenames(a,'suffix','_seg_sn','ext','.mat');
jobs{2}.spatial{4}.normalise{1}.write.subj.resample = editfilenames(f,'prefix','r');
jobs{2}.spatial{4}.normalise{1}.write.roptions.vox  = [3 3 3];

jobs{2}.spatial{4}.normalise{2}.write.subj.matname  = editfilenames(a,'suffix','_seg_sn','ext','.mat');
jobs{2}.spatial{4}.normalise{2}.write.subj.resample = editfilenames(a,'prefix','m');
jobs{2}.spatial{4}.normalise{2}.write.roptions.vox  = [1 1 3];

%% SMOOTHING
%--------------------------------------------------------------------------
jobs{2}.spatial{5}.smooth.data = editfilenames(f,'prefix','wr');
jobs{2}.spatial{5}.smooth.fwhm = [6 6 6];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CLASSICAL STATISTICAL ANALYSIS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% OUTPUT DIRECTORY
%--------------------------------------------------------------------------
jobs{3}.util{1}.md.basedir = cellstr(data_path);
jobs{3}.util{1}.md.name = 'classical';

%% MODEL SPECIFICATION AND ESTIMATION
%--------------------------------------------------------------------------
jobs{4}.stats{1}.fmri_spec.dir = cellstr(fullfile(data_path,'classical'));
jobs{4}.stats{1}.fmri_spec.timing.units = 'scans';
jobs{4}.stats{1}.fmri_spec.timing.RT = 7;
jobs{4}.stats{1}.fmri_spec.sess.scans = editfilenames(f(13:end,:),'prefix','swr');
jobs{4}.stats{1}.fmri_spec.sess.cond.name = 'active';
jobs{4}.stats{1}.fmri_spec.sess.cond.onset = 6:12:84;
jobs{4}.stats{1}.fmri_spec.sess.cond.duration = 6;

jobs{4}.stats{2}.fmri_est.spmmat = cellstr(fullfile(data_path,'classical','SPM.mat'));

%% INFERENCE
%--------------------------------------------------------------------------
jobs{4}.stats{3}.con.spmmat = cellstr(fullfile(data_path,'classical','SPM.mat'));
jobs{4}.stats{3}.con.consess{1}.tcon = struct('name','active > rest','convec', 1,'sessrep','none');
jobs{4}.stats{3}.con.consess{2}.tcon = struct('name','rest > active','convec',-1,'sessrep','none');

jobs{4}.stats{4}.results.spmmat = cellstr(fullfile(data_path,'classical','SPM.mat'));
jobs{4}.stats{4}.results.conspec.contrasts = Inf;
jobs{4}.stats{4}.results.conspec.threshdesc = 'FWE';

%% RENDERING
%--------------------------------------------------------------------------
jobs{5}.util{1}.spm_surf.data = editfilenames([a;a],'prefix',{'c1' 'c2'});

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% FINISH
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
save('auditory_batch.mat','jobs');
spm_jobman('interactive',jobs); % open a GUI containing all the setup
%spm_jobman('run',jobs);        % execute the batch
