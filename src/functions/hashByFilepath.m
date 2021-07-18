function res = hashByFilepath(abspath)
% Return the MD5 hash (modified) of given string
% 
% PARAMETERS:
% -----------
% abspath (string/char): absolute filepath of the file, whose content's hash 
%                    is to be computed

    abspath = string(abspath); 
    fileContent = fileread(abspath); 
    res = hash(fileContent); 
end 