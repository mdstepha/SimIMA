function label = trimLabel(label, maxLen)
% trims the label such that the returned value <= maxLen in length 
% 
% PARAMETERS: 
% -----------
% label : string/char

    len = length(char(label)); 
    if  len > maxLen
        label = "..." + extractAfter(label, len - maxLen); 
    end            
end