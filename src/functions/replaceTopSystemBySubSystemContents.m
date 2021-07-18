function replaceTopSystemBySubSystemContents(topSystemPath, subSystemPath) 
% Replace everything in the top-system by the contents of subsystem 
% 
% NOTE: 
% -----
% This function is not used anymore because it has problem inserting 
% certain types of subsystems' contents (see detailed explanation in
% updateMUDWithSuggestion's case (Top, Sub) 
% 
% IMPORTANT: 
% ----------
% - the replacement will be done by the CONTENTS of the sub-system, 
%   NOT by the subsystem i.e. This can be thought of as replacing
%   the top-system by the sub-system, followed by expanding the copied
%   subsystem inside the top-system. 
% 
% - the top-system and the sub-system MUST be from different mdl files, 
%   otherwise an error will be raised.  
%
% PARAMETERS:
% -----------
% topSystemPath : string -- path of top system, eg: 'mysystem'
% subSystemPath : string -- path of sub system, eg: 'mysys2/a/b/c'
% 
% ASSUMPTIONS:
% ------------
% - provided paths are valid 
% - both mdl files are loaded 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % verify that top-system and sub-system are from different mdl files 
    topSystemPath = string(topSystemPath); 
    subSystemPath = string(subSystemPath); 
    
    tokensT = topSystemPath.split('/'); 
    tokensS = subSystemPath.split('/'); 
    
    if tokensT(1) == tokensS(1)
       error("top-system and sub-system MUST be from different mdl files"); 
    end

    
    % APPROACH:
    %   1. delete everything from topsystem
    %   2. copy subsystem contents inside top system
    
    Simulink.BlockDiagram.deleteContents(topSystemPath); 

    dispKeyVal('topSystemPath', topSystemPath);
    dispKeyVal('subsystemPath', subSystemPath); 
    
    Simulink.SubSystem.copyContentsToBlockDiagram(subSystemPath, topSystemPath); 
end 