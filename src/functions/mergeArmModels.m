function am = mergeArmModels(verbose, armModels)
% Merges two ArmModels into one 
% Original models are not affected. 
% 
% PARAMETERS:
% -----------
% verbose   : boolean 
% armModels : 1D array of ArmModels to be merged

    % there may be duplicates this var hashes.
    % duplicate hashes are dealt with inside ArmModel.trainByFilehash()
    % This is done deliberately so that, we can print 'DUPLICATE' status 
    % in case duplicate hash values are found.
    
    hashes = string.empty; 
    for i = 1 : length(armModels)
        armModel = armModels(i); 
        hashes = [hashes armModel.hashTrainingFiles]; 
    end 
    
    am = ArmModel(); 
    am = am.trainByFilehash(hashes, verbose);  
end 

