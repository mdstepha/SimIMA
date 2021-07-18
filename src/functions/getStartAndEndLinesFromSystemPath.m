function [startline, endline] = getStartAndEndLinesFromSystemPath(mdlFilepath, systemPath)
% Return the startline, endline of (sub)system that matches given systemPath 
% 
% 
% A (sub)system's 'path' here is simply a string that gives full path of
% the (sub)system beginning from the top system. Thus, returned value will 
% be in the format: "model_name/a/b/c/sub_system_name"
%
% PARAMETERS:
% -----------
% mudFilepath :  string -- absolute filepath of Model Under Development
% systemPath  :  string -- path of (sub)System. This must be in format as 
%                returned by 'gcs' eg: "mymodel/a/b/mysubsystem"
%
% ASSUMPTIONS: 
%   - both mdlFilepath and systemPath are valid. this means: 
%          1. a mdl file exists for given mdlFilepath 
%          2. the mdl file contains a system given by systemPath 
% 
%     IF THIS REQUIREMENT IS NOT SATISFIED AN ERROR WILL BE THROWN (IT
%     WON'T BE HANDLED) 
% 
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
    
    pathStack = string.empty;
    braceStack = string.empty; 
    startlineStack = []; 
    
    for i = 1: length(lines)
        line = lines(i); 
        if line == "System {"
           startlineStack = [startlineStack i]; 
           
           % get name of (sub)system 
           nextline = lines(i+1);           
           sysName = getSystemNameFromLine(nextline, "gcs"); 

           pathStack = [pathStack sysName]; 
           braceStack = [braceStack "sys{"]; 
               
        elseif line.endsWith("{")
            braceStack = [braceStack "{"]; 
        
       elseif line.endsWith("}")
            braceStack = [braceStack "}"];      
       end 
       
       if braceStack(end) == "}" && braceStack(end-1) == "{"
           % these pair corresponding to some block/line other than a
           % System{} block 

           % remove last two entries that form a {} pair 
           braceStack(end) = [];
           braceStack(end) = []; 
       end

       if braceStack(end) == "}" && braceStack(end-1) == "sys{"
           % these pair corresponding to a System{} block 
                      
           if systemPath == pathStack.join('/')
               endline = i; 
               startline = startlineStack(end); 
               return; 
           else 
               % remove last two entries that form a sys{} pair 
               braceStack(end) = [];
               braceStack(end) = []; 

               % remove the last enty of pathStack and startlineStack too
               pathStack(end) = [];    
               startlineStack(end) = []; 
           end 
       end
    end
end 