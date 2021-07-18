function dispUnderlined(msg)
    msg = char(msg);
    len = length(msg); 
    dashes = "";
    for i = 1:len
       dashes = dashes + "-"; 
    end
    
    disp(msg); 
    disp(dashes);
end