function paths = searchFilesRecursively(folderPath, extensions)
% Return a list of absolute paths of all files matching the extension and 
% contained within the directory given by folderPath. These files could be 
% nested in subdirectories. 
% 
% If dirpath is empty i.e. "" or non-existent, returns 0
% 
% PARAMETERS:
% -----------
% folderPath(str): absolute/relative path of the folder containing the files 
%                to be searched. 
% extensions(str):extension of files to be searched without leading period
%                        This can be one of: 
%                        - single string     (eg: "mdl")
%                        - single char-array (eg: 'mdl') 
%                        - list of strings   (eg: ["mdl", "slx"])
%                        This CANNOT be a list of chars (eg: ['mdl', 'slx']
%                        is INVALID. 
    
    folderPath = string(folderPath); 
    extensions = string(extensions); 
    paths = string.empty; 
    if folderPath == ""
        return; 
    end 
    
    for i = 1 : length(extensions) 
        ext = extensions(i); 
        structures = dir(folderPath + "/**/*." + ext);
        for j = 1: length(structures) 
            s = structures(j); 
            path = fullfile(s.folder, s.name); 
            paths = [paths path]; 
        end

    end     
end 