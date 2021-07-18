function updatePredModels(verbose)
% This function updates the following shared vars, based on the shared var 
% 'simvma_appState'. 
% - simvma_freqModel 
% - simvma_armModel
% 
% This function does not update the prediction models trained on default
% repos (eg. simvma_armModelDef_100000) unless app.defBlockPredModelsReset
% is set to true. 
% 
% This function is called from inside appSimgestion, appSimxample, 
% 
% 
% PARAMETERS:
% -----------
% verbose (bool) : If true, details are printed
% 
% ASSUMPTIONS: 
% ------------
% default prediction models (stored in shared vars) are already 
% updated (using updateDefBlockPredModelsAfterChangesInDefRepos() ) 
% 
% IMPORTANT: 
% ----------
% This function DOES NOT update the default models i.e. 
% (for example, simvma_armModelDef_010000.mat) when there is a change in mdl 
% files in the default-repos folder. To achieve that functionality we have
% another function named updateDefBlockPredModelsAfterChangesInDefRepos().
% That function is in src/functions/devt (as it is to be used during
% development time only because "default-repos" folder is fixed after
% development, and so this function is not necessary at production time) 
% 
% This function DOES NOT (and CAN NOT) check if there has been a "change" 
% in the repositories (both default and custom). So, this function ALWAYS
% updates the prediction models (i.e. simvma_freqModel and
% simvma_armModel). Such check cannot be performed inside this function
% because 'previous' appState is not available here. Therefore, such 
% check must be performed in the caller environment (before invoking this 
% function) to avoid unnecessary updating of the prediction models (which
% does take considerable time). 

    if verbose dispTitle("Updating PredModels"); end 
    
    % appState is set before invoking this function from 
    % appAdmin. So, calling getSharedVar() here gives the recent 
    % changes made by user from UI, if any.
    state = getSharedVar('simvma_appState'); 
    
    % if default block-prediction-models are in 'reset' state, 
    % train them now 
    if state.defBlockPredModelsReset
        disp("Standard Block Prediction models were found to have been reset.");
        disp("Training them now...");
        % this function also unsets the flag state.defBlockPredModelsReset 
        updateDefBlockPredModelsAfterChangesInDefRepos(); 
    end
    
    % get all mdl/slx files' path from all custom repos
    mdlSlxPaths = string.empty; 
    for i = 1 : 5
       cstRepoPath = state.("cstRepoPath" + i); 
       if ~strcmp(cstRepoPath, "")
           mdlSlxPaths = [mdlSlxPaths searchFilesRecursively(cstRepoPath, ["mdl", "slx"])];
       end
    end
    
    
    % HANDLE ARM MODEL
    
    % construct the shared var name (eg: simvma_armModelDef_010000) for 
    % required ArmModel (the one trained on checked default repos only)
    am = "simvma_armModelDef_"; 
    for i = 1 : 6
       if state.("defRepo" + i + "Checked")
           am = am + 1; 
       else 
           am = am + 0;
       end 
    end
    armModelDef = getSharedVar(am); 
    
    % ArmModel trained on all custom repositories 
    armModelCst = ArmModel(); 
    if ~isempty(mdlSlxPaths)
        armModelCst = armModelCst.trainByFilepath(mdlSlxPaths, verbose);  
    end 

    armModel = mergeArmModels(false, [armModelCst, armModelDef]); 
    setSharedVar('simvma_armModel', armModel); 
    
    
    % HANDLE FREQ MODEL
    
     % construct the shared var name (eg: simvma_freqModelDef_010000) for 
    % required FreqModel (the one trained on checked default repos only)
    fm = "simvma_freqModelDef_"; 
    for i = 1 : 6
       if state.("defRepo" + i + "Checked")
           fm = fm + 1; 
       else 
           fm = fm + 0;
       end 
    end
    freqModelDef = getSharedVar(fm); 
    
    % FreqModel trained on all custom repositories 
    freqModelCst = FreqModel(); 
    if ~isempty(mdlSlxPaths)
        freqModelCst = freqModelCst.trainByFilepath(mdlSlxPaths, verbose);  
    end
    
    freqModel = mergeFreqModels(false, [freqModelCst, freqModelDef]);
    setSharedVar('simvma_freqModel', freqModel); 
end 