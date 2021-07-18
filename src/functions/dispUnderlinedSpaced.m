function dispUnderlinedSpaced(msg)
    msg = char(msg);
    len = length(msg); 
    dashes = "";
    for i = 1:len
       dashes = dashes + "-"; 
    end
    
    disp(newline); 
    disp(msg); 
    disp(dashes);
    disp(newline); 
end