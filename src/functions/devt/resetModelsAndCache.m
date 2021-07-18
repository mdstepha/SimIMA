function resetModelsAndCache()
% Resets both caches and models i.e. 
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
% 
%   - simvma_armCache.mat 
%   - simvma_freqCache.mat  

    resetModels(); 
    
    % We have not defined a separate function 'resetCache', because 
    % resetting cache but not reseting models will bring problem in future 
    % model-merging (as we won't have cache necessary to merge the models).

    setSharedVar('simvma_armCache', struct);
    setSharedVar('simvma_freqCache', struct); 
end 

