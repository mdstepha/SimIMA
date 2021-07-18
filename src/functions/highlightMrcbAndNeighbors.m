function highlightMrcbAndNeighbors(context)
% Highlights the Most Recently Clicked Block (MRCB) and its neighbors
%
% PARAMETERS:
% ----------- 
%   context (Context) : the context of the simulink workspace

    mrcbParams = getParamsByPath(context.mrcbPath); 
    mrcbHandle = mrcbParams.Handle; 
    set_param(mrcbHandle, 'ForegroundColor', 'blue'); 
    
    for i = 1 : length(context.mrcbNeighborsHandles)
        handle = context.mrcbNeighborsHandles(i); 
        set_param(handle, 'ForegroundColor', 'cyan'); 
    end 
end 