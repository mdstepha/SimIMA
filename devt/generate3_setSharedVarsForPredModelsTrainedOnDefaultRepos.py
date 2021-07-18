#!/usr/local/bin/python3 

# This script generate parts of code for the file src/functions/setSharedVarsForPredModelsTrainedOnDefRepos.m 

with open('generated.txt', 'w') as file:
    file.write("\n%%%%%%%%%%%%%%%%%%%%%%%%%%%%% generated-start %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n")
    for model in ['Arm', 'Freq']:
        model_lower = model.lower(); 
        model_abb = 'am' if model == 'Arm' else 'fm'

        for a in range(0, 2):
            for b in range(0, 2):
                for c in range(0, 2):
                    for d in range(0, 2):
                        for e in range(0, 2):
                            for f in range(0, 2):

                                s = f"""
    setSharedVar('simvma_{model_lower}ModelDef_{a}{b}{c}{d}{e}{f}', {model_abb}_{a}{b}{c}{d}{e}{f})"""
                                file.write(s)
    file.write("\n\n%%%%%%%%%%%%%%%%%%%%%%%%%%%%% generated-end %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n")                            


