function realPath = symbolicPathToRealPath(symbolicPath)
% convert symbolic path to real path 
% 
% IMPORTANT: 
% ----------
% - this is a workaround as matlab does not support the UNIX
%   command "realpath" 
% - It is limited in functionality and is intended to use only to resolve 
%   the absolute path of the standard repositories

    symbolicPath = string(symbolicPath); % cannot be char
    realPath = symbolicPath.replace("Simone-2.0-Complete-Cygwin64-customized-for-simvma/mdl-files", "default-repos");
end 