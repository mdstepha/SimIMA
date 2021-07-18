% callback function code for "Ignore Suggestions" button 

state = getSharedVar('simvma_blockInsertionState'); 

% delete all suggested blocks 
for i = 1 : length(state.suggs)
   sugg = state.suggs(i); 
   try
       delete_block(sugg.blockPath); 
   catch ME
   end
end


% delete all percentages 
for i = 1 : length(state.percentTexts)
    percentText = state.percentTexts(i);
    percentTextPath = state.context.sud + "/" + percentText;
    try
        delete_block(percentTextPath); 
    catch ME 
    end 
end 

% unhighlightMrcbAndNeighbors(state.context, true); 

% delete suggestion panel header
try 
    delete_block(state.context.sud + "/suggPanelHeader"); 
catch ME 
end 

% delete suggestion panel body
try 
    delete_block(state.context.sud + "/suggPanelBody"); 
catch ME 
end

% - Unlike the header and the body, we are not able to delete the footer
%   subsystem (because we are in its own callback function)
% - To make it look like the subsystem is deleted, we set its size to a
%   point-size, and place it at the origin (away from any other blocks)
% - We delete this point-sized footer when "Simvma:Suggest Blocks" is called
%   next time (see dispBlkSuggsOnWorkspace.m) 

footerPath = state.context.sud + "/suggPanelFooter"; 
set_param(footerPath, 'Position', [0 0 0 0]); 

% reset the shared var simvma_blockInsertionState 
setSharedVar('simvma_blockInsertionState', BlockInsertionState(NaN, NaN, NaN)); 

% % finally adjust zoom level 
% set_param(blockInsertionState.context.sud, 'ZoomFactor', 'fit to view'); 
    
