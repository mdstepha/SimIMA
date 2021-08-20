% PUBLIC METHODS:
% ---------------
% CONSTRUCTOR       : returns an 'empty' model
% trainByFilepath   : update model by training with 1/more mdlSlx files  
% trainByFilehash   : update model by training with 1/more mdlSlx files' hash values  
% predict           : return BlockSuggFromPredModel objects 


classdef FreqModel 
    properties
        
        % 'data' will store the results of training
        % we'll implement this nested map using struct 
        % the following is an illustration of how this 'map' will look like 
                
        % data = {
        %     'Sum': {
        %         'count': 304,           % total number of 'Sum' blocks in
        %                                   training set 
        %         'src':{
        %             'count': 120,       % total number of blocks
        %                                   connected to the src port of 
        %                                   'Sum' blocks in training set. 
        %                                   This is equal to the sum of
        %                                   counts of all blockTypes in
        %                                   details{}. 
        %             'details': {
        %                 'Sum': 55,
        %                 'Gain': 21,
        %                 'Inport': 44,
        %             }
        %         }, 
        %         'dst':{
        %             'count': 167,
        %             'details': {
        %                 'Sum': 35,
        %                 'Gain': 13,
        %                 'Inport': 32,
        %                 'Outport': 87,
        %             }
        %         },
        %         'both':{
        %             'count': 287,
        %             'details': {
        %                 'Sum': 90,
        %                 'Gain': 34,
        %                 'Inport': 76,
        %                 'Outport': 87,
        %             }
        %         },
        %     }, 
        %     'Gain': {
        %         'count': 434,
        %         'src':{
        %             'count': 42,
        %             'details': {
        %                 'Sum': 15,
        %                 'Gain': 23,
        %                 'Inport': 4,
        %             }
        %         }, 
        %         'dst':{
        %             'count': 107,
        %             'details': {
        %                 'Sum': 35,
        %                 'Gain': 13,
        %                 'Inport': 32,
        %                 'Outport': 27,
        %             }
        %         }, 
        %         'both':{
        %             'count': 149,
        %             'details': {
        %                 'Sum': 50,
        %                 'Gain': 36,
        %                 'Inport': 36,
        %                 'Outport': 27,
        %             }
        %         }, 
        %
        %     }, 
        % }
        
        data = struct;
        % hash values of all mdlSlx files with which the model has been
        % trained successfully
        hashTrainingFiles = string.empty; 
        
        % weights are tuned experimentally to maximize prediction accuracy
        WEIGHT_MRCB = 0.8;
        WEIGHT_NEIGHBORS = 0.2;   % 1 - WEIGHT_MRCB      
    end 
    
    methods (Access = public) 

        function obj = FreqModel()
            % This constructor creates an UNTRAINED instance of FreqModel. 
            % The returned FreqModel instance needs to be trained using 
            % train() method 
        end 
        
        function obj = trainByFilepath(obj, mdlSlxAbspaths, verbose)
            % Update the model by adding training data from each mdlSlx file
            % 
            % PARAMETERS: 
            % -----------
            % mdlSlxAbspaths (str or list_of_str) : absolute path of mdlSlx file
            % verbose (boolean) : if true, details are printed.
            % 
            % IMPORTANT: 
            % ----------
            % When training the model with multiple mdlSlx files, call this 
            % method once with all the mdlSlx paths passed (rather than
            % calling this method multiple times, with 1 mdlSlx path at a
            % time). This will speed up computation time as in that case,
            % opened/loaded models need to be reloaded only once
            
            warning off; 
            % these are required to restore the state of previously
            % loaded/open models 
            openPaths = getOpenModelsAbsFilepaths(); 
            loadedOnlyPaths = getLoadedOnlyModelsAbsFilepaths(); 
            bdclose('all');
            
            for i = 1 : length(mdlSlxAbspaths)
                mdlSlxAbspath = mdlSlxAbspaths(i); 
                if verbose 
                    dispSpacedAbove("Count    : " + i + "/" + length(mdlSlxAbspaths)); 
                    disp("path     : " + mdlSlxAbspath);
                end
                [status, fileHash, data_] = obj.extractDetailsAndUpdateCache(mdlSlxAbspath, verbose); 
                if verbose disp("status   : " + status); end
                
                if status == "SUCCESS"
                    obj.data = mergeFreqData(obj.data, data_); 
                    obj.hashTrainingFiles = [obj.hashTrainingFiles fileHash];  
                end
            end
            
            % restore previously loaded/open models
            open_system(openPaths); 
            load_system(loadedOnlyPaths);
            warning on; 
        end 
        
        function obj = trainByFilehash(obj, fileHashes, verbose)
            % Update the model by adding training data from each mdlSlx file.
            % Duplicate fileHashes (i.e. those fileHashes with which the 
            % model is already trained will be ignored). 
            % 
            % This method is intended to be used for merging 2 or more
            % FreqModels. This operation is quick because all data is
            % available in the cache. 
            % 
            % ASSUMPTION:
            % -----------
            % - all mdlSlxHashes exist in the cache file: shared-vars/simvma_freqCache.mat
            % 
            % PARAMETERS: 
            % -----------
            % mdlSlxHashes (str or list_of_str) : hash values of mdlSlx files' content

            cache = getSharedVar('simvma_freqCache'); 
            if verbose dispKeyVal('#hashes', length(fileHashes)); end  
            for i = 1 : length(fileHashes)
                fileHash = fileHashes(i);
                % we avoid training with duplicate files 
                if any(strcmp(obj.hashTrainingFiles, fileHash))
                    status = "DUPLICATE"; 
                else
                    if ~isfield(cache, fileHash)
                        error("From trainByFilehash: No cache data found for : " + fileHash);  
                    end
                    status = cache.(fileHash).status; 
                    if status == "SUCCESS"
                        data_ = cache.(fileHash).data; 
                        obj.data = mergeFreqData(obj.data, data_); 
                        obj.hashTrainingFiles = [obj.hashTrainingFiles fileHash];    
                    end   
                end
                
                if verbose
                    dispSpacedAbove("Count    : " + i + "/" + length(fileHashes)); 
                    disp("hash     : " + fileHash);
                    disp("status   : " + status); 
                end
            end
        end 
        
        
        function [suggs, time] = predict(obj, context)
            % Returns: 
            % 1. a list of BlockSuggFromPredModel objects, sorted by
            %    confidence 
            % 2. the execution time (in seconds).
            % 
            % If no suggestions are possible, it will return an empty list
            % of BlockSuggFromPredModel. 
            % 
            % Each suggestion will have confidence > 0
            % 
            % PARAMETERS: 
            % -----------
            % context (Context object)
            
            % This method will internally call one or more private methods,
            % each of which will return suggestions based on various
            % criteria. Then, based on a weighted-model, this method will
            % prepare final list of suggestions and return them. 
            
            tStart = tic; 
            assert(obj.WEIGHT_MRCB + obj.WEIGHT_NEIGHBORS == 1, "FROM FreqModel.m: Assertion failed: Sum of all weights must be equal to 1.")
            
            % if one of the weights is 1, we don't need to compute others 
            if obj.WEIGHT_MRCB == 1
                suggs = obj.predictByMrcbBlockType(context.mrcbBlockType); 
                time = toc(tStart);
                return; 
            elseif obj.WEIGHT_NEIGHBORS == 1
                suggs = obj.predictByMrcbNeighborsBlockTypes(context.mrcbBlockType); 
                time = toc(tStart);
                return; 
            end 
            
            suggsMrcb = obj.predictByMrcbBlockType(context.mrcbBlockType); 
            suggsNeighbors = obj.predictByMrcbNeighborsBlockTypes(context.mrcbNeighborsMap);
            
            
            % COMBINE SUGGESTIONS FROM MULTIPLE PRIVATE METHODS
            
            % to combine suggestions, we first need to make sure the #suggestions
            % is same from each private methods (to match matrix dimensions).
            % So, we pad "fake" suggestions (with confidence 0), if necessary. 
            % These fake suggestions will be ignored by combineBlockSuggsFromPredModel()
            nSuggsMrcb = length(suggsMrcb);
            nsuggsNeighbors = length(suggsNeighbors); 
            nSuggsMax = max(nSuggsMrcb, nsuggsNeighbors); 
            
            % pad dummy suggestions to prepare suggs2D (for combineBlockSuggsFromPredModel()) 
            if nSuggsMrcb < nSuggsMax 
                for i = 1 : nSuggsMax - nSuggsMrcb
                    suggsMrcb = [suggsMrcb BlockSuggFromPredModel("", 0)];  
                end
            end 
            
            if nsuggsNeighbors < nSuggsMax 
                for i = 1 : nSuggsMax - nsuggsNeighbors
                    suggsNeighbors = [suggsNeighbors BlockSuggFromPredModel("", 0)];  
                end
            end 
            
            % each row contains suggestions from 1 private method 
            suggs2D = [suggsMrcb; suggsNeighbors]; 
            % these are sorted by confidence, and 
            % all suggs have confidence >= 0 
            suggs = combineBlockSuggsFromPredModel(suggs2D, [obj.WEIGHT_MRCB, obj.WEIGHT_NEIGHBORS]);             
            time = toc(tStart); 
        end     
    end

    methods (Access = private) 
        
        function [status, fileHash, data] = extractDetailsAndUpdateCache(obj, mdlSlxAbspath, verbose)
            % Extract details from a mdlSlx file. 
            % This method also updates the cache stored in shared-var/simvma_freqCache.mat, if required
            
            % 
            % PARAMETERS: 
            % mdlSlxAbsPath (str) : absolute path of mdlSlx file 
            %
            % RETURNS:
            % --------
            % status (str): 
            %   "INVALID_PATH" : mdlSlxAbspath does not exist
            %   "INVALID_MDL"  : invalid mdlSlx file (cannot be loaded) 
            %   "DUPLICATE"    : a mdlSlx file with the same content has
            %                    already been used to train the model
            %   "SUCCESS"      : model was updated successfully by training
            %                    with this mdlSlx file
            %   "FAIL"         : something went wrong during when training 
            %                    the model with this mdlSlx file (although the
            %                    mdlSlx file was loaded successfully).
            % fileHash (str): hash value of content; 
            %                 NaN if status == "INVALID_PATH"
            % data (struct) : same as FreqModel.data, but trained on 1 file
            %                 NaN if status != "SUCCESS"
            
            % 
            % IMPORTANT: 
            % ----------
            % This method does not preserve the state of previously loaded
            % simulink models, if any 
            
            % make sure no simulink model is loaded (as it might introduce 
            % some hard-to-debug errors
            bdclose('all'); 
            
            fileHash = NaN; % default 
            data = NaN; % default
            
            if ~exist(mdlSlxAbspath, 'file')
                status = "INVALID_PATH";
                return; 
            end
            
            fileHash = hashByFilepath(mdlSlxAbspath); 
            if any(strcmp(obj.hashTrainingFiles, fileHash))
                status = "DUPLICATE";
                return; 
            end 
            
            % first, see if it is in cache
            cache = getSharedVar('simvma_freqCache'); 
            if isfield(cache, fileHash)
                if verbose disp('Using cache'); end 
                status = cache.(fileHash).status;
                data = cache.(fileHash).data; 
                return; 
            end 
            
            % not found in cache;  need to extract data 
            if verbose disp('Not found in cache'); end 
            
            try
                load_system(mdlSlxAbspath)
            catch ME
                status = "INVALID_MDL";
                return 
            end
            
            data = struct; 
            
            try
                modelName = bdroot; 
                bdParams = getParamsByPath(modelName);  % block diagram params 
                blocks = string(bdParams.Blocks); 
                for i = 1 : length(blocks)
                    block = blocks(i); 
                    % some block-names contain the character '/'. But since
                    % '/' is used as a separater between parent and child
                    % blocks, '/' in a block-name is replaced with '//' 
                    block = strrep(block, '/', '//');
                    blockPath = modelName + "/" + block;
                    blockHandle = get_param(blockPath, 'handle');
                    data = obj.extractDetailsHelper(data, blockHandle);
                end
                status = "SUCCESS"; 
            catch ME
                status = "FAIL"; 
            end    
            
            % update cache 
            cache.(fileHash).status = status; 
            cache.(fileHash).data = data; 
            setSharedVar('simvma_freqCache', cache); 
        end
        
        function data = extractDetailsHelper(obj, data, blockHandle)
            % this method updates only data attribute 
            
            params = getParamsByHandle(blockHandle, false);
            blockType = string(params.BlockType);
            % make blockType compatible to be used as a field in a struct
            blockType = convertBlockTypeToField(blockType); 
            
            if blockType == "SubSystem"
                % go recursively 
                subSystemPath = string(params.Parent) + "/" + string(params.Name);
                blocks = string(params.Blocks);  % inner blocks 
               
                for i = 1 : length(blocks) 
                    block = blocks(i); 
                    % some block-names contain the character '/'. But since
                    % '/' is used as a separater between parent and child
                    % blocks, '/' in a block-name is replaced with '//' 
                    block = strrep(block, '/', '//');
                    blockPath = subSystemPath + "/" + block;
                    blockHandle = get_param(blockPath, 'handle'); 
                    data = obj.extractDetailsHelper(data, blockHandle);
                end
            else % base condition 
                if ~isfield(data, blockType)
                    % add new blockType to data  
                    data.(blockType) = struct(); 
                    data.(blockType).count = 1; 
                    
                    data.(blockType).src = struct(); 
                    data.(blockType).src.('count') = 0;                    
                    data.(blockType).src.('details') = struct();
                    
                    data.(blockType).dst = struct(); 
                    data.(blockType).dst.('count') = 0;                    
                    data.(blockType).dst.('details') = struct();
                    
                    data.(blockType).both = struct(); 
                    data.(blockType).both.('count') = 0;                    
                    data.(blockType).both.('details') = struct();
                else
                    data.(blockType).count = data.(blockType).count + 1; 
                end 
                
                % set/update obj.(blockType).src 
                mapSrc = getConnectedBlockTypesWithCountByBlockHandle(blockHandle, 'src');
                data.(blockType).src.('count') = data.(blockType).src.('count') + sum(cell2mat(mapSrc.values));
                
                % cast to string so they can be used to 
                % 1. check if field exists in structure using isfield()
                % 2. access using parenthesis notation eg. mapSrc(keysSrc(1))
                keysSrc = string(mapSrc.keys); 
                for i = 1 : length(keysSrc)
                   key = keysSrc(i);    % blockType 
                   val = mapSrc(key);   % count 
                   key = convertBlockTypeToField(key); 
                   if ~isfield(data.(blockType).src.details, key)
                       data.(blockType).src.details.(key) = val; 
                   else 
                       data.(blockType).src.details.(key) = data.(blockType).src.details.(key) + val; 
                   end
                end
                
                % set/update obj.(blockType).dst
                mapDst = getConnectedBlockTypesWithCountByBlockHandle(blockHandle, 'dst');
                data.(blockType).dst.('count') = data.(blockType).dst.('count') + sum(cell2mat(mapDst.values));

                keysDst = string(mapDst.keys); 
                for i = 1 : length(keysDst)
                   key = keysDst(i);    % blockType 
                   val = mapDst(key);   % count 
                   key = convertBlockTypeToField(key); 
                   if ~isfield(data.(blockType).dst.details, key)
                      data.(blockType).dst.details.(key) = val;
                   else 
                       data.(blockType).dst.details.(key) = data.(blockType).dst.details.(key) + val;
                   end
                end
                
                % set/update obj.(blockType).both
                mapBoth = getConnectedBlockTypesWithCountByBlockHandle(blockHandle, 'both');
                data.(blockType).both.('count') = data.(blockType).both.('count') + sum(cell2mat(mapBoth.values));
                
                keysBoth = string(mapBoth.keys); 
                for i = 1 : length(keysBoth)
                   key = keysBoth(i);    % blockType 
                   val = mapBoth(key);   % count
                   key = convertBlockTypeToField(key); 
                   if ~isfield(data.(blockType).both.details, key)
                      data.(blockType).both.details.(key) = val;
                   else 
                       data.(blockType).both.details.(key) = data.(blockType).both.details.(key) + val;
                   end
                end     
            end
        end
                
        function suggs = predictByBlockType(obj, blockType, dstOnly)
            % Returns a list of BlockSuggFromPredModel objects based on
            % mrcb (most recently clicked block) type, sorted by confidence 
            % If no suggestions are possible, it will return an empty list
            % of BlockSugg. 
            % 
            % PARAMETERS: 
            % -----------
            %   blockType(str): 
            %       - This is the BlockType (as field) of the block such that the
            %         suggested block is supposed to be connected to that
            %         block. For example, themost recently clicked block, 
            %         or one of its neighbors is a good fit for this argument. 
            %   dstOnly(bool): 
            %       - If true, the suggested block is supposed to be 
            %         connected to ONLY a destination port of this block. 
            %       - If false, the suggested block is supposed to be 
            %         connected to either a source port or a destination
            %         port of this block 
            %       
                      
            blockType = string(blockType);
            blockType = convertBlockTypeToField(blockType); 
            suggs = BlockSuggFromPredModel.empty; 
            
            if isfield(obj.data, blockType)
                if dstOnly
                    % total number of blocks connected at dest port of
                    % argument blockType in entire training set 
                    total = obj.data.(blockType).dst.count;
                else 
                    % total number of blocks connected at both src and dest
                    % ports of argument blockType in entire training set 
                    total = obj.data.(blockType).both.count; 
                end 
                
                dstDetails = obj.data.(blockType).dst.details; % struct 
                sortedDstBlockTypes = sortStructFieldsMaxToMin(dstDetails); 
                
                % The actual number of suggestions may be less than nSuggMax
                % it can even be 0 in which case we return an empty array 
                nSugg = min(length(sortedDstBlockTypes), getSharedVarSimgestionNSuggsMax);
                
                for i = 1 : nSugg
                    blockType_ = sortedDstBlockTypes(i);
                    percentOccurrence = dstDetails.(blockType_) / total;
                    % for FreqModel, confidence is percentOccurrence 
                    sugg = BlockSuggFromPredModel(blockType_, percentOccurrence); 
                    suggs = [suggs sugg]; 
                end
            end
        end
        
        function suggs = predictByMrcbBlockType(obj, mrcbBlockType)
            % Returns a list of BlockSuggFromPredModel objects based on
            % mrcb (most recently clicked block) type, sorted by confidence 
            % If no suggestions are possible, it will return an empty list
            % of BlockSugg. 
            % 
            % PARAMETERS: 
            % -----------
            %   mrcbBlockType(str): 
            %       - This is the BlockType (as field) of the block such that 
            %       - the suggested block is supposed to be connected to a
            %         destination port of this block.
            %         (THIS IS DIFFERENT THAN WHAT HAPPENS IN
            %         predictByMrcbNeighborsBlockTypes) 
            %       - The most recently clicked block is a good fit for
            %         this argument. 
            %       
            suggs = obj.predictByBlockType(mrcbBlockType, true);
        end
        
        
        function suggs = predictByMrcbNeighborsBlockTypes(obj, neighborsMap)
            % Returns a list of BlockSuggFromPredModel objects based on
            % the type of blocks connected radially (1 step away) to the MRCB
            % (most recently clicked block) type, sorted by confidence 
            % If no suggestions are possible, it will return an empty list
            % of BlockSugg. 
            % 
            % PARAMETERS: 
            % -----------
            %   neighborsMap(struct with key=blockType(str), and value=count(int)):
            %       - The key is the BlockType (as field)  of a block which 
            %         is a neighbor of the MRCB such that 
            %       - the suggested block is supposed to be connected to 
            %         either a src port or a dest port of that block. 
            %         (THIS IS DIFFERENT THAN WHAT HAPPENS IN
            %         predictByMrcbNeighborsBlockTypes)
            
            % APPROACH: 
            % - get suggestions for each neighboring blockType
            % - adjust weight of suggestions based on corresponding
            %   blockType's count 
                      
            neighborBlockTypes = string(fields(neighborsMap));
            
            % find total number of neighboring blocks 
            nNeighbors = 0; 
            for i = 1 : length(neighborBlockTypes)
                neighborBlockType = neighborBlockTypes(i); 
                nNeighbors = nNeighbors + neighborsMap.(neighborBlockType);
            end
            
            % This map will be updated with information of blockType and 
            % confidence from each neighbor, and will eventually be used 
            % to create the final suggs list 
            % key : blockType (as field) 
            % value: confidence  
            map = struct;
            
            
            for i = 1 : length(neighborBlockTypes)
                neighborBlockType = neighborBlockTypes(i); 
                suggs = obj.predictByBlockType(neighborBlockType, false); 
                for j = 1 : length(suggs)
                    sugg = suggs(j); 
                    
                    % adjust confidence of suggestion from this neighboring
                    % BlockType, then update confidence of corresponding 
                    % BlockType in map. 
                    
                    sugg.confidence = sugg.confidence * neighborsMap.(neighborBlockType) / nNeighbors; 
                    blockType = sugg.blockTypeAsField;
                    if isfield(map, blockType)
                        map.(blockType) = map.(blockType) + sugg.confidence;
                    else 
                        map.(blockType) = sugg.confidence; 
                    end 
                end
            end 
            
            suggs = BlockSuggFromPredModel.empty; 
            % finally create suggs from map (which now has adjusted
            % confidences for all BlockTypes) 
            sortedBlockTypes = sortStructFieldsMaxToMin(map); % this ensures the suggestions are sorted 

            for i = 1 : length(sortedBlockTypes)
                blockType = sortedBlockTypes(i); 
                sugg = BlockSuggFromPredModel(convertFieldToBlockType(blockType), map.(blockType)); 
                suggs = [suggs sugg]; 
            end 
            
        end
    end
end