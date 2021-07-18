function loaded = isLoadedByModelName(modelName)
% Return true if any of the loaded models has the same name as the passed
% model name, else return false
%
% 
% PARAMETERS:
% -----------
% modleName (string/char) -- model name (as would be returned by gcs)

    modelName = string(modelName);  % cannot be char

    loaded = false; 
    % this returns the absolute "real"path (even if symlink is used to load
    % the model) 
    loadedMdls = get_param(Simulink.allBlockDiagrams(), 'Name');
    for i = 1 : length(loadedMdls)
        if loadedMdls(i) == modelName 
            loaded = true; 
        end
    end
end 