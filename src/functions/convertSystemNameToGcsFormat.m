function str = convertSystemNameToGcsFormat(str)
% Convert the string to the format followed by gcs
% The following transformation take place: 
%   /   --> // 
%   \n  --> newline 
%   \"  --> "" 
% 
% PARAMETERS:
% -----------
% str      : string -- string to be converted into gcs format

    str = str.replace('/', '//'); 
    str = str.replace('\n', newline); 
    str = str.replace('\"', '"'); 
end 