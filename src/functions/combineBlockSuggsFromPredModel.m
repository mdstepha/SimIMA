function suggs = combineBlockSuggsFromPredModel(suggs2D, weights)
% Combines two (or more) lists of BlockSuggs into 1 list, based on their weights, 
% and sorted by rank
% 
% PARAMETERS: 
% -----------
%   - suggs2D (2 D aray of BlockSuggFromPredModel)
%       - Each row shall contain suggestions from 1 group 
%       - To make each 1D array have the same dimension, some suggestions
%         are fake (have confidence = 0). These fake suggestions will be
%         ignored while merging. 
%   - weights (1 D array of floats) 
%       - weights(i) is the weight of suggs2D(i) row group 

    assert(sum(weights) == 1, "combineBlockSuggs.m : Assertion failed -- Sum of all weights must be equal to 1.")
     
    map = struct; % key: blocktypeAsField, value: confidence (based on weighted model)
    
    [rows, cols] = size(suggs2D);     
    for i = 1 : rows
        weight = weights(i); 
        suggsRow = suggs2D(i, :); 
        for j = 1 : cols
            sugg = suggsRow(j);
            % to ignore the fake suggestions which were padded to match the 2D
            % array dimensions, only process those with confidence > 0 
            % To know details, see the caller to this method where we
            % prepare the suggs from each source before merging. 
            if sugg.confidence > 0  
                if ~isfield(map, sugg.blockTypeAsField) 
                    map.(sugg.blockTypeAsField) = weight * sugg.confidence;
                else 
                    map.(sugg.blockTypeAsField) = map.(sugg.blockTypeAsField) +  weight * sugg.confidence;     
                end
            end 
        end 
    end 
    
    suggs = BlockSuggFromPredModel.empty; 
    blockTypesAsFieldSorted = sortStructFieldsMaxToMin(map); % block types sorted by confidence 
        
    for i = 1 : length(blockTypesAsFieldSorted)
        blockTypeAsField = blockTypesAsFieldSorted(i); 
        blockType = convertFieldToBlockType(blockTypeAsField);
        confidence = map.(blockTypeAsField); 
        sugg = BlockSuggFromPredModel(blockType, confidence); 
        suggs = [suggs sugg]; 
    end
end 