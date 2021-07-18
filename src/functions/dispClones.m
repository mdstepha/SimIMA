function dispClones(clones, msg)
% display clones
% 
% PARAMETERS: 
% -----------
% clones : cell vector -- clones to be displayed 
% msg    : string -- message to be displayed before displaying the clones 

    dispTitle(msg); 

    if length(clones) == 0
        dispTitle("NO CLONE AT ALL"); 
    else 
        for i = 1: length(clones)
            dispUnderlined("Clone" + i); 
            clone = clones{i}; 
            disp(clone); 

            dispUnderlined("clone" + i + ".source1"); 
            disp(clone.source1); 

            dispUnderlined("clone" + i + ".source2"); 
            disp(clone.source2); 
            
            dispSeparator(); 
        end
    end
end