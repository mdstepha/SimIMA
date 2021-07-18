function isOpen = isOpenByAbspath(abspath)
% Return true if passed model is open (not just loaded), else return false
%
% 
% PARAMETERS:
% -----------
% abspath :  string -- absolute path of model file 

    [folder_, bdName, ext_] = fileparts(abspath);
    bdName = string(bdName); 
    
    isOpen = false; 
    isLoaded = isLoadedByAbspath(abspath); 
    if isLoaded && get_param(bdName, 'Shown') == "on"
        isOpen = true;
    end 
end 