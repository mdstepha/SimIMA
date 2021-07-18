function updateDefBlockPredModelsAfterChangesInDefRepos
% This function updates the following shared vars based on 
% current mdl files in default-repo 1 through default-repo 6 folders 
% - simvma_armModelDef_000000.mat
%   ...
% - simvma_armModelDef_111111.mat
% 
% The following custom-block-prediction models are not changed: 
% - simvma_armModelCst.mat 
% - simvma_freqModelCst.mat 
% 
% The following are updated too: 
% - simvma_armModel.mat 
% - simvma_freqModel.mat 

    dispTitle("Updating default block-prediction models using the following state");
    
    state = getSharedVar('simvma_appState'); 
    state = state.setModelFilePathsAndCounts(); 
    setSharedVar('simvma_appState', state); 
    disp(state); 
    
    % Now, we first create separate ArmModels and FreqModels trained on 
    % exactly 1 default repo. Then we merge appropriate models to create
    % all 64 models for both Arm and Freq 
    
    
    % ArmModel trained on 1st Default repo only 
    am1 = ArmModel(); 
    dispTitle("Training armModelDef_100000"); 
    am1 = am1.trainByFilepath(state.abspathsOfMdlSlxInDefRepo1, true); 
    
    % ArmModel trained on 2nd Default repo only 
    am2 = ArmModel(); 
    dispTitle("Training armModelDef_010000"); 
    am2 = am2.trainByFilepath(state.abspathsOfMdlSlxInDefRepo2, true); 
    
    % ArmModel trained on 3rd Default repo only 
    am3 = ArmModel(); 
    dispTitle("Training armModelDef_001000"); 
    am3 = am3.trainByFilepath(state.abspathsOfMdlSlxInDefRepo3, true); 
    
    % ArmModel trained on 4th Default repo only 
    am4 = ArmModel(); 
    dispTitle("Training armModelDef_000100"); 
    am4 = am4.trainByFilepath(state.abspathsOfMdlSlxInDefRepo4, true); 
    
    % ArmModel trained on 5th Default repo only 
    am5 = ArmModel(); 
    dispTitle("Training armModelDef_000010"); 
    am5 = am5.trainByFilepath(state.abspathsOfMdlSlxInDefRepo5, true); 
    
    % ArmModel trained on 6th Default repo only 
    am6 = ArmModel(); 
    dispTitle("Training armModelDef_000001"); 
    am6 = am6.trainByFilepath(state.abspathsOfMdlSlxInDefRepo6, true); 


    % FreqModel trained on 1st Default repo only 
    fm1 = FreqModel(); 
    dispTitle("Training FreqModelDef_100000"); 
    fm1 = fm1.trainByFilepath(state.abspathsOfMdlSlxInDefRepo1, true); 
    
    % FreqModel trained on 2nd Default repo only 
    fm2 = FreqModel(); 
    dispTitle("Training FreqModelDef_010000"); 
    fm2 = fm2.trainByFilepath(state.abspathsOfMdlSlxInDefRepo2, true); 
    
    % FreqModel trained on 3rd Default repo only 
    fm3 = FreqModel(); 
    dispTitle("Training FreqModelDef_001000"); 
    fm3 = fm3.trainByFilepath(state.abspathsOfMdlSlxInDefRepo3, true); 
    
    % FreqModel trained on 4th Default repo only 
    fm4 = FreqModel(); 
    dispTitle("Training FreqModelDef_000100"); 
    fm4 = fm4.trainByFilepath(state.abspathsOfMdlSlxInDefRepo4, true); 
    
    % FreqModel trained on 5th Default repo only 
    fm5 = FreqModel(); 
    dispTitle("Training FreqModelDef_000010"); 
    fm5 = fm5.trainByFilepath(state.abspathsOfMdlSlxInDefRepo5, true); 
    
    % FreqModel trained on 6th Default repo only 
    fm6 = FreqModel(); 
    dispTitle("Training FreqModelDef_000001"); 
    fm6 = fm6.trainByFilepath(state.abspathsOfMdlSlxInDefRepo6, true); 
    
    setSharedVarsForPredModelsTrainedOnDefRepos(am1, am2, am3, am4, am5, am6, fm1, fm2, fm3, fm4, fm5, fm6); 
    
    % update appState  
    state = getSharedVar('simvma_appState'); 
    state.defBlockPredModelsReset = false; 
    setSharedVar('simvma_appState', state); 
    
    % update simvma_armModel.mat and simvma_freqModel.mat 
    updatePredModels(true); 
end 