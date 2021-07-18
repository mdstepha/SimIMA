function fieldWithMaxVal = getFieldWithMaxVal(structure)
% Return the field (string) with maximum value. 
% If there are multiple fields with the maximum value, only one (whichever 
% comes first when parsing the structure fields) will be returned. 
% 
% If structure is empty i.e. has no field, an empty string i.e. "" will be
% returned. 
%
% ASSUMPTIONS:
% ------------
%     - value of each field in the structure is a number (double)
% 
% PARAMETERS:
% -----------
% structure (struct) : structure whose fields are to be sorted.

    fieldNames = string(fields(structure)); 
    fieldWithMaxVal = "";
    maxVal = -Inf; 
    
    for i = 1 : length(fieldNames)  
        fieldName = fieldNames(i); 
        val = structure.(fieldName); 
        if val > maxVal
           fieldWithMaxVal = fieldName;
           maxVal = val; 
        end
    end
end 