function setSharedVarsForPredModelsTrainedOnDefRepos(am1, am2, am3, am4, am5, am6, fm1, fm2, fm3, fm4, fm5, fm6)
% Sets 64 + 64 = 128 shared vars for all possible combinations if ArmModels
% and all possible combinations of FreqModels trained on 6 default repos 
% 
% PARAMETERS: 
%   am1 : ArmModel trained on 1st default repo only (automotive)
%   am2 : ArmModel trained on 2nd default repo only (avionics)
%   am3 : ArmModel trained on 3rd default repo only (electronics)
%   am4 : ArmModel trained on 4th default repo only (energy)
%   am5 : ArmModel trained on 5th default repo only (robotics)
%   am6 : ArmModel trained on 6th default repo only (miscellaneous)
%   fm1 : FreqModel trained on 1st default repo only (automotive)
%   fm2 : FreqModel trained on 2nd default repo only (avionics)
%   fm3 : FreqModel trained on 3rd default repo only (electronics)
%   fm4 : FreqModel trained on 4th default repo only (energy)
%   fm5 : FreqModel trained on 5th default repo only (robotics)
%   fm6 : FreqModel trained on 6th default repo only (miscellaneous)

    am_000000 = ArmModel();   % empty i.e. not trained at all 
    am_000001 = am6; 
    am_000010 = am5; 
    am_000011 = mergeArmModels(true, [am5, am6]); 
    am_000100 = am4;
    am_000101 = mergeArmModels(true, [am4, am6]);
    am_000110 = mergeArmModels(true, [am4, am5]);
    am_000111 = mergeArmModels(true, [am4, am5, am6]);
    am_001000 = am3;
    am_001001 = mergeArmModels(true, [am3, am6]);
    am_001010 = mergeArmModels(true, [am3, am5]);
    am_001011 = mergeArmModels(true, [am3, am5, am6]);
    am_001100 = mergeArmModels(true, [am3, am4]);
    am_001101 = mergeArmModels(true, [am3, am4, am6]);
    am_001110 = mergeArmModels(true, [am3, am4, am5]);
    am_001111 = mergeArmModels(true, [am3, am4, am5, am6]);
    am_010000 = am2;
    am_010001 = mergeArmModels(true,[am2, am6]);
    am_010010 = mergeArmModels(true,[am2, am5]);
    am_010011 = mergeArmModels(true,[am2, am5, am6]);
    am_010100 = mergeArmModels(true,[am2, am4]);
    am_010101 = mergeArmModels(true,[am2, am4, am6]);
    am_010110 = mergeArmModels(true,[am2, am4, am5]);
    am_010111 = mergeArmModels(true,[am2, am4, am5, am6]);
    am_011000 = mergeArmModels(true,[am2, am3]);
    am_011001 = mergeArmModels(true,[am2, am3, am6]);
    am_011010 = mergeArmModels(true,[am2, am3, am5]);
    am_011011 = mergeArmModels(true,[am2, am3, am5, am6]);
    am_011100 = mergeArmModels(true,[am2, am3, am4]);
    am_011101 = mergeArmModels(true,[am2, am3, am4, am6]);
    am_011110 = mergeArmModels(true,[am2, am3, am4, am5]);
    am_011111 = mergeArmModels(true,[am2, am3, am4, am5, am6]);
    am_100000 = am1; 
    am_100001 = mergeArmModels(true, [am1, am6]);
    am_100010 = mergeArmModels(true, [am1, am5]); 
    am_100011 = mergeArmModels(true, [am1, am5, am6]); 
    am_100100 = mergeArmModels(true, [am1, am4]);
    am_100101 = mergeArmModels(true, [am1, am4, am6]);
    am_100110 = mergeArmModels(true, [am1, am4, am5]);
    am_100111 = mergeArmModels(true, [am1, am4, am5, am6]);
    am_101000 = mergeArmModels(true, [am1, am3]);
    am_101001 = mergeArmModels(true, [am1, am3, am6]);
    am_101010 = mergeArmModels(true, [am1, am3, am5]);
    am_101011 = mergeArmModels(true, [am1, am3, am5, am6]);
    am_101100 = mergeArmModels(true, [am1, am3, am4]);
    am_101101 = mergeArmModels(true, [am1, am3, am4, am6]);
    am_101110 = mergeArmModels(true, [am1, am3, am4, am5]);
    am_101111 = mergeArmModels(true, [am1, am3, am4, am5, am6]);
    am_110000 = mergeArmModels(true, [am1, am2]);
    am_110001 = mergeArmModels(true, [am1, am2, am6]);
    am_110010 = mergeArmModels(true, [am1, am2, am5]);
    am_110011 = mergeArmModels(true, [am1, am2, am5, am6]);
    am_110100 = mergeArmModels(true, [am1, am2, am4]);
    am_110101 = mergeArmModels(true, [am1, am2, am4, am6]);
    am_110110 = mergeArmModels(true, [am1, am2, am4, am5]);
    am_110111 = mergeArmModels(true, [am1, am2, am4, am5, am6]);
    am_111000 = mergeArmModels(true, [am1, am2, am3]);
    am_111001 = mergeArmModels(true, [am1, am2, am3, am6]);
    am_111010 = mergeArmModels(true, [am1, am2, am3, am5]);
    am_111011 = mergeArmModels(true, [am1, am2, am3, am5, am6]);
    am_111100 = mergeArmModels(true, [am1, am2, am3, am4]);
    am_111101 = mergeArmModels(true, [am1, am2, am3, am4, am6]);
    am_111110 = mergeArmModels(true, [am1, am2, am3, am4, am5]);
    am_111111 = mergeArmModels(true, [am1, am2, am3, am4, am5, am6]);
    
    fm_000000 = FreqModel();   % empty i.e. not trained at all 
    fm_000001 = fm6; 
    fm_000010 = fm5; 
    fm_000011 = mergeFreqModels(true, [fm5, fm6]); 
    fm_000100 = fm4;
    fm_000101 = mergeFreqModels(true, [fm4, fm6]);
    fm_000110 = mergeFreqModels(true, [fm4, fm5]);
    fm_000111 = mergeFreqModels(true, [fm4, fm5, fm6]);
    fm_001000 = fm3;
    fm_001001 = mergeFreqModels(true, [fm3, fm6]);
    fm_001010 = mergeFreqModels(true, [fm3, fm5]);
    fm_001011 = mergeFreqModels(true, [fm3, fm5, fm6]);
    fm_001100 = mergeFreqModels(true, [fm3, fm4]);
    fm_001101 = mergeFreqModels(true, [fm3, fm4, fm6]);
    fm_001110 = mergeFreqModels(true, [fm3, fm4, fm5]);
    fm_001111 = mergeFreqModels(true, [fm3, fm4, fm5, fm6]);
    fm_010000 = fm2;
    fm_010001 = mergeFreqModels(true,[fm2, fm6]);
    fm_010010 = mergeFreqModels(true,[fm2, fm5]);
    fm_010011 = mergeFreqModels(true,[fm2, fm5, fm6]);
    fm_010100 = mergeFreqModels(true,[fm2, fm4]);
    fm_010101 = mergeFreqModels(true,[fm2, fm4, fm6]);
    fm_010110 = mergeFreqModels(true,[fm2, fm4, fm5]);
    fm_010111 = mergeFreqModels(true,[fm2, fm4, fm5, fm6]);
    fm_011000 = mergeFreqModels(true,[fm2, fm3]);
    fm_011001 = mergeFreqModels(true,[fm2, fm3, fm6]);
    fm_011010 = mergeFreqModels(true,[fm2, fm3, fm5]);
    fm_011011 = mergeFreqModels(true,[fm2, fm3, fm5, fm6]);
    fm_011100 = mergeFreqModels(true,[fm2, fm3, fm4]);
    fm_011101 = mergeFreqModels(true,[fm2, fm3, fm4, fm6]);
    fm_011110 = mergeFreqModels(true,[fm2, fm3, fm4, fm5]);
    fm_011111 = mergeFreqModels(true,[fm2, fm3, fm4, fm5, fm6]);
    fm_100000 = fm1; 
    fm_100001 = mergeFreqModels(true, [fm1, fm6]);
    fm_100010 = mergeFreqModels(true, [fm1, fm5]); 
    fm_100011 = mergeFreqModels(true, [fm1, fm5, fm6]); 
    fm_100100 = mergeFreqModels(true, [fm1, fm4]);
    fm_100101 = mergeFreqModels(true, [fm1, fm4, fm6]);
    fm_100110 = mergeFreqModels(true, [fm1, fm4, fm5]);
    fm_100111 = mergeFreqModels(true, [fm1, fm4, fm5, fm6]);
    fm_101000 = mergeFreqModels(true, [fm1, fm3]);
    fm_101001 = mergeFreqModels(true, [fm1, fm3, fm6]);
    fm_101010 = mergeFreqModels(true, [fm1, fm3, fm5]);
    fm_101011 = mergeFreqModels(true, [fm1, fm3, fm5, fm6]);
    fm_101100 = mergeFreqModels(true, [fm1, fm3, fm4]);
    fm_101101 = mergeFreqModels(true, [fm1, fm3, fm4, fm6]);
    fm_101110 = mergeFreqModels(true, [fm1, fm3, fm4, fm5]);
    fm_101111 = mergeFreqModels(true, [fm1, fm3, fm4, fm5, fm6]);
    fm_110000 = mergeFreqModels(true, [fm1, fm2]);
    fm_110001 = mergeFreqModels(true, [fm1, fm2, fm6]);
    fm_110010 = mergeFreqModels(true, [fm1, fm2, fm5]);
    fm_110011 = mergeFreqModels(true, [fm1, fm2, fm5, fm6]);
    fm_110100 = mergeFreqModels(true, [fm1, fm2, fm4]);
    fm_110101 = mergeFreqModels(true, [fm1, fm2, fm4, fm6]);
    fm_110110 = mergeFreqModels(true, [fm1, fm2, fm4, fm5]);
    fm_110111 = mergeFreqModels(true, [fm1, fm2, fm4, fm5, fm6]);
    fm_111000 = mergeFreqModels(true, [fm1, fm2, fm3]);
    fm_111001 = mergeFreqModels(true, [fm1, fm2, fm3, fm6]);
    fm_111010 = mergeFreqModels(true, [fm1, fm2, fm3, fm5]);
    fm_111011 = mergeFreqModels(true, [fm1, fm2, fm3, fm5, fm6]);
    fm_111100 = mergeFreqModels(true, [fm1, fm2, fm3, fm4]);
    fm_111101 = mergeFreqModels(true, [fm1, fm2, fm3, fm4, fm6]);
    fm_111110 = mergeFreqModels(true, [fm1, fm2, fm3, fm4, fm5]);
    fm_111111 = mergeFreqModels(true, [fm1, fm2, fm3, fm4, fm5, fm6]);
    
