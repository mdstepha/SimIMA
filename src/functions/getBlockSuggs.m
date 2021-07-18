function suggs = getBlockSuggs(context, verbose)          
% Returns an array of a maximum of N BlockSuggs, sorted by rank; 
% N is determined by simvma_appState.nSuggsMax 
%
% PARAMETERS:
% -----------
%   context (Context) : the context of the simulink workspace for which 
%                       block suggestions are queried. 
% 
% ASSUMPTION: 
% ----------- 
%  - shared-vars/simvma_freqModel.mat and shared-vars/simvma_armModel.mat 
%    exist
% 
% APPROACH: 
% ---------
%  - context is passed in as an argument 
%  - prediction-models are read from shared-vars 
%  - BlockSuggs are obtained from each prediction model 
%  - A final list of BlockSuggs is prepared based on a 'weighted-model' 
%    approach 
        
    state = getSharedVar('simvma_appState'); 
    
    switch state.simgestionAccuracyLevel
        case 1  % less accurate but fast 
            useArmModel = false;
            useFreqModel = true;
        case 2  % medium accuracy, medium speed 
            useArmModel = true; 
            useFreqModel = false; 
        case 3  % more accurate but slow 
            useArmModel = true; 
            useFreqModel = true;
        otherwise
            error("From getBlockSuggs(): Invalid value for accuracyLevel " + state.simgestionAccuracyLevel); 
    end 
    
    suggsArm = BlockSuggFromPredModel.empty;
    suggsFreq = BlockSuggFromPredModel.empty;
    
    if useArmModel
        armModel = getSharedVar('simvma_armModel');  
        [suggsArm, timeArm] = armModel.predict(context); 
        dispKeyVal('execution time for ArmModel', timeArm);
    end
        
    if useFreqModel
        freqModel = getSharedVar('simvma_freqModel'); 
        [suggsFreq, timeFreq] = freqModel.predict(context); 
        dispKeyVal('execution time for FreqModel', timeFreq);
    end
    
    % display suggestions from prediction models in console 
    if verbose && useArmModel
        dispUnderlinedSpacedAbove("Suggestions from Arm Model")
        for i = 1 : length(suggsArm)
            sugg = suggsArm(i); 
            disp(sugg.blockType + " : " + sugg.confidence); 
        end 
    end 
    if verbose && useFreqModel
        dispUnderlinedSpacedAbove("Suggestions from Freq Model")
        for i = 1 : length(suggsFreq)
            sugg = suggsFreq(i); 
            disp(sugg.blockType + " : " + sugg.confidence); 
        end 
    end 
    
    
    % COMBINE SUGGESTIONS FROM MULTIPLE PREDICTION MODELS
    
    if useArmModel && useFreqModel 
        % weights are tuned experimentally to maximize prediction accuracy
        WEIGHT_ARM = 0.3; 
        WEIGHT_FREQ = 0.7;
    elseif useArmModel && ~useFreqModel
        WEIGHT_ARM = 1;
        WEIGHT_FREQ = 0;   
    elseif ~useArmModel && useFreqModel
        WEIGHT_ARM = 0;
        WEIGHT_FREQ = 1;
    else
        error("Invalid appState: At least 1 block-prediction-model must be used");
    end 
        
    assert(WEIGHT_ARM + WEIGHT_FREQ == 1, "FROM getBlockSuggs.m: Assertion failed: Sum of all weights must be equal to 1.")
    
    % to combine suggestions, we first need to make sure the #suggestions
    % is same from each prediction models (to match matrix dimensions).
    % So, we pad "fake" suggestions (with confidence 0), if necessary. 
    % These fake suggestions will be ignored by combineBlockSuggsFromPredModel()
    nSuggsArm = length(suggsArm); 
    nSuggsFreq = length(suggsFreq);
    nSuggsMax = max(nSuggsArm, nSuggsFreq); 
    
    % pad dummy suggestions to prepare suggs2D (for combineBlockSuggsFromPredModels()) 
    if nSuggsArm < nSuggsMax
        for i = 1 : nSuggsMax - nSuggsArm
            suggsArm = [suggsArm BlockSuggFromPredModel("", 0)];  
        end
    end 
    if nSuggsFreq < nSuggsMax
        for i = 1 : nSuggsMax - nSuggsFreq
            suggsFreq = [suggsFreq BlockSuggFromPredModel("", 0)];  
        end
    end 
    
    % each row contains suggestions from 1 prediction model 
    suggsPredModels2D = [suggsArm; suggsFreq]; 
    % these are sorted by confidence 
    suggsPredModels = combineBlockSuggsFromPredModel(suggsPredModels2D, [WEIGHT_ARM, WEIGHT_FREQ]); 
    
    % create BlockSuggs from suggsPredModels 
    suggs = BlockSugg.empty; 
    reservedBlockNames = context.blockNamesInSud;
    for i = 1 : length(suggsPredModels)
        sugg = suggsPredModels(i); 
        blockType = sugg.blockType; 
        rank = i; 
        confidence = sugg.confidence; 
        blockName = generateBlockName(blockType, reservedBlockNames);
        reservedBlockNames = [reservedBlockNames blockName]; 
        blockPath = context.sud + "/" + blockName;         

        sugg = BlockSugg(blockType, rank, confidence, blockName, blockPath);
        suggs = [suggs sugg]; 
    end 
     
    suggs = filterOutUninsertableBlockSuggs(suggs); 
    
    
    % display suggestions in console 
    if verbose && useArmModel
        dispUnderlinedSpacedAbove("Suggestions from Ensemble Model")
        for i = 1 : length(suggs)
            sugg = suggs(i);
            disp(sugg.blockType + " : " + sugg.confidence); 
        end 
    end 
    
    % limit #suggs 
    state = getSharedVar('simvma_appState');
    if length(suggs) > getSharedVarSimgestionNSuggsMax() 
        suggs = suggs(1 : state.simgestionNSuggsMax); 
    end
end 


function name = generateBlockName(blockType, reservedNames)
    % generate a unique name for the block 
    % convention blockType-followed-by-an-optional-number
    blockType = string(blockType); 
    name = blockType; 
    i = 0;
    while any(strcmp(reservedNames, name))
        i = i + 1; 
        name = blockType + i; 
    end
end 