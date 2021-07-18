function clones = getClonesFromXmlFile(xmlFilepath, simvmaPath)
    clones = {};
    fid = fopen(xmlFilepath, 'r');
    
    lineCount = 0; 
    while ~feof(fid) 
        line = fgets(fid); 
        lineCount = lineCount + 1; 
        
        % the occurance of <clone> tag repeats every 5 line, 
        % after line 5, which we leverage
        if lineCount > 5
            mod5 = mod(lineCount, 5);
            
            if mod5==1
                cloneLine = line;
            end 
            
            if mod5==2
                srcLine1 = line; 
            end 
            
            if mod5==3
                srcLine2 = line; 
            end 
            
            % make new Clone object and append to clones 
            if mod5==0
                clone = createCloneFromXmlElementLines(cloneLine, srcLine1, srcLine2, simvmaPath);
                len = length(clones);
                clones{len+1} = clone; 
            end         
        end 
    end 
    fclose(fid); 
end 