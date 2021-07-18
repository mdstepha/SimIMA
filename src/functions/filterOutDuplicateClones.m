function clones = filterOutDuplicateClones(clones)
% Often, more than 1 clones (in repositories) have same similarity with the 
% SUD. In many cases, these clones (from repos) are 100% similar to each
% other too. In such case, we don't want to display duplicate suggestions.
% (for example same suggestion (after renamingg) in 1st and 2nd rank). This
% function filters such duplicate clones. 
% 
% This filtration is simple and computationally affordable. It is based on 
% comparing clone.similarity and clone.nlines. This filters out "duplicate" 
% clones (intended), but also filters out those clones which are not 
% duplictes even though they match in similarity and nlines (not intended).  
% 
% A more strict filteration approach would be one based on Simone
% similarity value between the potential duplicate clones (those with same
% % similarity with SUD). However, that would require us to compute Simone
% similarity for each clone-pairs matching in percentage similarity with
% the SUD, and would be phrohibitively time-intensive
    
    clonesBak = clones; 
    clones = {};
    for i = 1 : length(clonesBak)
        clone = clonesBak{i}; 
        if ~matchesAnyPrevious(clone, clones)
            clones{end + 1} = clone; 
        end
    end 
end

function present = matchesAnyPrevious(clone, prevClones)
% Returns true if clone matches any 1 of prevClones (in terms of nlines and
% similarity. Else returns false 
    present = false; 
    for i = 1 : length(prevClones)
        pc = prevClones{i};
        if clone.similarity == pc.similarity && clone.nlines == pc.nlines
            present = true;
            return;
        end 
    end 
end 