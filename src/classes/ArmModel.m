% PUBLIC METHODS:
% ---------------
% CONSTRUCTOR       : returns an 'empty' model
% trainByFilepath   : update model by training with 1/more mdlSlx files  
% trainByFilehash   : update model by training with 1/more mdlSlx files' hash values  
% predict           : return BlockSuggFromPredModel objects 


classdef ArmModel  
    properties
        
        % "data" is a struct such that
        % each field denotes a (sub)system contained in the training models 
        % the corresponding field value is a list of BlockTypes (strings) 
        % contained in that (sub)system. 
        % Since a Simulink model potentially contains multiple sub-systems,
        % it can give multiple such fields. 
        % For an instance of ArmModel, data contains one entry for each 
        % (sub)system contained in the training mdlSlx files 
        
        % data may look like follows: 
        % data = {
        %    'ss1' : ["Sum", "Gain"],
        %    'ss2' : ["Inport", "Sum", "Scope"],
        %    'ss3' : ["Gain", "Outport", "Sine"], ...
        % }
        
        data = struct; 
        
        % "table" is a result of "processing" 'data'. 
        % A table generated after training an armModel on several mdlSlx files
        % containing above data can be visualized as follows:
        % 
        % Gain    Inport  Outport Scope  Sine  Sum
        % ----    ------  ------- -----  ----  ---
        % 1       0       0       0      0     1
        % 0       1       0       1      0     1
        % 1       0       1       0      1     0 
        
        % Thus, 
        % - 'table' serves as the table on which we can run the 
        %   "standard" association-rule-mining algorithm
        % - For convenience, block types are sorted alphabetically (note
        %   that 'table' won't contain the first row i.e. the blockTypes'
        %   names. It only contains a 2D matrix of 0s and 1s such that each
        %   trainining row is represented by a row of the matrix. Which
        %   blockTypes are present in this table's data is resolved by the 
        %   attribute 'blockTypes' which stores the blockTypes in a list
        %   sorted alphabetically. Thus, the first row in above
        %   visualization of table is actually stored in the attribute 
        %   'blockTypes'. 
        table; % 2D boolean array
        % 'blockTypes' stores the header row of table (read comment for
        % 'table') 
        blockTypes = string.empty  
        
        % hash values of all mdlSlx files with which the model has been
        % trained successfully
        hashTrainingFiles = string.empty; 
        
        % When "finding" Association Rule Mining rules, the antecedent
        % block-type count must be >= this fraction. For detailed comments,
        % see method predict()
        ANT_REDUCTION = 0.5;  % tuned experimentally to maximize prediction accuracy 
    end 
    
    methods (Access = public) 

        function obj = ArmModel()
            % This constructor creates an UNTRAINED instance of ArmModel. 
            % The returned ArmModel instance needs to be trained using 
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
            
            % APPROACH: 
            % ---------
            % Training is accomplished in 2 phases.
            % PHASE 1: The following are set: 
            % - data 
            % - hashTrainingFiles 
            % PHASE 2: The following are set: 
            % - blockTypes 
            % - table 
           
            warning off; 
            % these are required to restore the state of previously
            % loaded/open models 
            openPaths = getOpenModelsAbsFilepaths(); 
            loadedOnlyPaths = getLoadedOnlyModelsAbsFilepaths(); 
            bdclose('all');
            
            % PHASE 1 (set data, hashTrainingFiles)
            for i = 1 : length(mdlSlxAbspaths)
                mdlSlxAbspath = mdlSlxAbspaths(i); 
                if verbose 
                    dispSpacedAbove("Count    : " + i + "/" + length(mdlSlxAbspaths)); 
                    disp("path     : " + mdlSlxAbspath);
                end
                [status, fileHash, data_] = obj.extractDetailsAndUpdateCache(mdlSlxAbspath, verbose);
                if verbose disp("status   : " + status); end
                
                if status == "SUCCESS"
                    obj.data = mergeArmData(obj.data, data_); 
                    obj.hashTrainingFiles = [obj.hashTrainingFiles fileHash];  
                end
            end
            
            % PHASE 2 (set blockTypes, table) 
            obj = obj.setBlockTypesAndTable(); 
            
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
            % ArmModels. This operation is quick because all data is
            % available in the cache. 
            % 
            % ASSUMPTION:
            % -----------
            % - all mdlSlxHashes exist in the cache file: shared-vars/simvma_armCache.mat
            % 
            % PARAMETERS: 
            % -----------
            % mdlSlxHashes (str or list_of_str) : hash values of mdlSlx files' content

            cache = getSharedVar('simvma_armCache'); 
            if verbose dispKeyVal('#hashes', length(fileHashes)); end  
            
            % PHASE 1 (set data, hashTrainingFiles)
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
                        obj.data = mergeArmData(obj.data, data_); 
                        obj.hashTrainingFiles = [obj.hashTrainingFiles fileHash];    
                    end   
                end
                
                if verbose
                    dispSpacedAbove("Count    : " + i + "/" + length(fileHashes)); 
                    disp("hash     : " + fileHash);
                    disp("status   : " + status); 
                end
            end
            
            % PHASE 2 (set blockTypes, table) 
            obj = obj.setBlockTypesAndTable(); 
        end 
                
        
        function [suggs, time, n, r, blockTypesAnt] = predict(obj, context)
            % Returns: 
            % 1. a list of BlockSuggFromPredModel objects, sorted by
            %    confidence 
            % 2. the execution time (in seconds).
            % 3. n (of C(n,r)) 
            % 4. r (of C(n,r)) 
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
            
             
            
            % OBSERVATION: It is not very likely to find rows in the table
            % with all blockTypes in SUD present (This is especially true
            % if the training dataset is not big enough). As a result nRowsAnt
            % often becomes zero, thus not producing any suggestion. To
            % circumvent this, we "relax" the antecedent by chosing removing 
            % some of the blockTypes present in SUD from the antecedent. In
            % doing so, we try all possible combinations for a fixed tuned 
            % ANT_REDUCTION -- the MRCB block type is always present in each 
            % combination because we regard it to be more important than others.
            % If at least 1 suggestion (which is not already present in SUD)
            % is found from a particular combination, we stop immediately. 
            
            
            tStart = tic;

            suggs = BlockSuggFromPredModel.empty; 
            blockTypesAnt = string.empty;

            blockTypesInSudExceptMrcbBlockType = setdiff(context.blockTypesInSud, context.mrcbBlockType);
            n = length(blockTypesInSudExceptMrcbBlockType); 

            r = floor(n * obj.ANT_REDUCTION);
            % combination of n taken r at a time
            combinations = combntns(blockTypesInSudExceptMrcbBlockType, r);  % C(n,r) : 2D array  -- each row is a combination 
            [nRows, nCols] = size(combinations); 
            for row = 1 : nRows
                blockTypesAnt = combinations(row,:);  
                % we regard mrcb's block type as more important than
                % others. So, we include it in all combinations 
                blockTypesAnt = [blockTypesAnt context.mrcbBlockType]; 
                suggsAll = obj.predictByBlockTypesInSud(blockTypesAnt);
                
                % filter out those suggestions with block-types already
                % present in SUD 
                suggs = BlockSuggFromPredModel.empty; 
                for i = 1 : length(suggsAll)
                    sugg = suggsAll(i); 
                    if ~any(strcmp(sugg.blockType, context.blockTypesInSud))
                        suggs = [suggs sugg]; 
                    end 
                end 
                
                if ~isempty(suggs)
                    time = toc(tStart);
                    % to compensate for MRCB
                    n = n + 1; 
                    r = r + 1;
                    return;
                end 
            end  
            % to compensate for MRCB
            n = n + 1; 
            r = r + 1; 
            time = toc(tStart); 
        end 
        
    end

    methods (Access = private) 
        
        function obj = setBlockTypesAndTable(obj)
           % Set the attributes 'blockTypes' and 'table' 
           
           % set blockTypes 
           obj.blockTypes = string.empty;
           for i = 1 : length(fields(obj.data))
               obj.blockTypes = [obj.blockTypes obj.data.("ss" + i)];  
           end
           % merge and sort alphabetically 
           obj.blockTypes = unique(obj.blockTypes); 
           
           % set table 
           obj.table = logical.empty; 
           for i = 1 : length(fields(obj.data))
               dataRow = obj.data.("ss" + i); 
               tableRow = logical.empty; 
               for j = 1 : length(obj.blockTypes)
                   blockType = obj.blockTypes(j); 
                   % if a particular blockType is present in a training 
                   % data row, represent it by 1 (true), otherwise by 0
                   % (false). 
                   if any(strcmp(dataRow, blockType))
                       tableRow = [tableRow true];
                   else
                       tableRow = [tableRow false]; 
                   end
               end
               obj.table = [obj.table; tableRow];  % append new row 
           end
        end
          
        function [status, fileHash, data] = extractDetailsAndUpdateCache(obj, mdlSlxAbspath, verbose)
            % Extract details from a mdlSlx file. 
            % This method also updates the cache stored in shared-var/simvma_armCache.mat, if required
            
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
            % data (struct) : same as ArmModel.data, but trained on 1 file
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
            cache = getSharedVar('simvma_armCache'); 
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
            
            %%%%%%%%%%%% uncomment to debug try-catch block %%%%%%%%%%%%%%%
%             modelName = bdroot; 
%             bdParams = getParamsByPath(modelName);  % block diagram params 
%             bdHandle = bdParams.Handle; 
%             data = obj.extractDetailsHelper(data, bdHandle, modelName);
%             status = "SUCCESS"; 
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            try
                modelName = bdroot; 
                bdParams = getParamsByPath(modelName);  % block diagram params 
                bdHandle = bdParams.Handle; 
                data = obj.extractDetailsHelper(data, bdHandle, modelName);
                status = "SUCCESS"; 
            catch ME
                status = "FAIL"; 
            end  
              
            % update cache 
            cache.(fileHash).status = status; 
            cache.(fileHash).data = data; 
            setSharedVar('simvma_armCache', cache); 
        end
        
        function data = extractDetailsHelper(obj, data, handle, parentPath)
            % this method updates only data attribute 
            % handle:     either top-level system handle or sub-system handle 
            % parentPath: parent system's path
            
            params = getParamsByHandle(handle, false);
            blocks = params.Blocks; 
            
            % add 1 entry in data for all non-System type blocks 
            newRow = string.empty; 
            for i = 1 : length(blocks)
                block = blocks(i); 
                % some block-names contain the character '/'. But since
                % '/' is used as a separater between parent and child
                % blocks, '/' in a block-name is replaced with '//' 
                block = strrep(block, '/', '//');
                blockPath = parentPath + "/" + block;
                blockHandle = get_param(blockPath, 'handle');
                blockParams = getParamsByHandle(blockHandle, false); 
                blockType = string(blockParams.BlockType); 
                if blockType ~= "SubSystem"
                    newRow = [newRow blockType]; 
                    newRow = unique(newRow);  % remove duplicates 
                else  % handle subsystem recursively 
                    data = obj.extractDetailsHelper(data, blockHandle, blockPath);
                end 
            end
            
            nFields = length(fields(data)); 
            % add new field to struct i.e. add a new training data tuple 
            data.("ss" + (nFields + 1)) = newRow;  
        end
        
        function suggs = predictByBlockTypesInSud(obj, blockTypesInSud)
            % Returns a list of BlockSuggFromPredModel objects based on
            % the current context, sorted by confidence 
            % 
            % All returned suggestions have confidence > 0.
            % 
            % If no suggestions are possible, it will return an empty list
            % of BlockSugg. 
            % 
            % PARAMETERS: 
            % -----------
            %   context (Context object): 
            
            % APPROACH: 
            % - create BlockSuggFromPredModel instances for each blockType
            %   present in training dataset, but not in SUD.
            % - Compute armSupportRule, armConfidenceRule, and armSupportConsequent
            %   for each blockType (not in SUD) as the consequent, and all blocks in
            %   SUD as the antecedent. 
            %     - we use prefix 'arm' to distinguish the ARM's confidence 
            %       from BlockSuggFromPredModel.confidenceterms 
            %     - also, we use postfix 'Rule' to distinguish arm-support
            %       of 'rule' from the arm-support of 'blockType'  from
            % - Compute armLiftRule (from armConfidenceRule and
            %   armSupportCon)
            % - Compute block-prediction confidence for each predicted
            %   type as based on (one or more of) armSupportRule, 
            %   armConfidenceRule, and armLiftRule  
            % - sort BlockSuggestionFromPredModels by confidence 
                      
            
            
            % For each predicted blockType, compute armSupportRule, 
            % armConfidenceRule, and armSupportCon, and armLiftRule 
            % NOTATIONS: 
            % Ant(ecedent): all blocks currently present in SUD
            % Con(sequent): each block (one at a time) present in training 
            %               dataset but not in SUD 
            % 
            % 
            % DEFINITIONS:
            % 
            %                    nRows with both Ant and Con = 1
            % armSupportRule =   -------------------------------
            %                             nRows 
            % 
            %                     nRows with both Ant and Con = 1
            % armConfidenceRule = -------------------------------
            %                        nRows with Ant = 1  
            % 
            %                 nRows with Con = 1
            % armSupportCon = ------------------
            %                        nRows  
            % 
            %               armConfidenceRule
            % armLiftRule = -----------------
            %                 armSupportCon  
            % 
            
            
            [nRows, nCols]  = size(obj.table);
            
            % indices of antecedent columns in table 
            antIndices = [];
            for i = 1 : length(blockTypesInSud)
                blockType = blockTypesInSud(i); 
                index = find(obj.blockTypes == blockType); 
                % if this particular block-type is not present in the 
                % training dataset, index will be set to 
                % '1x0 empty double row vector', otherwise it will be set 
                % to some 'double' value. 
                
                % We IGNORE any blocktype not present in the training
                % dataset (otherwise we can't use armModel at all) 
                % i.e we act as if it were not present in the SUD
                % so that we can define our antecedent with only those 
                % block-types present in both training dataset and SUD 
                blockExistsInTrainingDataset = any(index); 
                if blockExistsInTrainingDataset
                    antIndices = [antIndices index];  
                end
            end
            
            % a sub-matrix of table containing only those rows for which 
            % all antecedent column values are 1
            tableAnt = obj.table;
            for i = 1 : length(antIndices)
                index = antIndices(i); 
                col = tableAnt(:, index); 
                tableAnt = tableAnt(col == true, :);
            end 
            
            % nRowsAnt: # rows with Antecedent = true; 
            [nRowsAnt, nCols] = size(tableAnt); 
           
            % block-types for creating suggestions
            % NOTE: armModel never suggests a blocktype already present in SUD
            blockTypes_ = setdiff(obj.blockTypes, blockTypesInSud); 
            suggs = BlockSuggFromPredModel.empty; 
            for i = 1 : length(blockTypes_)
                blockType = blockTypes_(i); 
                conIndex = find(obj.blockTypes == blockType); % consequent's index  
                
                % FIND nRowsAntCon (to compute armSupportRule, armConfidenceRule) 
                col = tableAnt(:, conIndex);
                % a sub-matrix of table containing only those rows for which 
                % all antecedent as well as the consequent column values are 1
                tableAntCon = tableAnt(col == true);
                [nRowsAntCon, nCols] = size(tableAntCon); 
                
                % FIND nRowsCon (to compute armSupportCon, armLiftRule)
                col = obj.table(:, conIndex);
                % a sub-matrix of obj.table containing only those rows for which 
                % all consequent column values are 1
                tableCon = obj.table(col == true);
                [nRowsCon, nCols] = size(tableCon); 
                

                % COMPUTE ARM METRIX (support, confidence, lift) 
                armSupportRule = nRowsAntCon / nRows; 
                armConfidenceRule = nRowsAntCon / nRowsAnt;  
                % in case nRowsAnt (and hence nRowsAntCon) is 0, we get 0/0 = NaN
                if isnan(armConfidenceRule)   
                    armConfidenceRule = 0; % we've slightly modified the definition of confidence in this case 
                end 
                
                if armConfidenceRule > 0
                    sugg = BlockSuggFromPredModel(blockType, armConfidenceRule);
                    suggs = [suggs sugg]; 
                end 
            end  
            suggs = sortObjsByProp(suggs, 'confidence', 'descend');
        end
    end
    
end