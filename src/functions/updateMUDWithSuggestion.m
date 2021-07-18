function updateMUDWithSuggestion(SUD, suggestion, MUDFilepath, simvmaPath)
% Update the Model-Under-Development (MUD) with suggestion
%
% PARAMETERS:
% -----------
% SUD         : string -- (sub)system (which is to be updated)
%               This should be in format as returned by 'gcs' eg:
%               "mymodel/a/b/mysubsystem"
% suggestion  : Suggestion object 
% MUDFilepath : string -- absolute path of Model-Under-Development
% simvmaPath  : string -- absolute path of simvma project
%
% ASSUMPTIONS: 
% - MUD i.e. mdl file at MUDFilepath is loaded 
% - mdl file corresponding to suggestion may or may not be loaded. 
%   In either case, the state of the file (loaded/not-loaded) will be
%   preserved. 
% 
% APPROACH: 
% - There are 4 possible cases -- Handle each case separately. 

% =========================================================================
    
    dispTitle("updating complete (sub)system"); 

%     disp(suggestion); 
%     disp(suggestion.source); 
    
    
    % in case suggestion's Mdl filepath needs to be changed, change
    % sugMdlFilepath, not suggestion.source.realFilepath.
    % In Matlab, the following string assignment is "by value", not "by reference"
    % so, we can safely change sugMdlFilepath as needed. 
    sugMdlFilepath = suggestion.source.realFilepath; 
    
    SFS = getSystemPathFromStartline(sugMdlFilepath, suggestion.source.startline);    

    disp(""); 
    disp("SUD   : " + SUD); 
    disp("SFS   : " + SFS); 
    disp("MUDFilepath : " + MUDFilepath); 
    disp("Suggestion Filepath : " + sugMdlFilepath); 
    
    
    % find whether suggestion's mdl file is loaded 
    % this is required to preserve its state   
    sugMdlWasLoaded = isLoadedByAbspath(sugMdlFilepath); 
    if ~sugMdlWasLoaded
        % if the mdl file corresponding to the suggestion (sugMdl) and MUD have
        % the same name, it is not possible to load both the models as such. 
        % In such condition, we need to rename one of them (to load sugMdl).
        % We choose sudMdl to rename following the following steps: 
        % 1. rename sudMdl such that it doesnot conflict with any loaded system
        % 2. load sudMdl
        % 3. copy sudMdl to MUD 
        % 4. close sudMdl 
        % 5. restore original name of sudMdl 
        
        
        sugMdlFilepathChanged = false;
        sugMdlFilepathOriginal = sugMdlFilepath; 
        
        if filenamesMatch(MUDFilepath, sugMdlFilepath)
            % backup of original sugMdl file 
            sugMdlBackupFilepath = simvmaPath + "/tmp/sugMdlBackup.mdl"; 
            copyfile(sugMdlFilepath, sugMdlBackupFilepath); 

            [folder, bdName, ext] = fileparts(sugMdlFilepath);
            bdName = bdName + "_9dsf598sdf473"; % add a random string 
            
            sugMdlFilepath = folder + filesep + bdName + ext;
            movefile(sugMdlFilepathOriginal, sugMdlFilepath); % rename file i.e move file 
            sugMdlFilepathChanged = true;
            
            % update SFS 
            tokens = SFS.split('/'); 
            tokens(1) = bdName; 
            SFS = tokens.join('/'); 
        end 
            
        load_system(sugMdlFilepath);         
    end   
    
    
    %======================================================================
    
    % by now, both SUD and SFS are loaded, so we can safely call getNInportOutport 
    [nInportSud, nOutportSud] = getNInportOutport(SUD); 
    [nInportSfs, nOutportSfs] = getNInportOutport(SFS);

    
    sudIsTop = isTopSystem(SUD); 
    sfsIsTop = isTopSystem(SFS);  
    
    % based on whether SUD and SFS are top-system or sub-system, 
    % there are 4 possible cases.
    
    postAction = "NONE"; 
    
    if sudIsTop && sfsIsTop
        dispTitle("CASE I -- SUD:TOP, SFS:TOP"); 
        postAction = handleTopTop(SUD, MUDFilepath, sugMdlFilepath);         
        
    elseif sudIsTop && ~sfsIsTop
        dispTitle("CASE II -- SUD:TOP, SFS:SUB"); 
        % replaceTopSystemBySubSystemContents(SUD, SFS);  % fails in some cases (read detailed comments below)  
        
        % Earlier, we used the function replaceTopSystemBySubSystem() to
        % accmplish this task. However, it was found that this function
        % fails in some cases (not understood fully). For example, when the
        % replacer subsystem is a "Function" or a "Chart". 
        % To avoid the problem altogether, we now "convert" this case
        % (Top,Sub) to the first case i.e. (Top, Top). This conversion is
        % possible because we already have the corresponding suggestion's
        % mdl file (in simvma/tmp/simample-suggs/) which contains exactly 
        % the replacer subsystem as the top-level system.
        
        postAction = handleTopTop(SUD, MUDFilepath, suggestion.mdlFilepath);         
        
    elseif ~sudIsTop && sfsIsTop 
        dispTitle("CASE III -- SUD:SUB, SFS:TOP"); 
        postAction = handleSubTop(SUD, SFS, MUDFilepath, simvmaPath, sugMdlFilepath, nInportSud, nOutportSud, nInportSfs, nOutportSfs); 
        
    else 
        dispTitle("CASE IV -- SUD:SUB, SFS:SUB"); 
        postAction = handleSubSub(SUD, SFS, MUDFilepath, nInportSud, nOutportSud, nInportSfs, nOutportSfs); 
    end 
    
    %======================================================================
  
    
    % at this stage, sugMdl is loaded 
    % And, its filename MIGHT have changed (in case it originally matched
    % with the MUD's filename. 
    % 
    % We now want to restore the original state of sugMDL (i.e. its
    % filename, and its loaded/not loaded state) 

    if ~sugMdlWasLoaded
        close_system(sugMdlFilepath); 
        if sugMdlFilepathChanged
            movefile(sugMdlBackupFilepath, sugMdlFilepathOriginal); 
            delete(sugMdlFilepath); 
        end 
    end 
    
    % post-replacement stuffs 
    disp("postAction : " + postAction); 
    
%     if postAction == "ADJUST_CONN"
%         msg = "Sub-System under development has been replaced with the suggested Sub-System." + newline + newline + ...
%             "You may need to adjust signal lines connecting to/from the replaced sub-system."; 
%         dispDlgMsg(msg); 
%     end 
    
    if postAction == "ADJUST_CONN"
        msg = "Sub-System under development has been replaced with the suggested Sub-System." ... 
            + newline + newline + "You may need to adjust signal lines connecting to/from the replaced sub-system." ... 
            + newline + newline + "Number of Inports in Subsystem Under Development = " + nInportSud ...
            + newline + "Number of Inports in Suggested subsystem = " + nInportSfs ...
            + newline + "Number of Outports in Subsystem Under Development = " + nOutportSud ...
            + newline + "Number of Outports in Suggested subsytem = " + nOutportSfs; 
        
        dispDlgMsg(msg); 
    end 
    
    
end 


function postAction = handleTopTop(SUD, MUDFilepath, sugMdlFilepath)
    state = getSharedVar('simvma_appState'); 
    
    % If the user is working on MDL-formatted model, replacement is
    % straightforward -- simply replace the entire MUD's MDL file with
    % suggestion's MDL file
    % 
    % However, if the user is working on SLX-formatted model, replacement
    % is not straightforward (we cannot put MDL content into an
    % SLX-formatted file). In such case, we: 
    % 1. replace a temporary MDL file simvma/tmp/simxample-slx2mdl-output/*.mdl 
    %    (which is already created by createMdlFileForSimone()) with
    %    sugMdlFilepath's content 
    % 2. convert the temporary MDL file to slx format such that the slx
    %    file so created has same name as MUDFilepath. This effectively replaces 
    %    the original MUD SLX file with the one obtained from conversion. 
    
    if state.simxampleSavedAsMdl
        % we use the file simvma/tmp/slx2mdl-output/*.mdl (created earlier by 
        % createMdlFileForSimone() as a temporary file
        [folder, filename, ext] = fileparts(MUDFilepath);
        destMdlFilepath = getSimvmaPath() + "/tmp/simxample-slx2mdl-output/" + filename + ".mdl"; 
        
        close_system(MUDFilepath); 
        open_system(destMdlFilepath); 
        replaceMdlFileContent(destMdlFilepath, sugMdlFilepath); 
        close_system(destMdlFilepath); 
        
        mdl2slx(destMdlFilepath, MUDFilepath);  % MUDFilepath is .slx file 
        open_system(MUDFilepath); 
    else 
        replaceMdlFileContent(MUDFilepath, sugMdlFilepath); 
    end 

    postAction = "NONE"; 
    
    % change view to top level 
    % assuming the model is loaded (which is true, here), open(bdname) does
    % the job 
    open_system(SUD); 
end 


function postAction = handleSubTop(SUD, SFS, MUDFilepath, simvmaPath, sugMdlFilepath, nInportSud, nOutportSud, nInportSfs, nOutportSfs)

    % APPROACH 
    % 1. copy the suggestion's mdl file to simvma/tmp with the same name as
    %    the original mdl file
    % 2. load the copied file (just load, don't open) 
    % 3. wrap the suggested-top-system (from this copied file) in a
    %    sub-system 
    % 4. save it.  
    % 5. now it is equivalent to case III (sub,sub); handle accordingly
        
    dispUnderlined("handling SUD:sub, SFS:top"); 
    disp("SUD : " + SUD);
    disp("SFS : " + SFS);
    
    
    [folder_, sugMdlFilename, ext] = fileparts(sugMdlFilepath);
    destPath = simvmaPath + "/tmp/" + sugMdlFilename + ext;
    
    
    copyfile(sugMdlFilepath, destPath); 
    
    % close if the suggestion-mdl-file (original one) is already open
    % because Matlab does not allow to open two models with same name (in
    % different folders) simultaneously 
    
    % the second arg (0) is to suppress warning, in case the model is not
    % already open 
    close_system(sugMdlFilename, 0); 
    % load the copied file 
    load_system(destPath); 
    wrapperSystem = wrapInSystem(sugMdlFilename); 
    save_system(destPath);  
    
    % wrapperSystem will serve as the SFS 
    postAction = handleSubSub(SUD, wrapperSystem, MUDFilepath, nInportSud, nOutportSud, nInportSfs, nOutportSfs); 
    
    close_system(destPath); 
end 


function postAction = handleSubSub(SUD, SFS, MUDFilepath, nInportSud, nOutportSud, nInportSfs, nOutportSfs)
    
    postAction = "NONE"; 
    
    dispUnderlined("handling SUD:sub, SFS:sub"); 
    disp("SUD : " + SUD); 
    disp("SFS : " + SFS); 
    
   
    if subSystemsCompatibleForReplacement(SUD, SFS)
        postAction = replaceSubSystem(SUD, SFS, MUDFilepath); 
    else
        dispImp("Subsystems incompatible for replacement. Asking user for confirmation..."); 
        
        question = "The subsystems are not compatible for replacement due to a mismatch in number of input/output ports." ...
            + newline + "If you choose to replace your sub-system with the suggested sub-system, you will need to adjust the ports and connections." ...
            + newline + newline + "Do you still want to proceed with the replacement?";
        
        question = "The subsystems are not compatible for replacement due to a mismatch in number of input/output ports." ...
            + newline + newline + "Number of Inports in Subsystem Under Development = " + nInportSud ...
            + newline + "Number of Inports in Suggested subsystem = " + nInportSfs ...
            + newline + "Number of Outports in Subsystem Under Development = " + nOutportSud ...
            + newline + "Number of Outports in Suggested subsytem = " + nOutportSfs ...
            + newline + newline + "If you choose to replace your sub-system with the suggested sub-system, you will need to adjust the ports and connections." ...
            + newline + newline + "Do you still want to proceed with the replacement?";
        
        if (dispDlgConfirmation(question))
            postAction = replaceSubSystem(SUD, SFS, MUDFilepath); 
        end
    end
end 