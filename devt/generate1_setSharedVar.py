#!/usr/local/bin/python3 

# This script generate parts of code for the file src/functions/setSharedVar.m

with open('generated.txt', 'w') as file:
    file.write("\n%%%%%%%%%%%%%%%%%%%%%%%%%%%%% generated-start %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n")
    for model in ['Arm', 'Freq']:
        model_lower = model.lower(); 

        for a in range(0, 2):
            for b in range(0, 2):
                for c in range(0, 2):
                    for d in range(0, 2):
                        for e in range(0, 2):
                            for f in range(0, 2):
                                s = f"""
    elseif name == "simvma_{model_lower}ModelDef_{a}{b}{c}{d}{e}{f}"
        set{model}ModelDef_{a}{b}{c}{d}{e}{f}(filepath, value);
    """
                                file.write(s)
    file.write("\n%%%%%%%%%%%%%%%%%%%%%%%%%%%%% generated-end %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n")                            


