function result = isTopSystem(systemPath)
% Return true if passed (sub)system's handle is 'Top' level system, else return false
%
% ASSUMPTIONS:
% -----------
% 1. system is loaded
% 
% PARAMETERS:
% -----------
% systemPath :  string -- (sub)system's name (which is to be updated)
%               This should be in format as returned by 'gcs' eg:
%               "mymodel/a/b/mysubsystem"


% LOGIC: the 'Type' of top-level system is 'block_diagram', whereas that of
% a sub-system is 'block' 


blockType = get_param(systemPath, 'Type');

if string(blockType) == "block_diagram" 
    result = true; 
else 
    result = false; 
end 