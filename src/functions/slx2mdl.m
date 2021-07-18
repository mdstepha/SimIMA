function slx2mdl(slxFilePath, mdlFilePath)
% Convert slx file to mdl
% 
% parameters: 
% -----------
% slxFilePath   : (string) absoulte path of the slx file to be converted
% mdlFilePath : (string) absoulte path of the mdl file to be created
%                          The corresponding folder will be created if it 
%                          does not exist yet.  
% 
% IMPORTANT: 
% ----------
% - Conversion is not guaranteed to succeed. so, put this function in
%   try-catch construct (in the caller). 
% 
    
    slxFilePath = string(slxFilePath); 
    [mdlFolderPath, mdlFileName, mdlExt] = fileparts(mdlFilePath);  
    
    % create mdl-folder if it does not exist already 
    if ~ exist(mdlFolderPath, 'dir')
        mkdir (mdlFolderPath); 
    end 
    
    load_system(slxFilePath); 
    save_system(gcs, mdlFilePath); % save as mdl 
    close_system(gcs);     
end 

