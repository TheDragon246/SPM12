function [subj] = model_space_filenames (subj,new_base_dir)

for s=1:numel(subj)
    for m=1:16
        subj(s).sess(1).model(m).fname = ...
            fullfile(new_base_dir,sprintf('subject%d',s),sprintf('DCM_%d',m));
    end
end