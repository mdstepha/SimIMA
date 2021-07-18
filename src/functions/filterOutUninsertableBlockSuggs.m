function suggsPassed = filterOutUninsertableBlockSuggs(suggs)
% Remove all suggestions which are not insertable into the Simulink
% workspace 
% 
% PARAMETERS: 
% -----------
%   - suggs (array of BlockSugg)

    uninsertableBlockTypes = ["Reference"]; 

    suggsPassed = BlockSugg.empty; 
    for i = 1 : length(suggs)
        sugg = suggs(i);
        pass = true;  
        if any(strcmp(sugg.blockType, uninsertableBlockTypes)) 
            pass = false;
        end 
        
        if pass
            suggsPassed = [suggsPassed sugg]; 
        end 
    end 
end