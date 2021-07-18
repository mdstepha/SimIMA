function filteredClones = filterOutClonesBeyondThreshold(clones, thresholdLower, thresholdUpper)
    filteredClones = {};
    for i = 1:length(clones)
        c = clones{i};
        if c.similarity >= thresholdLower && c.similarity <= thresholdUpper 
            filteredClones{end+1} = c;
        end 
    end 
end