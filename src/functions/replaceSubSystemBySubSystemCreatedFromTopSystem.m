function replaceSubSystemBySubSystemCreatedFromTopSystem(subSystemPath, topSystemPath) 
% Replace the sub-system (firt arg) by another sub-system which is created 
% from the top-system (second arg) 
% 
% IMPORTANT: 
% ----------
% - the replacement will be done by wrapping the CONTENTS of the top-system, 
%   into a sub-system.

% - the top-system and the sub-system MUST be from different mdl files, 
%   otherwise an error will be raised.  
%
% PARAMETERS:
% -----------
% subSystemPath : string -- path of sub system, eg: 'mysys2/a/b/c'
% topSystemPath : string -- path of top system, eg: 'mysystem'
%  
% ASSUMPTIONS:
% ------------
% - provided paths are valid 
% - both mdl files are loaded 

    % verify that top-system and sub-system are from different mdl files 
    topSystemPath = string(topSystemPath); 
    subSystemPath = string(subSystemPath); 
    
    tokensT = topSystemPath.split('/'); 
    tokensS = subSystemPath.split('/'); 
    
    if tokensT(1) == tokensS(1)
       error("top-system and sub-system MUST be from different mdl files"); 
    end

    
%     % APPROACH:
%     %   1. delete everything from topsystem
%     %   2. copy subsystem contents inside top system
%     
%     Simulink.BlockDiagram.deleteContents(topSystemPath); 
%     Simulink.SubSystem.copyContentsToBlockDiagram(subSystemPath, topSystemPath); 

    %%%%%%%%%%%% NOT IMPLEMENTED %%%%%%%%%%%%%
end 