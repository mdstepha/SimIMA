function blockType = convertFieldToBlockType(field)
% Convert field (str) to a the original blockType string. The field string
% was made by making some string replacements using convertBlockTypeToField()
% function 
% 
% THE REVERSE ACTION IS PERFORMED BY field2BlockType() 
%
% PARAMETERS:
% -----------
%   blockType(str): BlockType of a block (obtained in its params)

    blockType = field; 
    blockType = strrep(blockType, '__dash__', '-'); 
end 

