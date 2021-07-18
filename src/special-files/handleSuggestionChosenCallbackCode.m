% callback function code for individual suggested block (when chosen) 

state = getSharedVar('simvma_blockInsertionState'); 
disp(state);

% the chosen suggestion must be the same as returned by gcb. 
chosenSuggBlockPath = gcb; 


% delete all suggested blocks except the chosen 
for i = 1 : length(state.suggs)
   sugg = state.suggs(i); 
   if sugg.blockPath ~= chosenSuggBlockPath
       try
           delete_block(sugg.blockPath);
       catch ME 
       end
   end 
end


% reset chosen sugg block's Open funn
set_param(chosenSuggBlockPath, 'OpenFcn', resetOpenFcn); 

% delete all percentages 
for i = 1 : length(state.percentTexts)
    percentText = state.percentTexts(i);
    percentTextPath = state.context.sud + "/" + percentText; 
    disp("deleting " + percentTextPath);
%     try 
%         delete_block(percentTextPath);
%     catch ME 
%     end 
    delete_block(percentTextPath); 
end 


% delete suggestion panel header
delete_block(state.context.sud + "/suggPanelHeader"); 

% delete suggestion panel body
delete_block(state.context.sud + "/suggPanelBody"); 

% delete suggestion panel footer
delete_block(state.context.sud + "/suggPanelFooter"); 

% unhighlightMrcbAndNeighbors(blockInsertionState.context, true); 


% reset the shared var simvma_blockInsertionState 
setSharedVar('simvma_blockInsertionState', BlockInsertionState(NaN, NaN, NaN)); 


% % finally adjust zoom level 
% set_param(blockInsertionState.context.sud, 'ZoomFactor', 'fit to view'); 
%     


