function clones = sortClonesBySimilarity(clones)
% sort clones by similarity, high to low 

    for i = 1:length(clones)-1
        for j = i+1:length(clones)
            if clones{i}.similarity < clones{j}.similarity
                % swap 
                tmp = clones{i};
                clones{i} = clones{j};
                clones{j} = tmp;
            end 
        end
    end     
end

