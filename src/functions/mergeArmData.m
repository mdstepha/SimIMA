function data = mergeArmData(data1, data2)
% Merges 2 'data' attributes of ArmModel 
% Original data are not affected. 
% 
% PARAMETERS:
% -----------
% data1 (struct): first data 
% data2 (struct): second data
% 

    data = data1; 
    n = length(fields(data)); 
    for i = 1 : length(fields(data2))
        data.("ss" + (n+i)) = data2.("ss" + i); 
    end 
end 