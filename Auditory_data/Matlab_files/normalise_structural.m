% List of open inputs
% Normalise: Write: Deformation Field - cfg_files
% Normalise: Write: Images to Write - cfg_files
% Normalise: Write: Deformation Field - cfg_files
% Normalise: Write: Images to Write - cfg_files
nrun = X; % enter the number of runs here
jobfile = {'F:\IDM temporary\fMRI resources\fMRI analysis paper\SPM practice\Auditory data\Matlab files\normalise_structural_job.m'};
jobs = repmat(jobfile, 1, nrun);
inputs = cell(4, nrun);
for crun = 1:nrun
    inputs{1, crun} = MATLAB_CODE_TO_FILL_INPUT; % Normalise: Write: Deformation Field - cfg_files
    inputs{2, crun} = MATLAB_CODE_TO_FILL_INPUT; % Normalise: Write: Images to Write - cfg_files
    inputs{3, crun} = MATLAB_CODE_TO_FILL_INPUT; % Normalise: Write: Deformation Field - cfg_files
    inputs{4, crun} = MATLAB_CODE_TO_FILL_INPUT; % Normalise: Write: Images to Write - cfg_files
end
spm('defaults', 'FMRI');
spm_jobman('run', jobs, inputs{:});
