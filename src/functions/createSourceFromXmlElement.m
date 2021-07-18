function source = createSourceFromXmlElement(xmlElement, simvmaPath) 
    tokens = split(xmlElement);
    
    fileTokens = split(tokens(2), '=');
    file = fileTokens(2);
    file = cell2char(file);
    file = string(file); 
    filepath = simvmaPath + "/Simone-2.0-Complete-Cygwin64-customized-for-simvma/" + file; 
    
    startlineTokens = split(tokens(3), '=');
    startline = startlineTokens(2);
    startline = cell2int(startline);
    
    endlineTokens = split(tokens(4), '=');
    endline = endlineTokens(2);
    endline = cell2int(endline); 
    
    pcidTokens = split(tokens(5), '=');
    pcidTokens = split(pcidTokens(2), '>');
    pcid = pcidTokens(1);
    pcid = cell2int(pcid);
    
    source = Source(filepath, startline, endline, pcid);
end 

function value = cell2int(value)
    value = char(value);
    len = length(value);
    value = value(2:len-1);
    value = string(value);
    value = double(value);
    value = int64(value);
end 

function value = cell2char(value)
    value = char(value);
    len = length(value);
    value = value(2:len-1);
end 