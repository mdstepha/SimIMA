function structure = getParamsByHandle(handle, sorted)
% Return a struct containing all parameters (sorted alphabetically) of the 
% given handle 
% 
% RAISES_ERROR: Since this function is not guaranteed to succeed, you may 
%               need to use a try-catch construct in the caller. 
%               (see detailed comments in getParamsByHandle.m)
% 
%
% ASSUMPTIONS:
% -----------
% corresponding system is loaded
% 
% PARAMETERS:
% -----------
% handle :  handle -- element's handle. The element can be block-diagram/
%           block/line/...
% sorted(boolean) : -- if true, params are sorted alphabetically
% 
% IMPORTANT: Since this function is not guaranteed to succeed (see comment
%            below), use a try-catch construct in the caller. 

    warning off; 
    
    % 'get(handle)' (and hence this function) raises exception in some cases. 
    % One such case is when one/more of the connected blocks references an unavailable library element. 
    % For example, In the following model: 
    % GitHub/T-MATS-master/Resources/Testing/TestBeds/SolverSS/SolverSS_TestBed.slx
    % if the handle of the block 'SolverSS_TestBed/Bus Selector' is passed
    % to this function, get(handle) raises an exception.
    
    % So, you may want to call this function from a try-catch construct. 
    
    structure = get(handle); % gives warning: Warning: The value of this parameter is only valid when the model is in a compiled state and is a top model.
    warning on; 
    if sorted
        [~, neworder] = sort(lower(fieldnames(structure)));
        structure = orderfields(structure, neworder); 
    end
end 