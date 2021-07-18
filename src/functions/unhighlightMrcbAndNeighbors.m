function unhighlightMrcbAndNeighbors(context, resetAll)
% Undo Highlighting of  the Most Recently Clicked Block (MRCB) and its neighbors
%
% PARAMETERS:
% ----------- 
%   context (Context) : the context of the simulink workspace
%   resetAll (bool)   : If true, all blocks in SUD will be unhighlighted, 
%                       If false, only MRCB and neighbors will be
%                       unhilighted. 

    if resetAll
        params = getParamsByPath(context.sud); 
        blocks = string(params.Blocks);  % all blocks in SUD 
               
        for i = 1 : length(blocks) 
            block = blocks(i); 
            % some block-names contain the character '/'. But since
            % '/' is used as a separater between parent and child
            % blocks, '/' in a block-name is replaced with '//' 
            block = strrep(block, '/', '//');
            blockPath = context.sud + "/" + block;
            set_param(blockPath, 'ForegroundColor', 'black'); 
        end
        
    else 
        mrcbParams = getParamsByPath(context.mrcbPath); 
        mrcbHandle = mrcbParams.Handle; 
        set_param(mrcbHandle, 'ForegroundColor', 'black'); 

        for i = 1 : length(context.mrcbNeighborsHandles)
            handle = context.mrcbNeighborsHandles(i); 
            set_param(handle, 'ForegroundColor', 'black'); 
        end 
    end 
end 