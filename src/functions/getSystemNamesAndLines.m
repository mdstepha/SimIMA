function [names, startlines, endlines] = getSystemNamesAndLines(mdlFilepath)
% return  3 arrays : System names, startlines, and endlines (all are of
% same length) 
    
    fid = fopen(mdlFilepath, 'r');
    
    lines = string.empty; % all lines of file after striping 
    while ~feof(fid)
        line = fgets(fid); % char vector 
        line = string(strip(line)); 
        lines(length(lines) + 1) = line; 
    end 
    
    fclose(fid); 
    
    names = string.empty; 
    startlines = []; 
    endlines = []; 
    
    for i=1:length(lines)
        line = lines(i); 
        if line == "System {" 
            startlines(length(startlines) + 1) = i; 
            % ASSUMPTION: the first attribute of any System{} is 'Name'
            nextline = lines(i+1); 
            tokens = split(nextline);
            
            name = char(tokens(2));   % attribute 'Name' 
            % strip first and last character, 
            % because split() returns tokens by surrounding with 
            % double-double quotes: eg: ""MySubsystem""
            ll = length(name); 
            name = string(name(2:ll-1)); 
            
            names(length(names)+1) = name; 

            openBraceCount = 1; 
            j = i; 
            while (true)
                j = j + 1; 
                line = lines(j); 
                if line.endsWith("{")
                   openBraceCount = openBraceCount + 1;  
                end
                if line.endsWith("}")
                   openBraceCount = openBraceCount - 1;  
                end
                if openBraceCount == 0
                    endlines(length(endlines) + 1) = j; 
                    break; 
                end
            end     
        end
    end 
end