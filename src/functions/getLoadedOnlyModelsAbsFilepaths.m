function abspaths = getLoadedOnlyModelsAbsFilepaths()
% Return a list of absolute paths of all loaded (but not open) models.
    loadedPaths = getLoadedModelsAbsFilepaths(); 
    abspaths = string.empty; 
    for i = 1 : length(loadedPaths)
        path = loadedPaths(i); 
        if ~isOpenByAbspath(path)
            abspaths = [abspaths path];  
        end
    end
end 