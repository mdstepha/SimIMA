function handles = getConnectedBlockHandlesByBlockHandle(blockHandle, connectionType)
% Return an array of handles of all immediately connected blocks.
% 
% RAISES_ERROR: Since this function is not guaranteed to succeed, you may 
%               need to use a try-catch construct in the caller. 
%               (see detailed comments in getParamsByHandle.m)
%
% 
% By "immediately connected", we mean the blocks are connected by a line
% directly to the block given by blockPath
%
% SUBSYSTEM HANDLES, IF ANY, WILL BE IGNORED IN THE RETURNED ARRAY
% AS THAT WOULD NOT BE USEFUL FOR OUR APPLICATION
% 
% The argument blockPath can be that of a subsystem too.
% 
% 
% The returned array will be empty i.e. [] if an unconnected block's path 
% is passed in. 
% 
% All returned handles are valid i.e. they don't correspond to some 
% invalid/deleted object (at the time of invocation of this function)
%
%
% ASSUMPTIONS:
% -----------
% corresponding system is loaded
% 
% PARAMETERS:
% -----------
% blockHandle(handle) :  handle of a block (can be a subsystem too)
% type(str/char) : src/dst/both 
% 

    assert (any(strcmp(["src", "dst", "both"], connectionType)));
    params = getParamsByHandle(blockHandle, false);  % may raise error 
    portConns = params.PortConnectivity; 
    
    
    handles = []; 
    for i = 1:length(portConns)
        if connectionType == "both"
            if portConns(i).SrcBlock
                handles = [handles portConns(i).SrcBlock];
            else 
                handles = [handles portConns(i).DstBlock]; 
            end
        elseif connectionType == "src" 
            if portConns(i).SrcBlock
                handles = [handles portConns(i).SrcBlock];
            end 
        else  % type == "dst"
            if portConns(i).DstBlock
                handles = [handles portConns(i).DstBlock];
            end
        end
    end
    
   
    % It was found that if an unconnected subsystem's path is provided as 
    % blockPath, -1.00 is returned (which is an invalid handle), but we 
    % want to return empty array i.e. [] in such case. This statements
    % removes any handle which is -1.00. 
    handles = handles(handles ~= -1); 
        
    % filter out subsystem handles 
    % this must be done after removing handle=-1.00, if any
    % otherwise get(handle, 'BlockType') will throw error for handle=-1.00
    handles1 = [];  
    for i = 1 : length(handles)
        handle = handles(i); 
        blockType = get(handle, 'BlockType'); 
        if string(blockType) ~= "SubSystem"
            handles1 = [handles1 handle]; 
        end
    end
    handles = handles1; 
end 