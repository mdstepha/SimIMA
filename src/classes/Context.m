classdef Context 
    properties
        
        xMin % x-coordinate value of top-left point of leftmost block in Simulink workspace
        xMax % x-coordinate value of bottom-right point of rightmost block in Simulink workspace
        yMin % y-cooridinate value of top-left point of topmost block in Simulink workspace 
        yMax % y-coordinate value of bottom-right point of bottommost block in Simulink workspace 
        
        sud  % path of (sub)system under development as returned by 'gcs'
        mrcbPath       % str: path of most-recently-clicked-block (as returned by gcb)
        mrcbBlockType  % Most Recently Clicked Block's Block-Type 
        mrcbPosition  % position of MRCB in the format [xMin, yMin, xMax, yMax] 
        blockNamesInSud  % list of all block names (strings, unique, sorted alphabetically) in system-under-development
        blockTypesInSud  % list of all block-types (strings, unique, sorted alphabetically) in system-under-development 
       
        mrcbNeighborsMap  % struct such that each key(str):blockType(as field) of blocks connected to the MRCB, and value (int): count of such neighboring blockTypes 
%         eg: 
%         "Sum": 3
%         "Gain": 1
%         "Outport": 1
        
        suggBlkDim = 50;  % all suggestion panel dimensions will be based on this value 
        
        positionSuggPanelHeaderSS  % position of the header subsystem of block suggestion panel (if block suggestions were to be populated in current context)
        positionSuggPanelBodySS    % position of the body subsystem of block suggestion panel (if block suggestions were to be populated in current context) 
        positionSuggPanelFooterSS  % position of the footer subsystem of block suggestion panel (if block suggestions were to be populated in current context)
    end                   
    
    methods 
        function obj = Context(xMin, xMax, yMin, yMax, ...
                sud, blockNamesInSud, blockTypesInSud, mrcbPath, mrcbBlockType, ...
                mrcbPosition, mrcbNeighborsMap)
            
            obj.xMin = xMin; 
            obj.xMax = xMax; 
            obj.yMin = yMin; 
            obj.yMax = yMax;
            obj.sud = sud; 
            obj.blockNamesInSud = blockNamesInSud; 
            obj.blockTypesInSud = blockTypesInSud; 
            obj.mrcbPath = mrcbPath; 
            obj.mrcbBlockType = string(mrcbBlockType);
            obj.mrcbPosition = mrcbPosition; 
            obj.mrcbNeighborsMap = mrcbNeighborsMap; 
           
            obj = obj.setPositions(); 
            
        end 
        
        % we don't include this function code within constructor because
        % we may need to re-define the position of the suggestion panel 
        % in case a previous context is to be used (assuming the user might
        % have changed 'nSuggsMax' from AdminControl UI -- see code in
        % suggestBlocks.m for such use) 
        function obj = setPositions(obj)
            % for now, suggestion panel header's yMin is same as MRCB's yMin
            % this will be adjusted shortly such that the sugg panel will have
            % same yCenter as that of MRCB (see code below) 
            xMin = obj.mrcbPosition(3) + obj.suggBlkDim / 2; 
            yMin = obj.mrcbPosition(2); 
            xMax = obj.mrcbPosition(3) + 4 * obj.suggBlkDim;  
            yMax = obj.mrcbPosition(2) + obj.suggBlkDim;
            
            obj.positionSuggPanelHeaderSS = [xMin, yMin, xMax, yMax];
            
            yMin = yMax;
            
            state = getSharedVar('simvma_appState');
            
            yMax = yMin + (obj.suggBlkDim / 2) * (3 * state.simgestionNSuggsMax + 1); 
            obj.positionSuggPanelBodySS = [xMin, yMin, xMax, yMax];
            
            yMin = yMax;
            yMax = yMin + obj.suggBlkDim;
            obj.positionSuggPanelFooterSS = [xMin, yMin, xMax, yMax];
            
            % move the suggestion panel vertically so that its yCenter
            % aligns with MRCB's yCenter 
            yCenterMrcb = round((obj.mrcbPosition(2) + obj.mrcbPosition(4)) / 2); 
            yCenterBody = round((obj.positionSuggPanelBodySS(2) + obj.positionSuggPanelBodySS(4))/2);
            shift = yCenterBody - yCenterMrcb; 
         
            obj.positionSuggPanelHeaderSS(2) = obj.positionSuggPanelHeaderSS(2) - shift; 
            obj.positionSuggPanelHeaderSS(4) = obj.positionSuggPanelHeaderSS(4) - shift;
            obj.positionSuggPanelBodySS(2) = obj.positionSuggPanelBodySS(2) - shift; 
            obj.positionSuggPanelBodySS(4) = obj.positionSuggPanelBodySS(4) - shift;
            obj.positionSuggPanelFooterSS(2) = obj.positionSuggPanelFooterSS(2) - shift; 
            obj.positionSuggPanelFooterSS(4) = obj.positionSuggPanelFooterSS(4) - shift; 
        end 
        
    end 
end 