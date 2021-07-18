classdef BlockSugg 
    properties
        blockType            % string: BlockType of suggested block 
        blockTypeAsField     % string: BlockType compatible to be used as a 'field' of a struct 
        libPath              % string: Simulink library path; eg: built-in/Sum
        rank                 % double: (1:highest)   : suggestion's rank 
        confidence           % double in range [0,1] : prediction confidence for the block
        blockName            % string: block's name; eg: Add1
        blockPath            % string: block's path as would be returned by gcb; eg: x/y/z/Add1
        foregroundColor      % string: foreground color of the suggestion block (when displayed in simulink workspace)
        backgroundColor      % string: background color of the suggestion block (when displayed in simulink workspace)
    end 
    
    methods 
        function obj = BlockSugg(blockType, rank, confidence, blockName, blockPath)
            blockType = string(blockType);
            obj.blockType = blockType; 
            obj.blockTypeAsField = convertBlockTypeToField(blockType); 
            obj.libPath = getSimulinkLibPathByBlockType(blockType); 
            obj.rank = rank;
            obj.confidence = confidence; 
            obj.blockName = blockName; 
            obj.blockPath = blockPath; 
            obj.foregroundColor = "black"; 
            obj.backgroundColor = "white"; 
           
        end
    end 
end 

function libpath = getSimulinkLibPathByBlockType(blockType)
    libpath = "built-in/" + blockType; 
end 