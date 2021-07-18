function fm = mergeFreqModels(verbose, freqModels)
% Merges two FreqModels into one 
% Original models are not affected. 
% 
% PARFMETERS:
% -----------
% verbose   : boolean 
% freqModels : 1D array of FreqModels to be merged

    % there may be duplicates this var hashes.
    % duplicate hashes are dealt with inside FreqModel.trainByFilehash()
    % This is done deliberately so that, we can print 'DUPLICATE' status 
    % in case duplicate hash values are found.
    
    hashes = string.empty; 
    for i = 1 : length(freqModels)
        freqModel = freqModels(i); 
        hashes = [hashes freqModel.hashTrainingFiles]; 
    end 
    
    fm = FreqModel(); 
    fm = fm.trainByFilehash(hashes, verbose);  
end 

