function structure = getParamsByPath(path)
% Return a struct containing all parameters (not sorted alphabetically) of 
% the given block-diagram/block/line...
% 
% RAISES_ERROR: Since this function is not guaranteed to succeed, you may 
%               need to use a try-catch construct in the caller. 
%               (see detailed comments in getParamsByHandle.m)
% 
%
% ASSUMPTIONS:
% -----------
% corresponding system is loaded
% path is valid 
% 
% PARAMETERS:
% -----------
% path(string) : element's path in a model (as returned by gcs). 
%                The element can be block-diagram/block/line/...
% 
   
    handle = get_param(path, 'handle');  
    structure = getParamsByHandle(handle, false); % may raise error   
end 