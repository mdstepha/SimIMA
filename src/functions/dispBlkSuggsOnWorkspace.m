function dispBlkSuggsOnWorkspace(suggs, context)
% Displays the block suggestions on user's workspace i.e. Simulink's canvas
% 
%
% PARAMETERS:
% -----------
%   suggs (BlockSuggestion): list of BlockSuggestion objects 
%   context (Context) : the context of the simulink workspace for which 
%                       block suggestions are queried. 
% 

    assignin('base', 'simvma_context', context);  % debugging 
    disp(context);
%     disp(context.mrcbNeighborsMap);
    
%     highlightMrcbAndNeighbors(context); 
    
    maskDisplayHeader = "image('"+ getSimvmaPath() + "/images/sugg-panel-header.png" + "')";  
    maskDisplayFooter = "image('"+ getSimvmaPath() + "/images/sugg-panel-footer.png" + "')";  
    add_block('built-in/Subsystem', context.sud + "/suggPanelHeader", 'Position', context.positionSuggPanelHeaderSS, 'ShowName', 'off', 'MaskDisplay', maskDisplayHeader, 'OpenFcn', handleHeaderClicked);
    add_block('built-in/Subsystem', context.sud + "/suggPanelBody", 'Position', context.positionSuggPanelBodySS, 'ShowName', 'off', 'OpenFcn', handleBodyClicked);
    
    % delete previous footer, if any, first
    try 
        delete_block(context.sud + "/suggPanelFooter")
    catch ME 
    end 
    
    add_block('built-in/Subsystem', context.sud + "/suggPanelFooter", 'Position', context.positionSuggPanelFooterSS, 'ShowName', 'off', 'MaskDisplay', maskDisplayFooter, 'OpenFcn', handleIgnoreSuggestions);
    
    xMinSugg = context.positionSuggPanelBodySS(1) + (context.suggBlkDim); 
    yMinSugg = context.positionSuggPanelBodySS(2) + (context.suggBlkDim / 2);
    xMaxSugg = xMinSugg + context.suggBlkDim;
    yMaxSugg = yMinSugg + context.suggBlkDim;
    
    % point sized 
    xMinPercent = context.positionSuggPanelBodySS(1) + context.suggBlkDim * 2.5;
    yMinPercent = context.positionSuggPanelBodySS(2) + context.suggBlkDim * .9;
    xMaxPercent = xMinPercent; 
    yMaxPercent = yMinPercent; 
    
    percentTexts = string.empty; 
    for i = 1 : length(suggs)        
        % display block 
        sugg = suggs(i);
        posSugg = [xMinSugg yMinSugg xMaxSugg yMaxSugg];
        posPercent = [xMinPercent yMinPercent xMaxPercent yMaxPercent]; 
        
        % Sometimes block-insertion fails. 
        % For example, if there is already a 'control' port in a subsystem,
        % trying to insert another control port fails. 
        % So, we need a try-catch block here. 
        % Such block-insertion failures are notified from both an error
        % dialog and the console.
        try
            add_block(sugg.libPath, sugg.blockPath, 'Position', posSugg, 'HideAutomaticName', 0, ...
                'ForegroundColor', sugg.foregroundColor, 'BackgroundColor', sugg.backgroundColor, ...
                'OpenFcn', handleSuggestionChosen);
            yMinSugg = yMaxSugg + context.suggBlkDim/2;
            yMaxSugg = yMinSugg + context.suggBlkDim; 
            
            yMinPercent = yMinPercent + 1.5 * context.suggBlkDim;
            yMaxPercent = yMinPercent; 
             
        catch ME
            disp("Block Insertion Failed");
            disp(ME);
            dispUnderlined("Details of the block suggestion that failed to insert");
            disp(sugg); 
            dispDlgErr("Failed to insert a block suggestion, see console log for details", "Block Insertion Failure");            
        end
            
        % display block's prediction confidence to its right 
        percentText = round(sugg.confidence * 100) + "%"; 
        % sometimes two block suggestions may have same percentage. In such
        % case, we cannot insert 2 subsystems with same name. So we append
        % a space to the new name to make it unique 
        while (any(strcmp(percentText, percentTexts)))
            percentText = percentText + " ";  % append space character to make the name unique   
        end 
        percentTexts = [percentTexts percentText]; 
        
        blockPath = context.sud + "/" + percentText; 
        add_block('built-in/Subsystem', blockPath, 'Position', posPercent, 'ShowName', 'on');
    end 
    state = getSharedVar('simvma_blockInsertionState');
    state.percentTexts = percentTexts; 
    setSharedVar('simvma_blockInsertionState', state);
end 


function str = handleIgnoreSuggestions()
    % Returns a string of callback function code to handle the event when 
    % the user clickes 'Ignore Suggestions' annotation 
    
    % IMPORTANT: 
    % The callback code which is read from the file 
    % 'src/special-files/handleIgnoreSuggestionsCallbackCode.m' is a 
    % "string" (rather than a function) which is interpreted at runtime (when the event occurs).
    % As a result, even if we pass the arguments to this function, they 
    % won't be available at callback-execution-time. 
    % To mitigate this, we "pass" necessary arguments using the shared-var
    % 'BlockInsertionState'
    str = ""; 
    fid = fopen(getSimvmaPath + "/src/special-files/handleIgnoreSuggestionsCallbackCode.m", 'r'); 
    while ~feof(fid)
        line = fgets(fid); % char vector 
        line = string(line);
        str = str + line; 
    end
    fclose(fid);
end


function str = handleSuggestionChosen()
    % Returns a string of callback function code to handle the event when 
    % the user clickes 'Ignore Suggestions' annotation 
    % 
    % Unfortunately, we cannot pass arguments to this function (just like
    % handleIgnoreSuggestions) 
    
    str = "";  
    fid = fopen(getSimvmaPath + "/src/special-files/handleSuggestionChosenCallbackCode.m", 'r'); 
    while ~feof(fid)
        line = fgets(fid); % char vector 
        line = string(line);
        str = str + line; 
    end
    fclose(fid);
end


function str = handleHeaderClicked()
    str = "disp('header clicked')";
end 

function str = handleBodyClicked()
    str = "disp('body clicked')";
end 