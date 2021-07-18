function sysName = getSystemNameFromLine(line, format)
% Return the system's name from line. 
% The returned string is in the format as it appears in the mdl file. 
% The returned string is NOT in the format as returned by gcs. 
% 
% PARAMETERS:
% -----------
% line      : stringstring -- the line corresponding to the system's name
% format    : string 
%               "mdl" : returned string is in the same format as it appears
%                       in the mdl file 
%               "gcs" : returned string is in the same file as this part
%               would appear in the char-vector-returned-by-gcs (converted
%               to string) 
% 

    if ~any(strcmp(["mdl", "gcs"], format)) % if format matches none in the list
        disp("format: " + format); 
        error("*** ERROR: INVALID ARGUMENT");  
    end

    line = string(line); 
    line = line.strip(); 
    sysName = extractAfter(line, 5); 
    sysName = strip(sysName); 
    
    % remove leading and trailing " 
    sysName = char(sysName); 
    sysName = sysName(2:end-1); 
    sysName = string(sysName); 
    
    if format == "gcs"
        sysName = convertSystemNameToGcsFormat(sysName); 
    end 
end 