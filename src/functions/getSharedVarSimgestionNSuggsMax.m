function value = getSharedVarSimgestionNSuggsMax()
% Return the value of the shared variable simvma_appState.nSuggsMax.
% Created this function because this variable (nSuggsMax) is frequently
% accessed. 
% 
    state = getSharedVar('simvma_appState');
    value = state.simgestionNSuggsMax;
end 