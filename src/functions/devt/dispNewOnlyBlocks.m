function dispNewOnlyBlocks (fm, am)
% fm : frequency model trained in as many simulink models as possible  

% this function is for development purpose only 
% both oldBlocks and newBlocks are list of strings

    newBlocksFm = transpose(string(fields(fm.data)));
    newBlocksAm = am.blockTypes; 

    newBlocks = [newBlocksFm newBlocksAm]; 

    oldBlocks = string.empty; 
    start = false; 

    fid = fopen("/Users/bhisma/courses/cse-700-simvma/simvma/src/classes/BlockSugg.m", 'r'); 
    while ~feof(fid)
        line = fgets(fid); % char vector 
        line = string(line);

        line = strip(line); 
        if startsWith(line, "builtinBlocks = [...")
            start = true; 
            continue; 
        end 

        if line == "];"
            break; 
        end 

        if start
            block = replace(line, ",...", ""); 
            block = replace(block, '"', ''); 
            oldBlocks = [oldBlocks block]; 
        end  
    end 
    fclose(fid); 

    blocks = setdiff(newBlocks, oldBlocks); 
    for i = 1 : length(blocks)
        disp(blocks(i)); 
    end 
end

