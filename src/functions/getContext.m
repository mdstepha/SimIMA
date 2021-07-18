function context = getContext()
% Return current context as Context object. This context will be used to 
% make block suggestions.
% 
    sud = gcs;  % system under development 
    mrcbPath = string(gcb);  % most recently clicked block
    mrcbParams = getParamsByPath(mrcbPath);
    mrcbBlockType = mrcbParams.BlockType;
    mrcbPosition = mrcbParams.Position; 
    
    map = getConnectedBlockTypesWithCountByBlockPath(mrcbPath, "both"); % containers.Map 
    keys = map.keys;  % cell array (char)
    values = map.values;  % cell array (double)
    mrcbNeighborsMap = struct; 
    for i = 1 : length(keys)
        key = string(keys{i}); 
        key = convertBlockTypeToField(key); 
        value = values{i}; 
        mrcbNeighborsMap.(key) = value; 
    end 
    
    
    % find xMin, xMax, yMin, yMax (to know what they mean, see Context.m) 
    xMin = inf; 
    xMax = -inf; 
    yMin = inf; 
    yMax = -inf; 
    
    sud = gcs; 
    sudParams = getParamsByPath(sud);  
    blocks = string(sudParams.Blocks); 
    blockNamesInSud = string.empty; 
    blockTypesInSud = string.empty; 
    for i = 1 : length(blocks)
        block = blocks(i); 
        % some block-names contain the character '/'. But since
        % '/' is used as a separater between parent and child
        % blocks, '/' in a block-name is replaced with '//' 
        block = strrep(block, '/', '//');
        blockPath = sud + "/" + block;
        blockParams = getParamsByPath(blockPath);  % block params 
        blockNamesInSud = [blockNamesInSud blockParams.Name]; 
        blockTypesInSud = [blockTypesInSud blockParams.BlockType]; 
       
        pos = blockParams.Position; 
        xMinBlock = pos(1);
        yMinBlock = pos(2); 
        xMaxBlock = pos(3); 
        yMaxBlock = pos(4); 
        
        if xMinBlock < xMin
            xMin = xMinBlock; 
        end 
        
        if xMaxBlock > xMax
            xMax = xMaxBlock;
        end
        
        if yMinBlock < yMin
            yMin = yMinBlock; 
        end 
        
        if yMaxBlock > yMax 
            yMax = yMaxBlock; 
        end    
    end
    
    blockTypesInSud = unique(blockTypesInSud);  % remove duplicates, sort alphabetically  
    % block names, unlike block-types, are already unique
    blockNamesInSud = sort(blockNamesInSud); % sort alphabetically 
    
    context = Context(xMin, xMax, yMin, yMax, sud, blockNamesInSud, blockTypesInSud, mrcbPath, mrcbBlockType, mrcbPosition, mrcbNeighborsMap); 
end 