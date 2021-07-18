function nFiles = getNFilesRecursively(dirpath, extensions)
% Return the count of (nested) files located inside given directory, and 
% having given extension. 
% 
% If dirpath is empty i.e. "", returns 0
% PARAMETERS:
% -----------
% dirpath (string)     : path of directory (absolute or relative) 
% extensions (string)  : file extensions (without leading .) -- Only those 
%                        files matching this extension (case is ignored)
%                        will be counted. 
%                        This can be one of: 
%                        - single string     (eg: "mdl")
%                        - single char-array (eg: 'mdl') 
%                        - list of strings   (eg: ["mdl", "slx"])
%                        This CANNOT be a list of chars (eg: ['mdl', 'slx']
%                        is INVALID. 
    
    dirpath = string(dirpath);
    extensions = string(extensions); 
    nFiles = 0; 
    if dirpath == ""
        return; 
    end 
    for i = 1 : length(extensions)
        ext = extensions(i); 
        path = dirpath + "/**/*." + ext; 
        nFiles = nFiles + length(dir(path));
    end 
end 