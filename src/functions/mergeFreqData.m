function data = mergeFreqData(data1, data2)
% Merges 2 'data' attributes of FreqModel 
% Original data are not affected. 
% 
% PARAMETERS:
% -----------
% data1 (struct): first data 
% data2 (struct): second data
% 

    data = struct; 
    blocks1 = transpose(string(fields(data1)));  % 1xM string array
    blocks2 = transpose(string(fields(data2)));  % 1xN string array 
    
    blocksCommon = intersect(blocks1, blocks2);
    blocks1Only = setdiff(blocks1, blocks2); 
    blocks2Only = setdiff(blocks2, blocks1); 
    
    % common blocks 
    for i = 1 : length(blocksCommon)
         blockName = blocksCommon(i);
         data.(blockName) = struct;
         
         % merge 'count'
         data.(blockName).count = data1.(blockName).count + data2.(blockName).count; 
         
         % merge 'src' 
         src1 = data1.(blockName).src;
         src2 = data2.(blockName).src; 
         data.(blockName).src = mergeInner(src1, src2); 
         
         % merge 'dst' 
         dst1 = data1.(blockName).dst;
         dst2 = data2.(blockName).dst; 
         data.(blockName).dst = mergeInner(dst1, dst2); 
         
         % merge 'both' 
         both1 = data1.(blockName).both;
         both2 = data2.(blockName).both; 
         data.(blockName).both = mergeInner(both1, both2); 
    end
    
    % blocks in data1 only 
    for i = 1 : length(blocks1Only)
        blockName = blocks1Only(i); 
        data.(blockName) = data1.(blockName);  
    end
    
    % blocks in data2 only 
    for i = 1 : length(blocks2Only)
        blockName = blocks2Only(i); 
        data.(blockName) = data2.(blockName);  
    end
    
end 


function merged = mergeInner(first, second)
    % merges the inner fields i.e 'src'/'dst'/'both' 
    merged = struct; 
    merged.count = first.count + second.count; 
    merged.details = struct; 
    blocks1 = transpose(string(fields(first.details))); 
    blocks2 = transpose(string(fields(second.details)));
    
    blocksCommon = intersect(blocks1, blocks2);
    blocks1Only = setdiff(blocks1, blocks2); 
    blocks2Only = setdiff(blocks2, blocks1); 
    
    % common blocks 
    for i = 1 : length(blocksCommon)
        blockName = blocksCommon(i); 
        merged.details.(blockName) = first.details.(blockName) + second.details.(blockName); 
    end
    
    % blocks in first only 
    for i = 1 : length(blocks1Only)
        blockName = blocks1Only(i); 
        merged.details.(blockName) = first.details.(blockName); 
    end
    
    % blocks in second only 
    for i = 1 : length(blocks2Only)
        blockName = blocks2Only(i); 
        merged.details.(blockName) = second.details.(blockName); 
    end
end 
