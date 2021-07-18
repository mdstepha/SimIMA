function result = filenamesMatch(filepath1, filepath2)
% Return true if filenames match, else return false 
%
% PARAMETERS:
% -----------
% filepath1   : string -- absolute path of first file
% filepath2   : string -- absolute path of second file


    [folder1, bdName1, ext1] = fileparts(filepath1);
    [folder2, bdName2, ext2] = fileparts(filepath2);
    
    if bdName1 == bdName2
        result = true; 
    else 
        result = false; 
    end 
end 