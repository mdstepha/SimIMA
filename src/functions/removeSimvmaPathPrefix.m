function relpath = removeSimvmaPathPrefix(abspath)
% Remove simvma path prefix from given absolute path 
% eg:
% "/Users/bhisma/courses/cse-700-simvma/simvma/default-repos/automotive/Matlab_Central/MinorTimeStepLogging/SimpleBounce.mdl"
% --> "default-repos/automotive/Matlab_Central/MinorTimeStepLogging/SimpleBounce.mdl"
% 
% PARAMETERS: 
% - abspath (char/string) : absolute file/folder path 

% ASSUMPTION: 
% - given abspath starts with simvmapath 
    
    
    simvmaPathLength = length(char(getSimvmaPath()));
    relpath = extractAfter(abspath, simvmaPathLength + 1); 
end 