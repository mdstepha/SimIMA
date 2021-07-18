function value = setSharedVar(name, value)
% Set the value of the workspace data in corresponding file in 
% shared-vars/*.mat. 
% The .mat file will be created if it does not exist already. 
% This will override the corresponding .mat file in case it already exists.
% 
% PARAMETERS: 
% -----------
%  name(string) : name of the variable 
%  value(ANY): value to be set 
% 
 

    filepath = getSimvmaPath() + "/shared-vars/" + name + ".mat"; 
    
    % could not find a generic way to create a variable inside this 
    % function with given name and value. 
    % so, resorted to this rather ugly approach. 
    
    if name == "simvma_appState"
        setAppState(filepath, value);
    
    elseif name == "simvma_blockInsertionState"
        setBlockInsertionState(filepath, value);
        
    elseif name == "simvma_armCache"
        setArmCache(filepath, value);
    elseif name == "simvma_freqCache"
        setFreqCache(filepath, value);
    
    elseif name == "simvma_tempvar"  % for test purpose only 
        setTempvar(filepath, value);
        
    elseif name == "simvma_armModelCst"
        setArmModelCst(filepath, value); 
    elseif name == "simvma_armModel"
        setArmModel(filepath, value); 
    elseif name == "simvma_freqModelCst"
        setFreqModelCst(filepath, value); 
    elseif name == "simvma_freqModel"
        setFreqModel(filepath, value);
    
    % todo: delete following 6 else-ifs once the 6 default models are trained
    % delete begin
    elseif name == "simvma_freqModelStd01"
        setFreqModelStd01(filepath, value); 
    elseif name == "simvma_freqModelStd10"
        setFreqModelStd10(filepath, value); 
    elseif name == "simvma_freqModelStd11"
        setFreqModelStd11(filepath, value); 
    elseif name == "simvma_armModelStd01"
        setArmModelStd01(filepath, value); 
    elseif name == "simvma_armModelStd10"
        setArmModelStd10(filepath, value); 
    elseif name == "simvma_armModelStd11"
        setArmModelStd11(filepath, value); 
    elseif name == "simvma_symlinkMap"
        setSymlinkMap(filepath, value); 
    % delete end 
        
       
        
% The following code (between %%% generated-start %%% and %%% generated-end %%%) was generated with this script  

% #!/usr/local/bin/python3 
% 
% with open('file.txt', 'w') as file:
%     file.write("\n%%%%%%%%%%%%%%%%%%%%%%%%%%%%% generated-start %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n")
%     for model in ['Arm', 'Freq']:
%         model_lower = model.lower(); 
% 
%         for a in range(0, 2):
%             for b in range(0, 2):
%                 for c in range(0, 2):
%                     for d in range(0, 2):
%                         for e in range(0, 2):
%                             for f in range(0, 2):
%                                 s = f"""
%     elseif name == "simvma_{model_lower}ModelDef_{a}{b}{c}{d}{e}{f}"
%         set{model}ModelDef_{a}{b}{c}{d}{e}{f}(filepath, value);
%     """
%                                 file.write(s)
%     file.write("\n%%%%%%%%%%%%%%%%%%%%%%%%%%%%% generated-end %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n")                            


    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%% generated-start %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    elseif name == "simvma_armModelDef_000000"
        setArmModelDef_000000(filepath, value);
    
    elseif name == "simvma_armModelDef_000001"
        setArmModelDef_000001(filepath, value);
    
    elseif name == "simvma_armModelDef_000010"
        setArmModelDef_000010(filepath, value);
    
    elseif name == "simvma_armModelDef_000011"
        setArmModelDef_000011(filepath, value);
    
    elseif name == "simvma_armModelDef_000100"
        setArmModelDef_000100(filepath, value);
    
    elseif name == "simvma_armModelDef_000101"
        setArmModelDef_000101(filepath, value);
    
    elseif name == "simvma_armModelDef_000110"
        setArmModelDef_000110(filepath, value);
    
    elseif name == "simvma_armModelDef_000111"
        setArmModelDef_000111(filepath, value);
    
    elseif name == "simvma_armModelDef_001000"
        setArmModelDef_001000(filepath, value);
    
    elseif name == "simvma_armModelDef_001001"
        setArmModelDef_001001(filepath, value);
    
    elseif name == "simvma_armModelDef_001010"
        setArmModelDef_001010(filepath, value);
    
    elseif name == "simvma_armModelDef_001011"
        setArmModelDef_001011(filepath, value);
    
    elseif name == "simvma_armModelDef_001100"
        setArmModelDef_001100(filepath, value);
    
    elseif name == "simvma_armModelDef_001101"
        setArmModelDef_001101(filepath, value);
    
    elseif name == "simvma_armModelDef_001110"
        setArmModelDef_001110(filepath, value);
    
    elseif name == "simvma_armModelDef_001111"
        setArmModelDef_001111(filepath, value);
    
    elseif name == "simvma_armModelDef_010000"
        setArmModelDef_010000(filepath, value);
    
    elseif name == "simvma_armModelDef_010001"
        setArmModelDef_010001(filepath, value);
    
    elseif name == "simvma_armModelDef_010010"
        setArmModelDef_010010(filepath, value);
    
    elseif name == "simvma_armModelDef_010011"
        setArmModelDef_010011(filepath, value);
    
    elseif name == "simvma_armModelDef_010100"
        setArmModelDef_010100(filepath, value);
    
    elseif name == "simvma_armModelDef_010101"
        setArmModelDef_010101(filepath, value);
    
    elseif name == "simvma_armModelDef_010110"
        setArmModelDef_010110(filepath, value);
    
    elseif name == "simvma_armModelDef_010111"
        setArmModelDef_010111(filepath, value);
    
    elseif name == "simvma_armModelDef_011000"
        setArmModelDef_011000(filepath, value);
    
    elseif name == "simvma_armModelDef_011001"
        setArmModelDef_011001(filepath, value);
    
    elseif name == "simvma_armModelDef_011010"
        setArmModelDef_011010(filepath, value);
    
    elseif name == "simvma_armModelDef_011011"
        setArmModelDef_011011(filepath, value);
    
    elseif name == "simvma_armModelDef_011100"
        setArmModelDef_011100(filepath, value);
    
    elseif name == "simvma_armModelDef_011101"
        setArmModelDef_011101(filepath, value);
    
    elseif name == "simvma_armModelDef_011110"
        setArmModelDef_011110(filepath, value);
    
    elseif name == "simvma_armModelDef_011111"
        setArmModelDef_011111(filepath, value);
    
    elseif name == "simvma_armModelDef_100000"
        setArmModelDef_100000(filepath, value);
    
    elseif name == "simvma_armModelDef_100001"
        setArmModelDef_100001(filepath, value);
    
    elseif name == "simvma_armModelDef_100010"
        setArmModelDef_100010(filepath, value);
    
    elseif name == "simvma_armModelDef_100011"
        setArmModelDef_100011(filepath, value);
    
    elseif name == "simvma_armModelDef_100100"
        setArmModelDef_100100(filepath, value);
    
    elseif name == "simvma_armModelDef_100101"
        setArmModelDef_100101(filepath, value);
    
    elseif name == "simvma_armModelDef_100110"
        setArmModelDef_100110(filepath, value);
    
    elseif name == "simvma_armModelDef_100111"
        setArmModelDef_100111(filepath, value);
    
    elseif name == "simvma_armModelDef_101000"
        setArmModelDef_101000(filepath, value);
    
    elseif name == "simvma_armModelDef_101001"
        setArmModelDef_101001(filepath, value);
    
    elseif name == "simvma_armModelDef_101010"
        setArmModelDef_101010(filepath, value);
    
    elseif name == "simvma_armModelDef_101011"
        setArmModelDef_101011(filepath, value);
    
    elseif name == "simvma_armModelDef_101100"
        setArmModelDef_101100(filepath, value);
    
    elseif name == "simvma_armModelDef_101101"
        setArmModelDef_101101(filepath, value);
    
    elseif name == "simvma_armModelDef_101110"
        setArmModelDef_101110(filepath, value);
    
    elseif name == "simvma_armModelDef_101111"
        setArmModelDef_101111(filepath, value);
    
    elseif name == "simvma_armModelDef_110000"
        setArmModelDef_110000(filepath, value);
    
    elseif name == "simvma_armModelDef_110001"
        setArmModelDef_110001(filepath, value);
    
    elseif name == "simvma_armModelDef_110010"
        setArmModelDef_110010(filepath, value);
    
    elseif name == "simvma_armModelDef_110011"
        setArmModelDef_110011(filepath, value);
    
    elseif name == "simvma_armModelDef_110100"
        setArmModelDef_110100(filepath, value);
    
    elseif name == "simvma_armModelDef_110101"
        setArmModelDef_110101(filepath, value);
    
    elseif name == "simvma_armModelDef_110110"
        setArmModelDef_110110(filepath, value);
    
    elseif name == "simvma_armModelDef_110111"
        setArmModelDef_110111(filepath, value);
    
    elseif name == "simvma_armModelDef_111000"
        setArmModelDef_111000(filepath, value);
    
    elseif name == "simvma_armModelDef_111001"
        setArmModelDef_111001(filepath, value);
    
    elseif name == "simvma_armModelDef_111010"
        setArmModelDef_111010(filepath, value);
    
    elseif name == "simvma_armModelDef_111011"
        setArmModelDef_111011(filepath, value);
    
    elseif name == "simvma_armModelDef_111100"
        setArmModelDef_111100(filepath, value);
    
    elseif name == "simvma_armModelDef_111101"
        setArmModelDef_111101(filepath, value);
    
    elseif name == "simvma_armModelDef_111110"
        setArmModelDef_111110(filepath, value);
    
    elseif name == "simvma_armModelDef_111111"
        setArmModelDef_111111(filepath, value);
    
    elseif name == "simvma_freqModelDef_000000"
        setFreqModelDef_000000(filepath, value);
    
    elseif name == "simvma_freqModelDef_000001"
        setFreqModelDef_000001(filepath, value);
    
    elseif name == "simvma_freqModelDef_000010"
        setFreqModelDef_000010(filepath, value);
    
    elseif name == "simvma_freqModelDef_000011"
        setFreqModelDef_000011(filepath, value);
    
    elseif name == "simvma_freqModelDef_000100"
        setFreqModelDef_000100(filepath, value);
    
    elseif name == "simvma_freqModelDef_000101"
        setFreqModelDef_000101(filepath, value);
    
    elseif name == "simvma_freqModelDef_000110"
        setFreqModelDef_000110(filepath, value);
    
    elseif name == "simvma_freqModelDef_000111"
        setFreqModelDef_000111(filepath, value);
    
    elseif name == "simvma_freqModelDef_001000"
        setFreqModelDef_001000(filepath, value);
    
    elseif name == "simvma_freqModelDef_001001"
        setFreqModelDef_001001(filepath, value);
    
    elseif name == "simvma_freqModelDef_001010"
        setFreqModelDef_001010(filepath, value);
    
    elseif name == "simvma_freqModelDef_001011"
        setFreqModelDef_001011(filepath, value);
    
    elseif name == "simvma_freqModelDef_001100"
        setFreqModelDef_001100(filepath, value);
    
    elseif name == "simvma_freqModelDef_001101"
        setFreqModelDef_001101(filepath, value);
    
    elseif name == "simvma_freqModelDef_001110"
        setFreqModelDef_001110(filepath, value);
    
    elseif name == "simvma_freqModelDef_001111"
        setFreqModelDef_001111(filepath, value);
    
    elseif name == "simvma_freqModelDef_010000"
        setFreqModelDef_010000(filepath, value);
    
    elseif name == "simvma_freqModelDef_010001"
        setFreqModelDef_010001(filepath, value);
    
    elseif name == "simvma_freqModelDef_010010"
        setFreqModelDef_010010(filepath, value);
    
    elseif name == "simvma_freqModelDef_010011"
        setFreqModelDef_010011(filepath, value);
    
    elseif name == "simvma_freqModelDef_010100"
        setFreqModelDef_010100(filepath, value);
    
    elseif name == "simvma_freqModelDef_010101"
        setFreqModelDef_010101(filepath, value);
    
    elseif name == "simvma_freqModelDef_010110"
        setFreqModelDef_010110(filepath, value);
    
    elseif name == "simvma_freqModelDef_010111"
        setFreqModelDef_010111(filepath, value);
    
    elseif name == "simvma_freqModelDef_011000"
        setFreqModelDef_011000(filepath, value);
    
    elseif name == "simvma_freqModelDef_011001"
        setFreqModelDef_011001(filepath, value);
    
    elseif name == "simvma_freqModelDef_011010"
        setFreqModelDef_011010(filepath, value);
    
    elseif name == "simvma_freqModelDef_011011"
        setFreqModelDef_011011(filepath, value);
    
    elseif name == "simvma_freqModelDef_011100"
        setFreqModelDef_011100(filepath, value);
    
    elseif name == "simvma_freqModelDef_011101"
        setFreqModelDef_011101(filepath, value);
    
    elseif name == "simvma_freqModelDef_011110"
        setFreqModelDef_011110(filepath, value);
    
    elseif name == "simvma_freqModelDef_011111"
        setFreqModelDef_011111(filepath, value);
    
    elseif name == "simvma_freqModelDef_100000"
        setFreqModelDef_100000(filepath, value);
    
    elseif name == "simvma_freqModelDef_100001"
        setFreqModelDef_100001(filepath, value);
    
    elseif name == "simvma_freqModelDef_100010"
        setFreqModelDef_100010(filepath, value);
    
    elseif name == "simvma_freqModelDef_100011"
        setFreqModelDef_100011(filepath, value);
    
    elseif name == "simvma_freqModelDef_100100"
        setFreqModelDef_100100(filepath, value);
    
    elseif name == "simvma_freqModelDef_100101"
        setFreqModelDef_100101(filepath, value);
    
    elseif name == "simvma_freqModelDef_100110"
        setFreqModelDef_100110(filepath, value);
    
    elseif name == "simvma_freqModelDef_100111"
        setFreqModelDef_100111(filepath, value);
    
    elseif name == "simvma_freqModelDef_101000"
        setFreqModelDef_101000(filepath, value);
    
    elseif name == "simvma_freqModelDef_101001"
        setFreqModelDef_101001(filepath, value);
    
    elseif name == "simvma_freqModelDef_101010"
        setFreqModelDef_101010(filepath, value);
    
    elseif name == "simvma_freqModelDef_101011"
        setFreqModelDef_101011(filepath, value);
    
    elseif name == "simvma_freqModelDef_101100"
        setFreqModelDef_101100(filepath, value);
    
    elseif name == "simvma_freqModelDef_101101"
        setFreqModelDef_101101(filepath, value);
    
    elseif name == "simvma_freqModelDef_101110"
        setFreqModelDef_101110(filepath, value);
    
    elseif name == "simvma_freqModelDef_101111"
        setFreqModelDef_101111(filepath, value);
    
    elseif name == "simvma_freqModelDef_110000"
        setFreqModelDef_110000(filepath, value);
    
    elseif name == "simvma_freqModelDef_110001"
        setFreqModelDef_110001(filepath, value);
    
    elseif name == "simvma_freqModelDef_110010"
        setFreqModelDef_110010(filepath, value);
    
    elseif name == "simvma_freqModelDef_110011"
        setFreqModelDef_110011(filepath, value);
    
    elseif name == "simvma_freqModelDef_110100"
        setFreqModelDef_110100(filepath, value);
    
    elseif name == "simvma_freqModelDef_110101"
        setFreqModelDef_110101(filepath, value);
    
    elseif name == "simvma_freqModelDef_110110"
        setFreqModelDef_110110(filepath, value);
    
    elseif name == "simvma_freqModelDef_110111"
        setFreqModelDef_110111(filepath, value);
    
    elseif name == "simvma_freqModelDef_111000"
        setFreqModelDef_111000(filepath, value);
    
    elseif name == "simvma_freqModelDef_111001"
        setFreqModelDef_111001(filepath, value);
    
    elseif name == "simvma_freqModelDef_111010"
        setFreqModelDef_111010(filepath, value);
    
    elseif name == "simvma_freqModelDef_111011"
        setFreqModelDef_111011(filepath, value);
    
    elseif name == "simvma_freqModelDef_111100"
        setFreqModelDef_111100(filepath, value);
    
    elseif name == "simvma_freqModelDef_111101"
        setFreqModelDef_111101(filepath, value);
    
    elseif name == "simvma_freqModelDef_111110"
        setFreqModelDef_111110(filepath, value);
    
    elseif name == "simvma_freqModelDef_111111"
        setFreqModelDef_111111(filepath, value);
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%% generated-end %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
    else     
        error("Unexpected var : " + name); 
    end     
end 




function setAppState(filepath, simvma_appState)
    save(filepath, 'simvma_appState');
end


function setFreqModelStd01(filepath, simvma_freqModelStd01)
    save(filepath, 'simvma_freqModelStd01');
end

function setFreqModelStd10(filepath, simvma_freqModelStd10)
    save(filepath, 'simvma_freqModelStd10');
end

function setFreqModelStd11(filepath, simvma_freqModelStd11)
    save(filepath, 'simvma_freqModelStd11');
end

function setFreqModelCst(filepath, simvma_freqModelCst)
    save(filepath, 'simvma_freqModelCst');
end

function setFreqModel(filepath, simvma_freqModel)
    save(filepath, 'simvma_freqModel');
end


function setArmModelStd01(filepath, simvma_armModelStd01)
    save(filepath, 'simvma_armModelStd01');
end

function setArmModelStd10(filepath, simvma_armModelStd10)
    save(filepath, 'simvma_armModelStd10');
end

function setArmModelStd11(filepath, simvma_armModelStd11)
    save(filepath, 'simvma_armModelStd11');
end

function setArmModelCst(filepath, simvma_armModelCst)
    save(filepath, 'simvma_armModelCst');
end

function setArmModel(filepath, simvma_armModel)
    save(filepath, 'simvma_armModel');
end


function setBlockInsertionState(filepath, simvma_blockInsertionState)
    save(filepath, 'simvma_blockInsertionState');
end 

function setArmCache(filepath, simvma_armCache)
    save(filepath, 'simvma_armCache');
end 
function setFreqCache(filepath, simvma_freqCache)
    save(filepath, 'simvma_freqCache');
end 

function setTempvar(filepath, simvma_tempvar)
    save(filepath, 'simvma_tempvar');
end 

function setBlockTypes(filepath, simvma_blockTypes)
    save(filepath, 'simvma_blockTypes');
end 

function setSymlinkMap(filepath, simvma_symlinkMap)
    save(filepath, 'simvma_symlinkMap'); 
end



% The following code (between %%% generated-start %%% and %%% generated-end %%%)
% was generated using this script 
% 
% #!/usr/local/bin/python3 
% 
% with open('file.txt', 'w') as file:
%     file.write("\n%%%%%%%%%%%%%%%%%%%%%%%%%%%%% generated-start %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n")
%     for model in ['Arm', 'Freq']:
%         model_lower = model.lower(); 
% 
%         for a in range(0, 2):
%             for b in range(0, 2):
%                 for c in range(0, 2):
%                     for d in range(0, 2):
%                         for e in range(0, 2):
%                             for f in range(0, 2):
%                                 s = f"""
% function set{model}ModelDef_{a}{b}{c}{d}{e}{f}(filepath, simvma_{model_lower}ModelDef_{a}{b}{c}{d}{e}{f})
%     save(filepath, 'simvma_{model}ModelDef_{a}{b}{c}{d}{e}{f}');
% end 
% """
%                                 file.write(s)
%     file.write("\n%%%%%%%%%%%%%%%%%%%%%%%%%%%%% generated-end %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n")                            



%%%%%%%%%%%%%%%%%%%%%%%%%%%%% generated-start %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function setArmModelDef_000000(filepath, simvma_armModelDef_000000)
    save(filepath, 'simvma_armModelDef_000000');
end 

function setArmModelDef_000001(filepath, simvma_armModelDef_000001)
    save(filepath, 'simvma_armModelDef_000001');
end 

function setArmModelDef_000010(filepath, simvma_armModelDef_000010)
    save(filepath, 'simvma_armModelDef_000010');
end 

function setArmModelDef_000011(filepath, simvma_armModelDef_000011)
    save(filepath, 'simvma_armModelDef_000011');
end 

function setArmModelDef_000100(filepath, simvma_armModelDef_000100)
    save(filepath, 'simvma_armModelDef_000100');
end 

function setArmModelDef_000101(filepath, simvma_armModelDef_000101)
    save(filepath, 'simvma_armModelDef_000101');
end 

function setArmModelDef_000110(filepath, simvma_armModelDef_000110)
    save(filepath, 'simvma_armModelDef_000110');
end 

function setArmModelDef_000111(filepath, simvma_armModelDef_000111)
    save(filepath, 'simvma_armModelDef_000111');
end 

function setArmModelDef_001000(filepath, simvma_armModelDef_001000)
    save(filepath, 'simvma_armModelDef_001000');
end 

function setArmModelDef_001001(filepath, simvma_armModelDef_001001)
    save(filepath, 'simvma_armModelDef_001001');
end 

function setArmModelDef_001010(filepath, simvma_armModelDef_001010)
    save(filepath, 'simvma_armModelDef_001010');
end 

function setArmModelDef_001011(filepath, simvma_armModelDef_001011)
    save(filepath, 'simvma_armModelDef_001011');
end 

function setArmModelDef_001100(filepath, simvma_armModelDef_001100)
    save(filepath, 'simvma_armModelDef_001100');
end 

function setArmModelDef_001101(filepath, simvma_armModelDef_001101)
    save(filepath, 'simvma_armModelDef_001101');
end 

function setArmModelDef_001110(filepath, simvma_armModelDef_001110)
    save(filepath, 'simvma_armModelDef_001110');
end 

function setArmModelDef_001111(filepath, simvma_armModelDef_001111)
    save(filepath, 'simvma_armModelDef_001111');
end 

function setArmModelDef_010000(filepath, simvma_armModelDef_010000)
    save(filepath, 'simvma_armModelDef_010000');
end 

function setArmModelDef_010001(filepath, simvma_armModelDef_010001)
    save(filepath, 'simvma_armModelDef_010001');
end 

function setArmModelDef_010010(filepath, simvma_armModelDef_010010)
    save(filepath, 'simvma_armModelDef_010010');
end 

function setArmModelDef_010011(filepath, simvma_armModelDef_010011)
    save(filepath, 'simvma_armModelDef_010011');
end 

function setArmModelDef_010100(filepath, simvma_armModelDef_010100)
    save(filepath, 'simvma_armModelDef_010100');
end 

function setArmModelDef_010101(filepath, simvma_armModelDef_010101)
    save(filepath, 'simvma_armModelDef_010101');
end 

function setArmModelDef_010110(filepath, simvma_armModelDef_010110)
    save(filepath, 'simvma_armModelDef_010110');
end 

function setArmModelDef_010111(filepath, simvma_armModelDef_010111)
    save(filepath, 'simvma_armModelDef_010111');
end 

function setArmModelDef_011000(filepath, simvma_armModelDef_011000)
    save(filepath, 'simvma_armModelDef_011000');
end 

function setArmModelDef_011001(filepath, simvma_armModelDef_011001)
    save(filepath, 'simvma_armModelDef_011001');
end 

function setArmModelDef_011010(filepath, simvma_armModelDef_011010)
    save(filepath, 'simvma_armModelDef_011010');
end 

function setArmModelDef_011011(filepath, simvma_armModelDef_011011)
    save(filepath, 'simvma_armModelDef_011011');
end 

function setArmModelDef_011100(filepath, simvma_armModelDef_011100)
    save(filepath, 'simvma_armModelDef_011100');
end 

function setArmModelDef_011101(filepath, simvma_armModelDef_011101)
    save(filepath, 'simvma_armModelDef_011101');
end 

function setArmModelDef_011110(filepath, simvma_armModelDef_011110)
    save(filepath, 'simvma_armModelDef_011110');
end 

function setArmModelDef_011111(filepath, simvma_armModelDef_011111)
    save(filepath, 'simvma_armModelDef_011111');
end 

function setArmModelDef_100000(filepath, simvma_armModelDef_100000)
    save(filepath, 'simvma_armModelDef_100000');
end 

function setArmModelDef_100001(filepath, simvma_armModelDef_100001)
    save(filepath, 'simvma_armModelDef_100001');
end 

function setArmModelDef_100010(filepath, simvma_armModelDef_100010)
    save(filepath, 'simvma_armModelDef_100010');
end 

function setArmModelDef_100011(filepath, simvma_armModelDef_100011)
    save(filepath, 'simvma_armModelDef_100011');
end 

function setArmModelDef_100100(filepath, simvma_armModelDef_100100)
    save(filepath, 'simvma_armModelDef_100100');
end 

function setArmModelDef_100101(filepath, simvma_armModelDef_100101)
    save(filepath, 'simvma_armModelDef_100101');
end 

function setArmModelDef_100110(filepath, simvma_armModelDef_100110)
    save(filepath, 'simvma_armModelDef_100110');
end 

function setArmModelDef_100111(filepath, simvma_armModelDef_100111)
    save(filepath, 'simvma_armModelDef_100111');
end 

function setArmModelDef_101000(filepath, simvma_armModelDef_101000)
    save(filepath, 'simvma_armModelDef_101000');
end 

function setArmModelDef_101001(filepath, simvma_armModelDef_101001)
    save(filepath, 'simvma_armModelDef_101001');
end 

function setArmModelDef_101010(filepath, simvma_armModelDef_101010)
    save(filepath, 'simvma_armModelDef_101010');
end 

function setArmModelDef_101011(filepath, simvma_armModelDef_101011)
    save(filepath, 'simvma_armModelDef_101011');
end 

function setArmModelDef_101100(filepath, simvma_armModelDef_101100)
    save(filepath, 'simvma_armModelDef_101100');
end 

function setArmModelDef_101101(filepath, simvma_armModelDef_101101)
    save(filepath, 'simvma_armModelDef_101101');
end 

function setArmModelDef_101110(filepath, simvma_armModelDef_101110)
    save(filepath, 'simvma_armModelDef_101110');
end 

function setArmModelDef_101111(filepath, simvma_armModelDef_101111)
    save(filepath, 'simvma_armModelDef_101111');
end 

function setArmModelDef_110000(filepath, simvma_armModelDef_110000)
    save(filepath, 'simvma_armModelDef_110000');
end 

function setArmModelDef_110001(filepath, simvma_armModelDef_110001)
    save(filepath, 'simvma_armModelDef_110001');
end 

function setArmModelDef_110010(filepath, simvma_armModelDef_110010)
    save(filepath, 'simvma_armModelDef_110010');
end 

function setArmModelDef_110011(filepath, simvma_armModelDef_110011)
    save(filepath, 'simvma_armModelDef_110011');
end 

function setArmModelDef_110100(filepath, simvma_armModelDef_110100)
    save(filepath, 'simvma_armModelDef_110100');
end 

function setArmModelDef_110101(filepath, simvma_armModelDef_110101)
    save(filepath, 'simvma_armModelDef_110101');
end 

function setArmModelDef_110110(filepath, simvma_armModelDef_110110)
    save(filepath, 'simvma_armModelDef_110110');
end 

function setArmModelDef_110111(filepath, simvma_armModelDef_110111)
    save(filepath, 'simvma_armModelDef_110111');
end 

function setArmModelDef_111000(filepath, simvma_armModelDef_111000)
    save(filepath, 'simvma_armModelDef_111000');
end 

function setArmModelDef_111001(filepath, simvma_armModelDef_111001)
    save(filepath, 'simvma_armModelDef_111001');
end 

function setArmModelDef_111010(filepath, simvma_armModelDef_111010)
    save(filepath, 'simvma_armModelDef_111010');
end 

function setArmModelDef_111011(filepath, simvma_armModelDef_111011)
    save(filepath, 'simvma_armModelDef_111011');
end 

function setArmModelDef_111100(filepath, simvma_armModelDef_111100)
    save(filepath, 'simvma_armModelDef_111100');
end 

function setArmModelDef_111101(filepath, simvma_armModelDef_111101)
    save(filepath, 'simvma_armModelDef_111101');
end 

function setArmModelDef_111110(filepath, simvma_armModelDef_111110)
    save(filepath, 'simvma_armModelDef_111110');
end 

function setArmModelDef_111111(filepath, simvma_armModelDef_111111)
    save(filepath, 'simvma_armModelDef_111111');
end 

function setFreqModelDef_000000(filepath, simvma_freqModelDef_000000)
    save(filepath, 'simvma_freqModelDef_000000');
end 

function setFreqModelDef_000001(filepath, simvma_freqModelDef_000001)
    save(filepath, 'simvma_freqModelDef_000001');
end 

function setFreqModelDef_000010(filepath, simvma_freqModelDef_000010)
    save(filepath, 'simvma_freqModelDef_000010');
end 

function setFreqModelDef_000011(filepath, simvma_freqModelDef_000011)
    save(filepath, 'simvma_freqModelDef_000011');
end 

function setFreqModelDef_000100(filepath, simvma_freqModelDef_000100)
    save(filepath, 'simvma_freqModelDef_000100');
end 

function setFreqModelDef_000101(filepath, simvma_freqModelDef_000101)
    save(filepath, 'simvma_freqModelDef_000101');
end 

function setFreqModelDef_000110(filepath, simvma_freqModelDef_000110)
    save(filepath, 'simvma_freqModelDef_000110');
end 

function setFreqModelDef_000111(filepath, simvma_freqModelDef_000111)
    save(filepath, 'simvma_freqModelDef_000111');
end 

function setFreqModelDef_001000(filepath, simvma_freqModelDef_001000)
    save(filepath, 'simvma_freqModelDef_001000');
end 

function setFreqModelDef_001001(filepath, simvma_freqModelDef_001001)
    save(filepath, 'simvma_freqModelDef_001001');
end 

function setFreqModelDef_001010(filepath, simvma_freqModelDef_001010)
    save(filepath, 'simvma_freqModelDef_001010');
end 

function setFreqModelDef_001011(filepath, simvma_freqModelDef_001011)
    save(filepath, 'simvma_freqModelDef_001011');
end 

function setFreqModelDef_001100(filepath, simvma_freqModelDef_001100)
    save(filepath, 'simvma_freqModelDef_001100');
end 

function setFreqModelDef_001101(filepath, simvma_freqModelDef_001101)
    save(filepath, 'simvma_freqModelDef_001101');
end 

function setFreqModelDef_001110(filepath, simvma_freqModelDef_001110)
    save(filepath, 'simvma_freqModelDef_001110');
end 

function setFreqModelDef_001111(filepath, simvma_freqModelDef_001111)
    save(filepath, 'simvma_freqModelDef_001111');
end 

function setFreqModelDef_010000(filepath, simvma_freqModelDef_010000)
    save(filepath, 'simvma_freqModelDef_010000');
end 

function setFreqModelDef_010001(filepath, simvma_freqModelDef_010001)
    save(filepath, 'simvma_freqModelDef_010001');
end 

function setFreqModelDef_010010(filepath, simvma_freqModelDef_010010)
    save(filepath, 'simvma_freqModelDef_010010');
end 

function setFreqModelDef_010011(filepath, simvma_freqModelDef_010011)
    save(filepath, 'simvma_freqModelDef_010011');
end 

function setFreqModelDef_010100(filepath, simvma_freqModelDef_010100)
    save(filepath, 'simvma_freqModelDef_010100');
end 

function setFreqModelDef_010101(filepath, simvma_freqModelDef_010101)
    save(filepath, 'simvma_freqModelDef_010101');
end 

function setFreqModelDef_010110(filepath, simvma_freqModelDef_010110)
    save(filepath, 'simvma_freqModelDef_010110');
end 

function setFreqModelDef_010111(filepath, simvma_freqModelDef_010111)
    save(filepath, 'simvma_freqModelDef_010111');
end 

function setFreqModelDef_011000(filepath, simvma_freqModelDef_011000)
    save(filepath, 'simvma_freqModelDef_011000');
end 

function setFreqModelDef_011001(filepath, simvma_freqModelDef_011001)
    save(filepath, 'simvma_freqModelDef_011001');
end 

function setFreqModelDef_011010(filepath, simvma_freqModelDef_011010)
    save(filepath, 'simvma_freqModelDef_011010');
end 

function setFreqModelDef_011011(filepath, simvma_freqModelDef_011011)
    save(filepath, 'simvma_freqModelDef_011011');
end 

function setFreqModelDef_011100(filepath, simvma_freqModelDef_011100)
    save(filepath, 'simvma_freqModelDef_011100');
end 

function setFreqModelDef_011101(filepath, simvma_freqModelDef_011101)
    save(filepath, 'simvma_freqModelDef_011101');
end 

function setFreqModelDef_011110(filepath, simvma_freqModelDef_011110)
    save(filepath, 'simvma_freqModelDef_011110');
end 

function setFreqModelDef_011111(filepath, simvma_freqModelDef_011111)
    save(filepath, 'simvma_freqModelDef_011111');
end 

function setFreqModelDef_100000(filepath, simvma_freqModelDef_100000)
    save(filepath, 'simvma_freqModelDef_100000');
end 

function setFreqModelDef_100001(filepath, simvma_freqModelDef_100001)
    save(filepath, 'simvma_freqModelDef_100001');
end 

function setFreqModelDef_100010(filepath, simvma_freqModelDef_100010)
    save(filepath, 'simvma_freqModelDef_100010');
end 

function setFreqModelDef_100011(filepath, simvma_freqModelDef_100011)
    save(filepath, 'simvma_freqModelDef_100011');
end 

function setFreqModelDef_100100(filepath, simvma_freqModelDef_100100)
    save(filepath, 'simvma_freqModelDef_100100');
end 

function setFreqModelDef_100101(filepath, simvma_freqModelDef_100101)
    save(filepath, 'simvma_freqModelDef_100101');
end 

function setFreqModelDef_100110(filepath, simvma_freqModelDef_100110)
    save(filepath, 'simvma_freqModelDef_100110');
end 

function setFreqModelDef_100111(filepath, simvma_freqModelDef_100111)
    save(filepath, 'simvma_freqModelDef_100111');
end 

function setFreqModelDef_101000(filepath, simvma_freqModelDef_101000)
    save(filepath, 'simvma_freqModelDef_101000');
end 

function setFreqModelDef_101001(filepath, simvma_freqModelDef_101001)
    save(filepath, 'simvma_freqModelDef_101001');
end 

function setFreqModelDef_101010(filepath, simvma_freqModelDef_101010)
    save(filepath, 'simvma_freqModelDef_101010');
end 

function setFreqModelDef_101011(filepath, simvma_freqModelDef_101011)
    save(filepath, 'simvma_freqModelDef_101011');
end 

function setFreqModelDef_101100(filepath, simvma_freqModelDef_101100)
    save(filepath, 'simvma_freqModelDef_101100');
end 

function setFreqModelDef_101101(filepath, simvma_freqModelDef_101101)
    save(filepath, 'simvma_freqModelDef_101101');
end 

function setFreqModelDef_101110(filepath, simvma_freqModelDef_101110)
    save(filepath, 'simvma_freqModelDef_101110');
end 

function setFreqModelDef_101111(filepath, simvma_freqModelDef_101111)
    save(filepath, 'simvma_freqModelDef_101111');
end 

function setFreqModelDef_110000(filepath, simvma_freqModelDef_110000)
    save(filepath, 'simvma_freqModelDef_110000');
end 

function setFreqModelDef_110001(filepath, simvma_freqModelDef_110001)
    save(filepath, 'simvma_freqModelDef_110001');
end 

function setFreqModelDef_110010(filepath, simvma_freqModelDef_110010)
    save(filepath, 'simvma_freqModelDef_110010');
end 

function setFreqModelDef_110011(filepath, simvma_freqModelDef_110011)
    save(filepath, 'simvma_freqModelDef_110011');
end 

function setFreqModelDef_110100(filepath, simvma_freqModelDef_110100)
    save(filepath, 'simvma_freqModelDef_110100');
end 

function setFreqModelDef_110101(filepath, simvma_freqModelDef_110101)
    save(filepath, 'simvma_freqModelDef_110101');
end 

function setFreqModelDef_110110(filepath, simvma_freqModelDef_110110)
    save(filepath, 'simvma_freqModelDef_110110');
end 

function setFreqModelDef_110111(filepath, simvma_freqModelDef_110111)
    save(filepath, 'simvma_freqModelDef_110111');
end 

function setFreqModelDef_111000(filepath, simvma_freqModelDef_111000)
    save(filepath, 'simvma_freqModelDef_111000');
end 

function setFreqModelDef_111001(filepath, simvma_freqModelDef_111001)
    save(filepath, 'simvma_freqModelDef_111001');
end 

function setFreqModelDef_111010(filepath, simvma_freqModelDef_111010)
    save(filepath, 'simvma_freqModelDef_111010');
end 

function setFreqModelDef_111011(filepath, simvma_freqModelDef_111011)
    save(filepath, 'simvma_freqModelDef_111011');
end 

function setFreqModelDef_111100(filepath, simvma_freqModelDef_111100)
    save(filepath, 'simvma_freqModelDef_111100');
end 

function setFreqModelDef_111101(filepath, simvma_freqModelDef_111101)
    save(filepath, 'simvma_freqModelDef_111101');
end 

function setFreqModelDef_111110(filepath, simvma_freqModelDef_111110)
    save(filepath, 'simvma_freqModelDef_111110');
end 

function setFreqModelDef_111111(filepath, simvma_freqModelDef_111111)
    save(filepath, 'simvma_freqModelDef_111111');
end 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%% generated-end %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%