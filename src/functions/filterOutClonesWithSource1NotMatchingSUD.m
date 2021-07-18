function filteredClones = filterOutClonesWithSource1NotMatchingSUD(clones, sudPath)
% This function removes clones for which the source1.system does not match
% the (Sub)System-Under-Development.
%
% PARAMETERS:
% -----------
% clones  : cell array -- clones on which filtration is to be applied 
% sudPath : string -- path of (sub)system under development (as returned by 
%                     gcs (eg: "mymodel/a/b/c"
%
% NOTE:
% -----
% When simone detects clones, the source1 (from which we derive source1.system)
% will be from the model-under-development, and source2 will be from the repositories. 
% But, the source1 could be other than the (Sub)System Under Development
% which we are interested in (because, there can be multiple sub-systems in
% the model-under-development. 

    % Since the first input to Simone is folder containing "sud.mdl" file
    % rather than the actual MUD, the sudPath needs to be adjusted -- the 
    % system path upto the SUD needs to be trimmed as "sud.mdl"'s system
    % heirarchy starts with the SUD. 
    % eg. if actual sudPath is "dd/s1/s2", then sud.mdl will begin with
    % "s2", thus "dd/s1/" needs to be trimmed. 
    % 
    % eg1: "dd/s1/s2" --> "s2" 
    % eg2: "dd" --> "dd" 
    % eg3: "dd/s1/sub//system --> "sub//system" 
    
    % We want to split the sudPath at '/', 
    % but we don't want to split at '//'
    sudPath = sudPath.replace('//', '___slash_in_sub_system_name___'); 
    
    tokens = sudPath.split("/"); 
    sudPath = tokens(end); 
    sudPath = sudPath.replace('___slash_in_sub_system_name___', '//'); 

    
    filteredClones = {}; 

    for i = 1:length(clones)
       clone = clones{i};
       if clone.source1.system == sudPath
           filteredClones{end+1} = clone;
%            disp("pass : " + clone.source1.system); 
       else 
%            disp("fail : " + clone.source1.system); 
       end 
    end
end