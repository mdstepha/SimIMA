function buildCache(dirpaths)
% Use this function to add data to shared-vars/freqCache, and 
% shared-vars/armCache. 
% 
% PARAMETERS: 
% -----------
% dirpaths (list of string): list of absolute/relative paths of directories which 
%   contain mdlSlx files. These mdlSlx files may be nested inside inner
%   directories as well. 

    dirpaths = string(dirpaths); 
    mdlSlxPaths = string.empty(); 
    for i = 1 : length(dirpaths) 
        dirpath = dirpaths(i); 
        mdlSlxPaths_ = searchFilesRecursively(dirpath, ["mdl", "slx"]); 
        mdlSlxPaths = [mdlSlxPaths mdlSlxPaths_]; 
    end 

    dispTitle("Building freqCache");
    fm = FreqModel(); 
    fm = fm.trainByFilepath(mdlSlxPaths, true); 

    dispTitle("Building armCache");
    am = ArmModel(); 
    am = am.trainByFilepath(mdlSlxPaths, true); 
end 