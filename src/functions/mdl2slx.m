function mdl2slx(mdlFilePath, slxFilePath)
% Convert mdl file to slx
% 
% parameters: 
% -----------
% mdlFilePath   : (string) absoulte path of the mdl file to be converted
% slxFilePath : (string) absoulte path of the slx file to be created
%                          The corresponding folder will be created if it 
%                          does not exist yet.  
% 
% IMPORTANT: 
% ----------
% - Conversion is not guaranteed to succeed. so, put this function in
%   try-catch construct (in the caller). 
% 
    
    mdlFilePath = string(mdlFilePath); 
    [slxFolderPath, slxFileName, slxExt] = fileparts(slxFilePath);  
    
    % create slx-folder if it does not exist already 
    if ~ exist(slxFolderPath, 'dir')
        mkdir (slxFolderPath); 
    end 
    
    load_system(mdlFilePath); 
    save_system(gcs, slxFilePath); % save as slx 
    close_system(gcs);     
end 