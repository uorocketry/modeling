function fp()
%% This function will add all subdirectories to the path
%  -> Use it to ensure that all files in any folder under the /modeling
%     folder are found by MatLab
addpath(genpath(pwd));
end