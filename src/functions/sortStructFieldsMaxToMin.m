function sortedFields = sortStructFieldsMaxToMin(structure)
% Return a list of fields (string) sorted by the value (number) of the
% fields in given structure.
%
% ASSUMPTIONS:
% ------------
%     - value of each field in the structure is a number (double)
% 
% PARAMETERS:
% -----------
% structure (struct) : structure whose fields are to be sorted.

    sortedFields = string.empty;     
    while length(fields(structure))
       f = getFieldWithMaxVal(structure); 
       sortedFields = [sortedFields f]; 
       structure = rmfield(structure, f);
    end
end 

