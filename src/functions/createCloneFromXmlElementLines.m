function clone = createCloneFromXmlElementLines(cloneLine, srcline1, srcline2, simvmaPath)
    tokens = split(cloneLine);
    
    nlinesTokens = split(tokens(2), '=');
    nlines = nlinesTokens(2);
    nlines = cell2int(nlines);
    
    similarityTokens = split(tokens(3), '=');
    similarityTokens = split(similarityTokens(2), '>');
    similarity = similarityTokens(1);
    similarity = cell2int(similarity);
    
    source1 = createSourceFromXmlElement(srcline1, simvmaPath);
    source2 = createSourceFromXmlElement(srcline2, simvmaPath);
    
    clone = Clone(nlines, similarity, source1, source2);
end 

function value = cell2int(value)
    value = char(value);
    len = length(value);
    value = value(2:len-1);
    value = string(value);
    value = double(value);
    value = int64(value);
end 