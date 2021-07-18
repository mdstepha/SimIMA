function createMdlFileFromSource(source, targetMdlFilepath, simvmaPath)
% Create a mdl file for which the top level system will be that
% corresponding to 'source' 

    sourceFilepath = source.realFilepath;  % must use source.realFilepath, rather than source.filepath for Windows-compatiblity. 
    blankMdlFilepath = simvmaPath + "/special-files/blank_r2012b.mdl"; 
    copyfile(blankMdlFilepath, targetMdlFilepath); 

    SYSTEM_START_LINE_IN_BLANK_MDL_FILE = 732; 
    SYSTEM_END_LINE_IN_BLANK_MDL_FILE = 748; 
    
    writelines = {};  % lines to be written to target mdl file     
    
    % lines in blank.mdl from beginning to the line above System {
    fid = fopen(blankMdlFilepath, 'r'); 
    lineCount = 0; 
    while ~feof(fid) 
        line = fgets(fid); 
        lineCount = lineCount + 1; 
        
        if lineCount < SYSTEM_START_LINE_IN_BLANK_MDL_FILE
            len = length(writelines); 
            writelines{len+1} = line;  
        end 
    end 
    fclose(fid); 
    
    % lines in clone source file corresponding to System {}
    fid = fopen(sourceFilepath, 'r');
    lineCount = 0; 
    while ~feof(fid) 
        line = fgets(fid); 
        lineCount = lineCount + 1; 
        
        if lineCount >= source.startline && lineCount <= source.endline
            len = length(writelines); 
            writelines{len+1} = line;  
        end 
    end 
    fclose(fid); 
    
    % lines in blank.mdl from the line below } (of System) till the end of
    % file
    fid = fopen(blankMdlFilepath, 'r'); 
    lineCount = 0; 
    while ~feof(fid) 
        line = fgets(fid); 
        lineCount = lineCount + 1; 
        
        if lineCount > SYSTEM_END_LINE_IN_BLANK_MDL_FILE
            len = length(writelines); 
            writelines{len+1} = line;  
        end 
    end 
    fclose(fid); 
    
    fid = fopen(targetMdlFilepath, 'w'); 
    for i = 1:length(writelines)
        line = writelines{i}; 
        line = strrep(line, '%', '%%');  % because '%' is escaped by matlab 
        fprintf(fid, line); 
    end 
    fclose(fid); 
end 