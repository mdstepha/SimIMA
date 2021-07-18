function newObjs = sortObjsByProp(objs, prop, order)
% Sort object by the given property in given order
%
% PARAMETERS:
% -----------
%   objs (Objects)      : list of objects 
%   prop (String/char)  : property name by which the objects are to be
%                         sorted (must be comparable) 
%   order(String/char)  : 'ascend' / 'descend' 

    % APPROACH:
    % - convert class instances (objs) to structs
    % - convert the structs to table
    % - sort the table
    % - convert the table back to structs
    % - convert the structs back to class instances 
    
    prop = string(prop); 
    order = string(order); 
    
    assert(any(strcmp(order, ["ascend", "descend"])));
    
    if isempty(objs)
        newObjs = objs; 
        return; 
    end 
    
    % new objects will be created by updating properties of the passed
    % objects. 
    newObjs = objs; 
    
    % object --> struct 
    objsStruct = struct.empty(); 
    warning off; 
    for i = 1 : length(objs)
        obj = objs(i); 
        objStruct = struct(obj); 
        objsStruct = [objsStruct objStruct]; 
    end
    warning on; 
    
    table_ = struct2table(objsStruct); 
    % sort the table by given property in given order 
    tableSorted = sortrows(table_, prop, order); 
    objsStructSorted = table2struct(tableSorted);  
    
    % struct --> object 
    objs = BlockSuggFromPredModel.empty(); 
    for i = 1 : length(objsStructSorted)
        obj = newObjs(i);
        s = objsStructSorted(i); 
        fields_ = fields(s);  % cell array 
        for j = 1 : length(fields_)
            field = fields_{j}; 
            obj.(field) = s.(field); 
        end 
        newObjs(i) = obj;  
    end 
end 