function exportMdlAsPng(mdlFilepath, pngFilepath)
% export MDL file as PNG file 
    
    [fPath, fName, fExt] = fileparts(mdlFilepath);

    loadedPreviously = bdIsLoaded(fName); 
    
    if ~loadedPreviously
        load_system(mdlFilepath); 
    end 
    
    print("-s" + fName, "-dpng", pngFilepath);  % print('-sadder', '-dpng', 'adder.png')

    % make sure, if the system was loaded before calling this function, 
    % it remains loaded, and vice-versa 
    if ~loadedPreviously
        close_system(mdlFilepath); 
    end 
end 