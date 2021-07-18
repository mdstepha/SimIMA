function map = getConnectedBlockTypesWithCountByBlockHandle(blockHandle, connectionType)
% Return a map such that the key is BlockType and value is count. Each 
% entry in the map corresponds to an immediately connected block. 
%
% RAISES_ERROR: Since this function is not guaranteed to succeed, you may 
%               need to use a try-catch construct in the caller. 
%               (see detailed comments in getParamsByHandle.m)
% 
% By "immediately connected", we mean the blocks are connected by a line
% directly to the block given by blockPath
%
% Any connected block of type 'SubSystem' are ignored.
% 
% ANY CONNECTED BLOCK OF TYPE "SubSystem" ARE IGNORED
% AS THAT WOULD NOT BE USEFUL FOR OUR APPLICATION

% ASSUMPTIONS:
% -----------
% corresponding system is loaded
% 
% PARAMETERS:
% -----------
% blockHadle(handle) :  handle of a block (can be a subsystem too)
% connectionType(str/char) : src/dst/both 

    assert (any(strcmp(["src", "dst", "both"], connectionType)));
    
    handles = getConnectedBlockHandlesByBlockHandle(blockHandle, connectionType);  % may raise error 
    map = containers.Map('KeyType', 'char', 'ValueType', 'double'); 
    for i = 1:length(handles)
       handle = handles(i); 
       blockType = get_param(handle, 'BlockType');
       if map.isKey(blockType)
           map(blockType) = map(blockType) + 1; 
       else 
           map(blockType) = 1; 
       end
    end
end 