classdef BlockSuggFromPredModel
    properties
        blockType            % string: BlockType of suggested block 
        blockTypeAsField     % string: BlockType compatible to be used as a 'field' of a struct 
        confidence           % double in range [0,1] : prediction confidence for the block
    end 
    
    methods 
        function obj = BlockSuggFromPredModel(blockType, confidence)
            obj.blockType = string(blockType);
            obj.blockTypeAsField = convertBlockTypeToField(obj.blockType); 
            obj.confidence = confidence;
        end 
    end
end 