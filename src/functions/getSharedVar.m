function value = getSharedVar(name)
% Return the value of the shared variable from corresponding file in 
% shared-vars/*.mat 
% 
% PARAMETERS: 
% -----------
%  name(string) : name of the variable 
% 
% ASSUMPTION: corresponding .mat file exists in shared-vars/ 


    % don't include simvma_simvmaPath here.
    % simvma_simvmaPath can be accessed using getSimvmaPath() function 
    validVars = [ ... 
        "simvma_appState", ...
        "simvma_blockInsertionState", ... 
        "simvma_armCache", ...
        "simvma_freqCache", ...
        "simvma_armModel", ...          % combination of 1 (of 64) default ArmModel and custom ArmModel
        "simvma_freqModel", ...          
        "simvma_armModelCst", ... 
        "simvma_freqModelCst", ...      % custom FreqModel (i.e. trained on custom repos only) 
        "simvma_freqModelStd01", ...
        "simvma_freqModelStd10", ...
        "simvma_freqModelStd11", ...
        "simvma_armModelStd01", ...
        "simvma_armModelStd10", ...
        "simvma_armModelStd11", ...
        "simvma_symlinkMap", ...        % key: symbolic path, value: real path 
        "simvma_tempvar", ...           % this variable is for testing purpose only. 
    ]; 

    % total of 64 models trained on all possible combinations of 6 default
    % repos i.e. simvma_freqModelDef000000 ... simvmafreqModelDef111111
    for i = 0 : 1
        for j = 0 : 1
            for k = 0 : 1
                for l = 0 : 1
                    for m = 0 : 1
                        for n = 0 : 1
                            am = "simvma_armModelDef_" + i + j + k + l + m + n; 
                            fm = "simvma_freqModelDef_" + i + j + k + l + m + n;
                            validVars = [validVars am fm]; 
                        end 
                    end 
                end 
            end 
        end 
    end 
    
    if ~any(strcmp(validVars, name))
        error("Unexpected var : " + name);
    end

    filepath = getSimvmaPath() + "/shared-vars/" + name + ".mat"; 
    loadedVars = load(filepath); 
    value = loadedVars.(name);
        
end 