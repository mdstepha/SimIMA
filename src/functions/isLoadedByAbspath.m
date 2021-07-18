function loaded = isLoadedByAbspath(abspath)
% Return true if passed model is loaded, else return false
%
% 
% PARAMETERS:
% -----------
% abspath :  string -- absolute path of model file 


    loaded = false; 
    loadedPaths = getLoadedModelsAbsFilepaths(); 
    realPath = symbolicPathToRealPath(abspath);
    
    for i = 1 : length(loadedPaths)
        if loadedPaths(i) == realPath 
            loaded = true; 
            break; 
        end
    end
end 