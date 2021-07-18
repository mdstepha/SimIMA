function postAction = replaceSubSystem(replacedSubSystemPath, replacerSubSystemPath, MUDFilepath) 
% Replace the first sub-system by second sub-system
% 
% IMPORTANT: 
% ----------
% - the top-system and the sub-system MUST be from different mdl files, 
%   otherwise an error will be raised.  
% - the name of the new sub-system will be the same as that of the old
%   (replaced subsystem) 
% - after replacement is made, the 'view' of the replaced model will be at
%   the level of inside the replaced sub-system
%
% PARAMETERS:
% -----------
% replacedSubSystemPath : string -- path of replaced sub system, eg: 'mysys/a/b'
% replacerSubSystemPath : string -- path of replacer sub system, eg: 'mysys1/a/x'
%  
% ASSUMPTIONS:
% ------------
% - provided paths are valid 
% - both mdl files are loaded 
% - subsystems are COMPATIBLE for replacement i.e. number of inports and
%   outports match between the replaced subsystem and the replacer
%   subsystem
% - the replaced subsystem is in MUDFilepath 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    postAction = ""; 

    % verify that the 2 sub-systems are from different mdl files 
    replacedSubSystemPath = string(replacedSubSystemPath); 
    replacerSubSystemPath = string(replacerSubSystemPath);  
    
    disp("replacedSubSystemPath :" + replacedSubSystemPath); 
    disp("replacerSubSystemPath :" + replacerSubSystemPath); 
    
    tokens1 = replacedSubSystemPath.split('/'); 
    tokens2 = replacerSubSystemPath.split('/'); 
    bdnameReplaced = tokens1(1); % index 1 gives bdname
    bdnameReplacer = tokens2(1); 
        
    if bdnameReplaced == bdnameReplacer 
        error("The two sub-systems MUST be from different mdl files"); 
    end

    % location of window in screen 
    loc = get_param(tokens1(1), 'location'); 
    
    % APPROACH 
    % 1. get the position of the replaced sub-system
    % 2. delete replaced sub-system 
    % 3. copy replacer sub-system to replaced model 
    % 4. restore the position 
    
    % position of subsystem within the model 
    pos = get_param(replacedSubSystemPath, 'position'); 
    delete_block(replacedSubSystemPath); 
    add_block(replacerSubSystemPath, replacedSubSystemPath); 
    
    [nInport, nOutport] = getNInportOutport(replacedSubSystemPath); 
     
    set_param(replacedSubSystemPath, 'position', pos); 

    % in case the user is currently "viewing" MUD at the level of SUD
    % (which is most probably the case), the MUD's window will be lost as 
    % soon as delete_block(replacedSubSystemPath) command is executed. 
    % So, to make sure the model is still visible to the user after 
    % replacement is made, open_system() is executed 
    
    open_system(MUDFilepath);               % open model 
    
    % restore window's position in screen 
    dispImp("replacesSSPath : " + replacedSubSystemPath); 
    set_param(bdnameReplaced, 'location', loc); 
    save_system(MUDFilepath); 
    
    % change view level to SUD's parent, 
    % so that user can make adjustments to connections 
    tmp = replacedSubSystemPath.replace('//', '___double_slash___'); 
    tokens = tmp.split('/'); 
    tokens(end) = []; % remove last token i.e. SUD 
    parentSystemPath = tokens.join('/'); 
    parentSystemPath = parentSystemPath.replace('___double_slash___', '//'); 
    open_system(parentSystemPath); 
    
    if ~(nInport == 1 && nOutport == 1)
        postAction = "ADJUST_CONN"; 
    end
end 