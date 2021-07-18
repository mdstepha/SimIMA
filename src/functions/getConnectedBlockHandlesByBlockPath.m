function handles = getConnectedBlockHandlesByBlockPath(blockPath, connectionType)
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
% blockPath(str/char) :  path of a block (can be a subsystem too)
% type(str/char) : src/dst/both 

    assert (any(strcmp(["src", "dst", "both"], connectionType)));

    blockHandle = get_param(blockPath, 'handle'); % path to handle
    handles = getConnectedBlockHandlesByBlockHandle(blockHandle, connectionType); % may raise error 
end 