% The following code (between %%% generated-start %%% and %%% generated-end %%%) was generated with this script  
% #!/usr/local/bin/python3 
% 
% with open('file.txt', 'w') as file:
%     file.write("\n%%%%%%%%%%%%%%%%%%%%%%%%%%%%% generated-start %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n")
%     for model in ['Arm', 'Freq']:
%         model_lower = model.lower(); 
%         model_abb = 'am' if model == 'Arm' else 'fm'
% 
%         for a in range(0, 2):
%             for b in range(0, 2):
%                 for c in range(0, 2):
%                     for d in range(0, 2):
%                         for e in range(0, 2):
%                             for f in range(0, 2):
% 
%                                 s = f"""
%     setSharedVar('simvma_{model_lower}ModelDef_{a}{b}{c}{d}{e}{f}', {model_abb}_{a}{b}{c}{d}{e}{f})"""
%                                 file.write(s)
%     file.write("\n\n%%%%%%%%%%%%%%%%%%%%%%%%%%%%% generated-end %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n")                            
% 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%% generated-start %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    setSharedVar('simvma_armModelDef_000000', am_000000)
    setSharedVar('simvma_armModelDef_000001', am_000001)
    setSharedVar('simvma_armModelDef_000010', am_000010)
    setSharedVar('simvma_armModelDef_000011', am_000011)
    setSharedVar('simvma_armModelDef_000100', am_000100)
    setSharedVar('simvma_armModelDef_000101', am_000101)
    setSharedVar('simvma_armModelDef_000110', am_000110)
    setSharedVar('simvma_armModelDef_000111', am_000111)
    setSharedVar('simvma_armModelDef_001000', am_001000)
    setSharedVar('simvma_armModelDef_001001', am_001001)
    setSharedVar('simvma_armModelDef_001010', am_001010)
    setSharedVar('simvma_armModelDef_001011', am_001011)
    setSharedVar('simvma_armModelDef_001100', am_001100)
    setSharedVar('simvma_armModelDef_001101', am_001101)
    setSharedVar('simvma_armModelDef_001110', am_001110)
    setSharedVar('simvma_armModelDef_001111', am_001111)
    setSharedVar('simvma_armModelDef_010000', am_010000)
    setSharedVar('simvma_armModelDef_010001', am_010001)
    setSharedVar('simvma_armModelDef_010010', am_010010)
    setSharedVar('simvma_armModelDef_010011', am_010011)
    setSharedVar('simvma_armModelDef_010100', am_010100)
    setSharedVar('simvma_armModelDef_010101', am_010101)
    setSharedVar('simvma_armModelDef_010110', am_010110)
    setSharedVar('simvma_armModelDef_010111', am_010111)
    setSharedVar('simvma_armModelDef_011000', am_011000)
    setSharedVar('simvma_armModelDef_011001', am_011001)
    setSharedVar('simvma_armModelDef_011010', am_011010)
    setSharedVar('simvma_armModelDef_011011', am_011011)
    setSharedVar('simvma_armModelDef_011100', am_011100)
    setSharedVar('simvma_armModelDef_011101', am_011101)
    setSharedVar('simvma_armModelDef_011110', am_011110)
    setSharedVar('simvma_armModelDef_011111', am_011111)
    setSharedVar('simvma_armModelDef_100000', am_100000)
    setSharedVar('simvma_armModelDef_100001', am_100001)
    setSharedVar('simvma_armModelDef_100010', am_100010)
    setSharedVar('simvma_armModelDef_100011', am_100011)
    setSharedVar('simvma_armModelDef_100100', am_100100)
    setSharedVar('simvma_armModelDef_100101', am_100101)
    setSharedVar('simvma_armModelDef_100110', am_100110)
    setSharedVar('simvma_armModelDef_100111', am_100111)
    setSharedVar('simvma_armModelDef_101000', am_101000)
    setSharedVar('simvma_armModelDef_101001', am_101001)
    setSharedVar('simvma_armModelDef_101010', am_101010)
    setSharedVar('simvma_armModelDef_101011', am_101011)
    setSharedVar('simvma_armModelDef_101100', am_101100)
    setSharedVar('simvma_armModelDef_101101', am_101101)
    setSharedVar('simvma_armModelDef_101110', am_101110)
    setSharedVar('simvma_armModelDef_101111', am_101111)
    setSharedVar('simvma_armModelDef_110000', am_110000)
    setSharedVar('simvma_armModelDef_110001', am_110001)
    setSharedVar('simvma_armModelDef_110010', am_110010)
    setSharedVar('simvma_armModelDef_110011', am_110011)
    setSharedVar('simvma_armModelDef_110100', am_110100)
    setSharedVar('simvma_armModelDef_110101', am_110101)
    setSharedVar('simvma_armModelDef_110110', am_110110)
    setSharedVar('simvma_armModelDef_110111', am_110111)
    setSharedVar('simvma_armModelDef_111000', am_111000)
    setSharedVar('simvma_armModelDef_111001', am_111001)
    setSharedVar('simvma_armModelDef_111010', am_111010)
    setSharedVar('simvma_armModelDef_111011', am_111011)
    setSharedVar('simvma_armModelDef_111100', am_111100)
    setSharedVar('simvma_armModelDef_111101', am_111101)
    setSharedVar('simvma_armModelDef_111110', am_111110)
    setSharedVar('simvma_armModelDef_111111', am_111111)
    setSharedVar('simvma_freqModelDef_000000', fm_000000)
    setSharedVar('simvma_freqModelDef_000001', fm_000001)
    setSharedVar('simvma_freqModelDef_000010', fm_000010)
    setSharedVar('simvma_freqModelDef_000011', fm_000011)
    setSharedVar('simvma_freqModelDef_000100', fm_000100)
    setSharedVar('simvma_freqModelDef_000101', fm_000101)
    setSharedVar('simvma_freqModelDef_000110', fm_000110)
    setSharedVar('simvma_freqModelDef_000111', fm_000111)
    setSharedVar('simvma_freqModelDef_001000', fm_001000)
    setSharedVar('simvma_freqModelDef_001001', fm_001001)
    setSharedVar('simvma_freqModelDef_001010', fm_001010)
    setSharedVar('simvma_freqModelDef_001011', fm_001011)
    setSharedVar('simvma_freqModelDef_001100', fm_001100)
    setSharedVar('simvma_freqModelDef_001101', fm_001101)
    setSharedVar('simvma_freqModelDef_001110', fm_001110)
    setSharedVar('simvma_freqModelDef_001111', fm_001111)
    setSharedVar('simvma_freqModelDef_010000', fm_010000)
    setSharedVar('simvma_freqModelDef_010001', fm_010001)
    setSharedVar('simvma_freqModelDef_010010', fm_010010)
    setSharedVar('simvma_freqModelDef_010011', fm_010011)
    setSharedVar('simvma_freqModelDef_010100', fm_010100)
    setSharedVar('simvma_freqModelDef_010101', fm_010101)
    setSharedVar('simvma_freqModelDef_010110', fm_010110)
    setSharedVar('simvma_freqModelDef_010111', fm_010111)
    setSharedVar('simvma_freqModelDef_011000', fm_011000)
    setSharedVar('simvma_freqModelDef_011001', fm_011001)
    setSharedVar('simvma_freqModelDef_011010', fm_011010)
    setSharedVar('simvma_freqModelDef_011011', fm_011011)
    setSharedVar('simvma_freqModelDef_011100', fm_011100)
    setSharedVar('simvma_freqModelDef_011101', fm_011101)
    setSharedVar('simvma_freqModelDef_011110', fm_011110)
    setSharedVar('simvma_freqModelDef_011111', fm_011111)
    setSharedVar('simvma_freqModelDef_100000', fm_100000)
    setSharedVar('simvma_freqModelDef_100001', fm_100001)
    setSharedVar('simvma_freqModelDef_100010', fm_100010)
    setSharedVar('simvma_freqModelDef_100011', fm_100011)
    setSharedVar('simvma_freqModelDef_100100', fm_100100)
    setSharedVar('simvma_freqModelDef_100101', fm_100101)
    setSharedVar('simvma_freqModelDef_100110', fm_100110)
    setSharedVar('simvma_freqModelDef_100111', fm_100111)
    setSharedVar('simvma_freqModelDef_101000', fm_101000)
    setSharedVar('simvma_freqModelDef_101001', fm_101001)
    setSharedVar('simvma_freqModelDef_101010', fm_101010)
    setSharedVar('simvma_freqModelDef_101011', fm_101011)
    setSharedVar('simvma_freqModelDef_101100', fm_101100)
    setSharedVar('simvma_freqModelDef_101101', fm_101101)
    setSharedVar('simvma_freqModelDef_101110', fm_101110)
    setSharedVar('simvma_freqModelDef_101111', fm_101111)
    setSharedVar('simvma_freqModelDef_110000', fm_110000)
    setSharedVar('simvma_freqModelDef_110001', fm_110001)
    setSharedVar('simvma_freqModelDef_110010', fm_110010)
    setSharedVar('simvma_freqModelDef_110011', fm_110011)
    setSharedVar('simvma_freqModelDef_110100', fm_110100)
    setSharedVar('simvma_freqModelDef_110101', fm_110101)
    setSharedVar('simvma_freqModelDef_110110', fm_110110)
    setSharedVar('simvma_freqModelDef_110111', fm_110111)
    setSharedVar('simvma_freqModelDef_111000', fm_111000)
    setSharedVar('simvma_freqModelDef_111001', fm_111001)
    setSharedVar('simvma_freqModelDef_111010', fm_111010)
    setSharedVar('simvma_freqModelDef_111011', fm_111011)
    setSharedVar('simvma_freqModelDef_111100', fm_111100)
    setSharedVar('simvma_freqModelDef_111101', fm_111101)
    setSharedVar('simvma_freqModelDef_111110', fm_111110)
    setSharedVar('simvma_freqModelDef_111111', fm_111111)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%% generated-end %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

end 