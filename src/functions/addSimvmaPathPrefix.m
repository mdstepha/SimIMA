function abspath = addSimvmaPathPrefix(relpath)
% Add simvma path prefix from given relative path 
% eg:
% "default-repos/automotive/Matlab_Central/MinorTimeStepLogging/SimpleBounce.mdl"
% --> "/Users/bhisma/courses/cse-700-simvma/simvma/default-repos/automotive/Matlab_Central/MinorTimeStepLogging/SimpleBounce.mdl"
% 
% PARAMETERS: 
% - relpath (char/string) : file/folder path relative to simvma 

    
    relpath = string(relpath); 
    abspath = getSimvmaPath + "/" + relpath;  
end 