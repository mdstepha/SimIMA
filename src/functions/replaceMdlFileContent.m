function replaceMdlFileContent(replacedFilepath, replacerFilepath) 
% replace entire content of one mdl file by that of another 
% 
% The name of top-level system will still be preserved (i.e. it will still 
% match replaced's filename)
% 
% The replacement works irrespective of whether the file to be replaced is 
% open/loaded in Simulink, and the state (closed/open/loaded) is preserved.
%
% PARAMETERS:
% -----------
% replacedFilepath : string -- absolute path of the mdl file whose content 
%                    is to be replaced 
% replacerFilepath : string -- absolute path of the mdl file whose content 
%                    will replace the replaced mdl's content
% 
% ASSUMPTIONS:
% ------------
% - provided filepaths are valid 

    [folder_, bdName, ext_] = fileparts(replacedFilepath);
    bdName = string(bdName); 
    
    isLoaded = bdIsLoaded(bdName); 
    
    % a block-diagram (bd) is considered 'open' if it is not just loaded, 
    % but actually OPENED. The window of an opened bd may be minimized; 
    % that does not matter. 
    
    if isLoaded && get_param(bdName, 'Shown') == "on"
        isOpen = true; 
    else 
        isOpen = false;
    end 
    
    % replace content. 
    % in doing so, preserve the state (closed/loaded/open, window position) 
    if isOpen 
        % re-opening the mdl file at the same location (on screen) is tricky
        % after replacement is done, DON'T open directly, 
        % rather, load the model first, restore the location, and then open
        % if the model is directly opened (without loading), the focus will
        % be in (sub)system rather than top level system (if such
        % sub-system exists after replacement), as a result set_param(...,
        % 'location' won't show effect 
        
        loc = get_param(bdName, 'location');  
        save_system(replacedFilepath); 
        close_system(replacedFilepath); 
        replaceContent(replacedFilepath, replacerFilepath); 
        
        load_system(replacedFilepath);  % IMPORTANT: don't open_model directly 
        set_param(bdName, 'location', loc); 
        save_system(replacedFilepath); 
        open_system(replacedFilepath); 
        save_system(replacedFilepath);  % required to restore original top-system name 

    elseif isLoaded
        save_system(replacedFilepath); 
        close_system(replacedFilepath); 
        replaceContent(replacedFilepath, replacerFilepath); 
        load_system(replacedFilepath);
        save_system(replacedFilepath);  % required to restore original top-system name 
    
    else 
        replaceContent(replacedFilepath, replacerFilepath); 
        % load, save, close (to ensure that top-system's name gets changed
        % to replaced's filename, otherwise top-system's name will be the
        % one copied from replacer's content. (this won't be an issue, but
        % we still want to have consistency between model's name and top
        % system's name. 
        load_system(replacedFilepath); 
        save_system(replacedFilepath); 
        close_system(replacedFilepath); 
    end 
end 


function replaceContent(replacedFilepath, replacerFilepath)
    if ispc
        cmd =  getCygwinPath() + "/bin/cat " + replacerFilepath + " > " + replacedFilepath; 
    else
        cmd = "cat " + replacerFilepath + " > " + replacedFilepath; 
    end 
    unix(cmd); 
end 