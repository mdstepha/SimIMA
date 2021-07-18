function field = convertBlockTypeToField(blockType)
% Convert blockType (str) to a string compatible to be used as a fieldname
% in a struct.
% 
% THE REVERSE ACTION IS PERFORMED BY field2BlockType() 
%
% PARAMETERS:
% -----------
%   blockType(str): BlockType of a block (obtained in its params)

    field = blockType; 
    field = strrep(field, '-', '__dash__'); 
end 