function resetModels()
% USE WITH CAUTION
% 
% Resets the following shared vars: 
%   - simvma_armModelCst.mat
%   - simvma_armModelDef_000000.mat
%     ...
%   - simvma_armModelDef_111111.mat
%   - simvma_armModel.mat 
% 
%   - simvma_freqModelCst.mat
%   - simvma_freqModelDef_000000.mat
%     ...
%   - simvma_freqModelDef_111111.mat
%   - simvma_freqModel.mat 

    
    % reset 'final' (those used for prediction by simgestion) pred models 
    setSharedVar('simvma_armModel', ArmModel());
    setSharedVar('simvma_freqModel', FreqModel());
    
    % reset prediction models trained on custom repos 
    setSharedVar('simvma_armModelCst', ArmModel());
    setSharedVar('simvma_freqModelCst', FreqModel());
    
    % reset the pred models trained on all possible combinations of default
    % repos 
    for a = 0 : 1
        for b = 0 : 1
            for c = 0 : 1 
                for d = 0 : 1 
                    for e = 0 : 1
                        for f = 0 : 1 
                            setSharedVar("simvma_armModelDef_" + a + b + c + d + e + f, ArmModel()); 
                            setSharedVar("simvma_freqModelDef_" + a + b + c + d + e + f, FreqModel()); 
                        end 
                    end 
                end 
            end 
        end 
    end
    
    state = getSharedVar('simvma_appState');
    state.defBlockPredModelsReset = true; 
    setSharedVar('simvma_appState', state);
end 