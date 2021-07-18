function createMdlFileForSimone(mudFilepath, sudPath, simvmaPath)
% Create/Update the mdl file for Simone input. 
% - This file, rather than the actual MUD, is used as Simone input 
%   to overcome the "nested-clone" problem in Simone. 
% - This file contains only the (sub)systems inside and including SUD, 
%   not the (sub)systems outside the SUD. 
% - This, file will always be MDL (not SLX) because Simone works on MDL files only
% - This mdl is a valid mdl file (from Simone's perspective), but not from
%   Simulink's perspective. 
%
% PARAMETERS:
% -----------
% mudFilepath :  string -- absolute filepath of Model Under Development
% sudPath     :  string -- path of (sub)System Under Development. This 
%                should be in format as returned by 'gcs' eg:
%                "mymodel/a/b/mysubsystem"
% simvmaPath  :  string -- absolute path of simvma 
%
% ASSUMPTIONS: 
%   - both mdlFilepath and systemPath are valid. this means: 
%          1. a mdl file exists for given mdlFilepath 
%          2. the mdl file contains a system given by systemPath 
% 
%     IF THIS REQUIREMENT IS NOT SATISFIED, AN ERROR WILL BE THROWN (IT
%     WON'T BE HANDLED) STOPPING FURTHER EXECUTION OF PROGRAM IMMEDIATELY
% 
%   - the mdl file is created by Simulink and is in 'standard' format 
%     such that: 
%       - the first property of System{} is always 'Name'
%       - "{" and "}" appear only one per line (at max), and only as last
%       character (after stripping white space) 
% 

    mudFilepath = string(mudFilepath); 
    sudPath = string(sudPath);
    simvmaPath = string(simvmaPath); 

    % if mudFilepath is an SLX file, first save it in MDL format in
    % simvma/tmp/convertedFromSlx.mdl 
    % IMPORTANT: The filename of the created mdl file must be the same as
    % the slx file (with .mdl extension). Otherwise, sudPath won't be found
    % in the created mdl file and getStartAndEndLinesFromSystemPath() will
    % throw error
    state = getSharedVar('simvma_appState');
    if mudFilepath.lower().endsWith(".slx")
        % % remove previously generated mdl file (if any) in simvma/tmp/simxample-slx2mdl-output/ folder 
        cmd = "rm " + simvmaPath + "/tmp/simxample-slx2mdl-output/*.mdl";
        unix(cmd); 
        
        slxFilepath = mudFilepath;  
        [slxFolderPath, name, ext] = fileparts(slxFilepath);
        destPath = simvmaPath + "/tmp/simxample-slx2mdl-output/" + name + ".mdl"; 
        try
            slx2mdl(mudFilepath, destPath); 
            mudFilepath = destPath; 
            
            % this flag (state.simxampleSavedAsMdl) will be used by
            % updateMUDWithSuggestion() 
            state.simxampleSavedAsMdl = true; 
        catch ME 
            error("ERROR: FAILED TO CONVERT MODEL UNDER DEVELOPMENT TO MDL FORMAT. CANNOT INVOKE SIMXAMPLE WITH THIS PARTICULAR MODEL."); 
        end 
        % slx2mdl conversion closes the MUD. So, we need to open it back.
        open_system(slxFilepath); 
    else 
        state.simxampleSavedAsMdl = false; 
    end 
    setSharedVar('simvma_appState', state);
    
    try
        [sl, el] = getStartAndEndLinesFromSystemPath(mudFilepath, sudPath); 
    catch ME 
        disp("mudFilepath: " + mudFilepath); 
        disp("sudPath: " + sudPath); 
        error("*** ERROR: INVALID ARUGMENT(S)")
    end 
        
    readlines = string.empty;
    fid = fopen(mudFilepath, 'r'); 
    while ~feof(fid)
        line = fgets(fid); % char vector 
        line = string(line);
        readlines = [readlines line];  
    end 
    fclose(fid); 
    
    writelines = ["Model {", newline];  % cannot use \n, coz '\' is escaped
    for i = 1: length(readlines) 
        if i >= sl && i <= el
            writelines = [writelines readlines(i)]; 
        end
    end 
    writelines = [writelines, newline, "}"]; % closing } for "Model"
    
    dirpath = simvmaPath + "/Simone-2.0-Complete-Cygwin64-customized-for-simvma/mdl-file"; 
    % create parent directory for sud.mdl (if it doesnot exist already) 
    if ~ exist(dirpath, 'dir')
        mkdir(dirpath); 
    end
    
    mdlFilepath = dirpath + "/sud.mdl"; 
    
    fid = fopen(mdlFilepath, 'w'); 
    for i = 1:length(writelines)
        line = writelines{i}; 
        line = strrep(line, '%', '%%');  % because '%' is escaped by matlab 
        line = strrep(line, '\', '\\'); 
        fprintf(fid, line); 
    end 
    fclose(fid); 
end 