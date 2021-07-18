function loadedModelsAbsFilepaths = getLoadedModelsAbsFilepaths()
% Return a list of absolute paths of all loaded models. 
% IMPORTANT:
% ----------
%   this returns the absolute "real"path (even if symlink is used to load
%   the model) 
    loadedModelsAbsFilepaths = string(get_param(Simulink.allBlockDiagrams(), 'FileName')); 
end 