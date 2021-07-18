function dispSuggestions(suggestions, msg)
% display suggestions 
% 
% PARAMETERS: 
% -----------
% suggestions : cell vector -- suggestions to be displayed 
% msg         : string -- message to be displayed before displaying the suggestions  

    dispTitle(msg); 

    if length(suggestions) == 0
        dispTitle("NO SUGGESTION AT ALL"); 
    else 
        for i = 1:length(suggestions)
            dispUnderlined("Suggestion" + i); 
            sug = suggestions{i}; 
            disp(sug); 
            disp(sug.source); 
            dispSeparator(); 
        end
    end
end