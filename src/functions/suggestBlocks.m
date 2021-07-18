function suggestBlocks()
% This is the entry function for generating and displaying block-level
% suggestions directly onto the system under development. 
% This function will be called by a callback function inside
% sl_customization.m 

    simvmaPath = getSimvmaPath(); 
    % capture context, before it gets overridden (potentially) 
    context = getContext(); 
    
    % When suggestBlocks() is called for the first time (after loading Matlab)
    % gcb (and hence context.mrcbPath) give the actual
    % MostRecentlyClickedBlock (by the user). At other times, if the suggestBlocks()
    % is called repeatedly without the user clicking some block in SUD,
    % this value is set to "/path/to/suggPanelFooter". So, we use the previous 
    % MostRecentlyClickedBlock (by the user) in such cases. 
    %
    % However, we still make sure that the most recent nSuggsMax (this
    % could have been updated from last one) is used to decide the "size" 
    % of the suggestion panel 
    if context.mrcbPath.endsWith("suggPanelFooter")
        context = evalin('base', 'simvma_context');  % load from workspace
        context = context.setPositions(); 
    end 
    assignin('base', 'simvma_context', context);  % not just for debugging 
    
    suggs = getBlockSuggs(context, true);
    assignin('base', 'simvma_suggs', suggs);  % for debugging 
    if length(suggs) == 0
        dispDlgMsg("Sorry, no suggestions were found!", "Suggestion Not Found"); 
        return; 
    end
    
    % blockInsertionState must be shared using shared-vars, because it 
    % cannot be passed as argument to the callback function code (see 
    % more explanation in dispBlkSuggsOnWorkspace.m) 
    % blockInsertionState.percenTexts will be set from inside
    % dispBlkSuggsOnWorkspace() 
    blockInsertionState = BlockInsertionState(context, suggs, NaN);  
    setSharedVar('simvma_blockInsertionState', blockInsertionState); 
    
    dispBlkSuggsOnWorkspace(suggs, context); 
end 

