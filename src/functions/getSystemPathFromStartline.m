function path = getSystemPathFromStartline(mdlFilepath, startline)
% Return the 'path' of (sub)system that starts at given 'startline' 
% If no such (sub)system is found, return "__NOT_FOUND__"
% 
% A (sub)system's 'path' here is simply a string that gives full path of
% the (sub)system beginning from the top system. Thus, returned value will 
% be in the format : "model_name/a/b/c/sub_system_name"
% This is the same format as the char vector returned by gcs converted to string
% 
%
% ASSUMPTIONS: 
%   - the mdl file is created by Simulink and is in 'standard' format 
%     such that: 
%       - the first property of System{} is always 'Name'
%       - "{" and "}" appear only one per line (at max), and only as last
%       character (after stripping white space) 

    
    fid = fopen(mdlFilepath, 'r');
    
    lines = string.empty; % all lines of file after striping 
    while ~feof(fid)
        line = fgets(fid); % char vector 
        line = string(strip(line)); 
        lines(length(lines) + 1) = line; 
    end 
    
    fclose(fid);
    
    if ~lines(startline).startsWith("System {")
        path = "__NOT_FOUND__"; 
        return 
    end
    
    pathStack = string.empty; 
    braceStack = string.empty; 
        
    for i = 1: length(lines) 
        if i > startline + 1 
            break; 
        end 
        
        line = lines(i); 
        if line == "System {"
            nextline = lines(i+1);    
            sysName = getSystemNameFromLine(nextline, "gcs"); 
            pathStack = [pathStack sysName]; 
            braceStack = [braceStack "sys{"]; 
       
        elseif line.endsWith("{")
            braceStack = [braceStack "{"]; 
        
        elseif line.endsWith("}")
            braceStack = [braceStack "}"]; 
        end
        
        len = length(braceStack);         
        
        if len > 1 && braceStack(len) == "}" && braceStack(len-1) == "{"
            % these pair corresponding to some block/line other than a
            % System{} block 
            
            % remove last two entries that form a {} pair 
            braceStack(end) = [];
            braceStack(end) = []; 
        end
        
        len = length(braceStack); 
        if len > 1 && braceStack(len) == "}" && braceStack(len-1) == "sys{"
            % these pair corresponding to a System{} block 
            
            % remove last two entries that form a sys{} pair 
            braceStack(end) = [];
            braceStack(end) = []; 
            
            % remove the last enty of pathStack too
            pathStack(end) = [];  
        end
          
    end 
    path = join(pathStack, "/"); 
end 