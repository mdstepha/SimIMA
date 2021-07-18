function initialize()
% This function does the following jobs: 
% 1. determine simvmaPath by searching through all paths; throw error if 
%    the path cannot be determined. 
% 2. save simvmaPath (determined from above job) in 
%    shared-vars/simvmaPath.mat file so that it can be accessed by any 
%    part of the project
% 3. add path of simvma/src to matlab path. 
%    This function will be called before performing any action by all the
%    callback functions so that the functions in simvma/src are always
%    available to use.
% 4. create necessary files/directory structure. this includes: 
%     - <path_simvma>/Simone-2.0-Complete-Cygwin64-customized-for-simvma/mdl-file/
%     - <path_simvma>/Simone-2.0-Complete-Cygwin64-customized-for-simvma/mdl-files/
% 5. if any of the custom repopaths in shared-var simvma_appState is non-existent, 
%    reset it to "". (A custom repo path might be non-existent because of
%    one of the following reasons: )
%    - the user deleted the folder in the machine 
%    - the user copied the project (simvma) from one machine to another
%      where the custom repo path (from source machine) does not exist  
% 6. if task 5 "detects" any change in the custom repos, this function also
%    triggers a corresponding update in block-prediction models.  
% 7. removes any unwanted mdl files immediately inside <path_simvma>/tmp/ 
% 
% ASSUMPTION: simvma path is already added to matlab path (read README.md)

    % task 1, taks 2
    simvmaPath = getSimvmaPath(); 
    
    if boolean(simvmaPath)
        % task 3 
        addpath(simvmaPath + "/src/apps"); 
        addpath(simvmaPath + "/src/classes"); 
        addpath(simvmaPath + "/src/functions"); 
        addpath(simvmaPath + "/src/testfunns"); 
        addpath(simvmaPath + "/src/special-files"); 
        addpath(simvmaPath + "/src/functions/devt"); 
        
        
        % task 4
        dirpaths = [
            simvmaPath + "/Simone-2.0-Complete-Cygwin64-customized-for-simvma/mdl-file", ...
            simvmaPath + "/Simone-2.0-Complete-Cygwin64-customized-for-simvma/mdl-files" ... 
        ]; 
        
        for i = 1 : length(dirpaths)
            dirpath = dirpaths(i); 
            if ~ exist(dirpath, 'dir') 
                mkdir(dirpath); 
            end 
        end  
        
        % task 5
        state = getSharedVar('simvma_appState'); 
        stateCleaned = state.cleanCustomRepoPaths(); 
        setSharedVar('simvma_appState', stateCleaned);
        
        % task 6
        if detectChangesInRepos(state, stateCleaned, true)
            updatePredModels(true); 
        end 
        
        % task 7 
        delete(simvmaPath + "/tmp/*.mdl"); 
        
    else 
        warndlg("SimIMA path coulld not be resolved. Please, read the README.md file and set SimIMA path", "Path not set");
    end
end