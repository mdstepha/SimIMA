function updateModelWithClone(modelPath, clonePath)
% replace the model's entire content with that of the clone  

    % any name can be given; it's temporary and doesn't matter 
    model = 'temp';
    clonePath = '/Users/bhisma/courses/cse-700-simvma/simvma/simulink-models/automotive/powerwindow.mdl';

    % close the simulink model the user is working on
    % so that a new system with the same name can be saved
    % the second argument, 0 suppresses the warning which is thrown in case
    % modelPath is not loaded  
    close_system(modelPath, 0);

    new_system(model, 'FromFile', clonePath);
    % system must be either loaded (load_system) or opened (open_system) 
    % before saving (save_system) 
    open_system(model);
    save_system(model, modelPath);
end 