% This class tracks the "state" and/or "config" of appSimxample and appSimgestion. 
% Such tracking is necessary to 
% - initialize the state from last saved state of the app.
% - 'pass' state information across apps and functions or between appSimxample
%   and appSimgestion (eg. which repos are selected) 

classdef AppState 
    properties
        % although some of these properties are constant, we still keep
        % them in this 'state' class, so that they can be accesed from both
        % inside the app and outside the app (in functions that 
        % create/update the block-prediction models) through the same 
        % shared-var. Otherwise, we would have to hardcode the same value 
        % (eg. defRepoPath1 in two places -- once inside the app, and also 
        % in the library functions)
        
        simxampleSimoneMinSize = 10; 
        simxampleSimoneMaxSize = 20000; 
        simxampleSimoneRename = "blind"; 
        simxampleNSuggsMax = 10; 
        simxampleSimoneDiffLimit = 30;  % maximum percentage difference limit between clones 
        
        % This flag is set/unset by createMdlFileForSimone() 
        simxampleSavedAsMdl = false; 
        
        simgestionNSuggsMax = 6;  % number 
        
        % There will be a trade-off between speed and accuracy. 
        % accuracy level can be one of following: 
        % 1: less accurate (but fast) -- uses FreqModel only 
        % 2: medium accurate (medium fast) -- uses ArmModel only 
        % 3: very accurate (but slow) -- uses ensemble of FreqModel and ArmModel 
        simgestionAccuracyLevel = 3 % integer in range [1,2,3] 
          
        % only the 'miscellaneous' repo (repo 6) is checked by default 
        defRepo1Checked = false; 
        defRepo2Checked = false;  
        defRepo3Checked = false;  
        defRepo4Checked = false;  
        defRepo5Checked = false;  
        defRepo6Checked = true;   
        
        % these paths are relative to simvmaPath 
        % We don't store the absolute path here so that the code does not
        % become machine-specific
        defRepoPath1 = "default-repos/automotive";    % constant 
        defRepoPath2 = "default-repos/avionics";      % constant  
        defRepoPath3 = "default-repos/electronics";   % constant  
        defRepoPath4 = "default-repos/energy";        % constant  
        defRepoPath5 = "default-repos/robotics";      % constant  
        defRepoPath6 = "default-repos/miscellaneous"; % constant  
        
        % unlike default repopaths, these paths are absolute 
        cstRepoPath1 = "";       
        cstRepoPath2 = "";       
        cstRepoPath3 = "";    
        cstRepoPath4 = "";    
        cstRepoPath5 = "";    
        
        % While SimGestion can work with either MDL or SLX files in the
        % repos, SimXample works with only MDL files. So, we track them
        % both.
        
        nMdlDefRepoPath1 % number 
        nMdlDefRepoPath2 % number 
        nMdlDefRepoPath3 % number 
        nMdlDefRepoPath4 % number 
        nMdlDefRepoPath5 % number 
        nMdlDefRepoPath6 % number
        
        nSlxDefRepoPath1 % number 
        nSlxDefRepoPath2 % number 
        nSlxDefRepoPath3 % number 
        nSlxDefRepoPath4 % number 
        nSlxDefRepoPath5 % number 
        nSlxDefRepoPath6 % number
        
        nMdlSlxDefRepoPath1 % number 
        nMdlSlxDefRepoPath2 % number 
        nMdlSlxDefRepoPath3 % number 
        nMdlSlxDefRepoPath4 % number 
        nMdlSlxDefRepoPath5 % number 
        nMdlSlxDefRepoPath6 % number 
        
        nMdlCstRepoPath1 % number 
        nMdlCstRepoPath2 % number 
        nMdlCstRepoPath3 % number 
        nMdlCstRepoPath4 % number 
        nMdlCstRepoPath5 % number 
        
        nSlxCstRepoPath1 % number 
        nSlxCstRepoPath2 % number 
        nSlxCstRepoPath3 % number 
        nSlxCstRepoPath4 % number 
        nSlxCstRepoPath5 % number 
        
        nMdlSlxCstRepoPath1 % number 
        nMdlSlxCstRepoPath2 % number 
        nMdlSlxCstRepoPath3 % number 
        nMdlSlxCstRepoPath4 % number 
        nMdlSlxCstRepoPath5 % number 
          
        % Unlike for standard-block-prediction-models, we don't track 
        % whether custom-block-prediction-models are reset or not. This is 
        % because, custom-block-prediction-models are ALWAYS updated when 
        % the function updatePredModels() is called. 
        
        % these paths are relative to simvma 
        % these will be used to decide whether or not to invoke
        % updatePredModels() from inside appAdmin 
        relpathsOfMdlSlxInDefRepo1      % list of strings
        relpathsOfMdlSlxInDefRepo2      % list of strings
        relpathsOfMdlSlxInDefRepo3      % list of strings
        relpathsOfMdlSlxInDefRepo4      % list of strings
        relpathsOfMdlSlxInDefRepo5      % list of strings
        relpathsOfMdlSlxInDefRepo6      % list of strings
        
        % these paths are absolute 
        abspathsOfMdlSlxInCstRepo1      % list of strings
        abspathsOfMdlSlxInCstRepo2      % list of strings
        abspathsOfMdlSlxInCstRepo3      % list of strings
        abspathsOfMdlSlxInCstRepo4      % list of strings
        abspathsOfMdlSlxInCstRepo5      % list of strings
   
        % this flag is set by: 
        % - resetModels()
        % - resetModelsAndCache()
        % and, unset by
        % - updateDefBlockPredModelsAfterChangesInDefRepos()
        defBlockPredModelsReset = false; % boolean
      
    end 
    
    methods 

        function obj = AppState() 
            % this information (filepaths, count) needs to be updated after every change in
            % repos. So, we put the corresponding code in public method
            % setModelPathsAndCounts() rather than in the constructor itself. 
            % 
            % Although default repos are not supposed to be channged, this
            % function updates them too (recomputes the same value). This
            % is to keep the code simple, and is affordable as the
            % computation cost is not high.
            obj = obj.setModelFilePathsAndCounts(); 
        end 
        
        function obj = setModelFilePathsAndCounts(obj)
            % This method does not affect the repopaths. 
            obj.relpathsOfMdlSlxInDefRepo1 = removeSimvmaPathPrefix(searchFilesRecursively(obj.defRepoPath1, ["mdl", "slx"]));
            obj.relpathsOfMdlSlxInDefRepo2 = removeSimvmaPathPrefix(searchFilesRecursively(obj.defRepoPath2, ["mdl", "slx"]));
            obj.relpathsOfMdlSlxInDefRepo3 = removeSimvmaPathPrefix(searchFilesRecursively(obj.defRepoPath3, ["mdl", "slx"]));
            obj.relpathsOfMdlSlxInDefRepo4 = removeSimvmaPathPrefix(searchFilesRecursively(obj.defRepoPath4, ["mdl", "slx"]));
            obj.relpathsOfMdlSlxInDefRepo5 = removeSimvmaPathPrefix(searchFilesRecursively(obj.defRepoPath5, ["mdl", "slx"]));
            obj.relpathsOfMdlSlxInDefRepo6 = removeSimvmaPathPrefix(searchFilesRecursively(obj.defRepoPath6, ["mdl", "slx"]));
            
            obj.abspathsOfMdlSlxInCstRepo1 = searchFilesRecursively(obj.cstRepoPath1, ["mdl", "slx"]); 
            obj.abspathsOfMdlSlxInCstRepo2 = searchFilesRecursively(obj.cstRepoPath2, ["mdl", "slx"]); 
            obj.abspathsOfMdlSlxInCstRepo3 = searchFilesRecursively(obj.cstRepoPath3, ["mdl", "slx"]); 
            obj.abspathsOfMdlSlxInCstRepo4 = searchFilesRecursively(obj.cstRepoPath4, ["mdl", "slx"]); 
            obj.abspathsOfMdlSlxInCstRepo5 = searchFilesRecursively(obj.cstRepoPath5, ["mdl", "slx"]); 
            
            obj.nMdlDefRepoPath1 = getNFilesRecursively(addSimvmaPathPrefix(obj.defRepoPath1), 'mdl');
            obj.nMdlDefRepoPath2 = getNFilesRecursively(addSimvmaPathPrefix(obj.defRepoPath2), 'mdl');
            obj.nMdlDefRepoPath3 = getNFilesRecursively(addSimvmaPathPrefix(obj.defRepoPath3), 'mdl');
            obj.nMdlDefRepoPath4 = getNFilesRecursively(addSimvmaPathPrefix(obj.defRepoPath4), 'mdl');
            obj.nMdlDefRepoPath5 = getNFilesRecursively(addSimvmaPathPrefix(obj.defRepoPath5), 'mdl');
            obj.nMdlDefRepoPath6 = getNFilesRecursively(addSimvmaPathPrefix(obj.defRepoPath6), 'mdl');
                        
            obj.nSlxDefRepoPath1 = getNFilesRecursively(addSimvmaPathPrefix(obj.defRepoPath1), 'slx');
            obj.nSlxDefRepoPath2 = getNFilesRecursively(addSimvmaPathPrefix(obj.defRepoPath2), 'slx');
            obj.nSlxDefRepoPath3 = getNFilesRecursively(addSimvmaPathPrefix(obj.defRepoPath3), 'slx');
            obj.nSlxDefRepoPath4 = getNFilesRecursively(addSimvmaPathPrefix(obj.defRepoPath4), 'slx');
            obj.nSlxDefRepoPath5 = getNFilesRecursively(addSimvmaPathPrefix(obj.defRepoPath5), 'slx');
            obj.nSlxDefRepoPath6 = getNFilesRecursively(addSimvmaPathPrefix(obj.defRepoPath6), 'slx');
            
            obj.nMdlSlxDefRepoPath1 = length(obj.relpathsOfMdlSlxInDefRepo1);
            obj.nMdlSlxDefRepoPath2 = length(obj.relpathsOfMdlSlxInDefRepo2);
            obj.nMdlSlxDefRepoPath3 = length(obj.relpathsOfMdlSlxInDefRepo3);
            obj.nMdlSlxDefRepoPath4 = length(obj.relpathsOfMdlSlxInDefRepo4);
            obj.nMdlSlxDefRepoPath5 = length(obj.relpathsOfMdlSlxInDefRepo5);
            obj.nMdlSlxDefRepoPath6 = length(obj.relpathsOfMdlSlxInDefRepo6);
            
            obj.nMdlCstRepoPath1 = getNFilesRecursively(obj.cstRepoPath1, 'mdl'); 
            obj.nMdlCstRepoPath2 = getNFilesRecursively(obj.cstRepoPath2, 'mdl'); 
            obj.nMdlCstRepoPath3 = getNFilesRecursively(obj.cstRepoPath3, 'mdl'); 
            obj.nMdlCstRepoPath4 = getNFilesRecursively(obj.cstRepoPath4, 'mdl'); 
            obj.nMdlCstRepoPath5 = getNFilesRecursively(obj.cstRepoPath5, 'mdl'); 
            
            obj.nSlxCstRepoPath1 = getNFilesRecursively(obj.cstRepoPath1, 'slx'); 
            obj.nSlxCstRepoPath2 = getNFilesRecursively(obj.cstRepoPath2, 'slx'); 
            obj.nSlxCstRepoPath3 = getNFilesRecursively(obj.cstRepoPath3, 'slx'); 
            obj.nSlxCstRepoPath4 = getNFilesRecursively(obj.cstRepoPath4, 'slx'); 
            obj.nSlxCstRepoPath5 = getNFilesRecursively(obj.cstRepoPath5, 'slx'); 
            
            obj.nMdlSlxCstRepoPath1 = length(obj.abspathsOfMdlSlxInCstRepo1);  
            obj.nMdlSlxCstRepoPath2 = length(obj.abspathsOfMdlSlxInCstRepo2);
            obj.nMdlSlxCstRepoPath3 = length(obj.abspathsOfMdlSlxInCstRepo3);
            obj.nMdlSlxCstRepoPath4 = length(obj.abspathsOfMdlSlxInCstRepo4);
            obj.nMdlSlxCstRepoPath5 = length(obj.abspathsOfMdlSlxInCstRepo5);
            
        end
        
        function obj = cleanCustomRepoPaths(obj)
        % this function does the following jobs: 
        % - make sure the custom repo paths do exist (otherwise set them to "" and 
        %   corresponding mdl/slx file count to 0
        % - make sure that app.newState.cstRepoPathX is set (to some non-empty value)
        %   before app.newState.cstRepoPathY, where X < Y 
       
        
            n = 5;  % custom repopaths 
        
            % make sure specified custom repo paths do exist, else reset them 
            for i = 1 : n 
                propCstRepoPath = "cstRepoPath" + i; 
                propNMdlCstRepoPath = "nMdlCstRepoPath" + i; 
                propNSlxCstRepoPath = "nSlxCstRepoPath" + i; 
                propNMdlSlxCstRepoPath = "nMdlSlxCstRepoPath" + i; 
                
                if ~exist(obj.(propCstRepoPath), 'dir')
                    obj.(propCstRepoPath) = ""; 
                    obj.(propNMdlCstRepoPath) = 0; 
                    obj.(propNSlxCstRepoPath) = 0; 
                    obj.(propNMdlSlxCstRepoPath) = 0; 
                end 
            end 
        
            % make sure obj.cstRepoPathX is set before obj.cstRepoPathY
            % where X < Y
            for i = 1 : n
                for j = i+1 : n
                    propCstRepoPath1 = "cstRepoPath" + i; 
                    propNMdlCstRepoPath1 = "nMdlCstRepoPath" + i; 
                    propNSlxCstRepoPath1 = "nSlxCstRepoPath" + i; 
                    propNMdlSlxCstRepoPath1 = "nMdlSlxCstRepoPath" + i; 
                
                    propCstRepoPath2 = "cstRepoPath" + j; 
                    propNMdlCstRepoPath2 = "nMdlCstRepoPath" + j; 
                    propNSlxCstRepoPath2 = "nSlxCstRepoPath" + j; 
                    propNMdlSlxCstRepoPath2 = "nMdlSlxCstRepoPath" + j;  

                    % this is a cool way to access properties by their
                    % string representation. 
                    if obj.(propCstRepoPath1) == "" && obj.(propCstRepoPath2) ~= ""
                        obj.(propCstRepoPath1) = obj.(propCstRepoPath2);
                        obj.(propNMdlCstRepoPath1) = obj.(propNMdlCstRepoPath2); 
                        obj.(propNSlxCstRepoPath1) = obj.(propNSlxCstRepoPath2); 
                        obj.(propNMdlSlxCstRepoPath1) = obj.(propNMdlSlxCstRepoPath2); 
                        obj.(propCstRepoPath2) = ""; 
                        obj.(propNMdlCstRepoPath2) = 0; 
                        obj.(propNSlxCstRepoPath2) = 0; 
                        obj.(propNMdlSlxCstRepoPath2) = 0; 
                    end
                end
            end
        end

    end 
end 