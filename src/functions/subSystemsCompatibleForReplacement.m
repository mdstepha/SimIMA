function result = subSystemsCompatibleForReplacement(subSystem1Path, subSystem2Path)
% Return true if passed sub-systems are compatible for replacement (by one
% another), else return false. 
%
% ASSUMPTIONS:
% -----------
% 1. both mdl files are loaded
% 
% PARAMETERS:
% -----------
% subSystem1Path   : string -- first sub-system's path
% subSystem2Path   : string -- second sub-system's path
% - Both subSystem1Path and subSystem2Path should be in format as returned 
% by 'gcs' eg: "mymodel/a/b/mysubsystem"

% LOGIC:
% - The two sub-systems must have the same number of inports and outports.
%   i.e. nInport1 = nInport2 && nOutport1 = nOutport2 

%     disp("subSystem1 : " + subSystem1); 
%     disp("subSystem2 : " + subSystem2); 
     
    
    [nInport1, nOutport1] = getNInportOutport(subSystem1Path); 
    [nInport2, nOutport2] = getNInportOutport(subSystem2Path); 
    
    if nInport1 == nInport2 && nOutport1 == nOutport2 
        result = true;
    else
        result = false;  
    end  
end 

