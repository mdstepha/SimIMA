function structure = getParamsByPathSorted(path)
% Return a struct containing all parameters sorted alphabetically of the 
% given block-diagram/block/line...
%
% ASSUMPTIONS:
% -----------
% corresponding system is loaded
% path is valid 
% 
% PARAMETERS:
% -----------
% path(string) :  -- element's path. The element can be block-diagram/
%           block/line/...

    handle = get_param(path, 'handle'); 
    structure = getParamsByHandle(handle, true);  
end 