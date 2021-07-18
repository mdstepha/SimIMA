function suggestion = getSuggestionFromClone(clone, rank, simvmaPath) 
% create Suggestion object clone.source2
% WARNING: This will override any suggestion<rank>.mdl and
% suggestion<rank>.png files in simvma/tmp/ folder

    % remove corresponding mdl and png files from simvma/tmp/ folder 
    cmd = "rm " + simvmaPath + "/tmp/simxample-suggs/suggestion" + rank + "_*";
    unix(cmd); 

    source = clone.source2;
    similarity = clone.similarity; 
    % we insert a random number in the filename to make it unique everytime
    % it is generated. Because, app-designer does not reload images when
    % name remains unchanged. 
    randomNumber = randi(1000000);
    mdlFilepath = simvmaPath + "/tmp/simxample-suggs/suggestion" + rank + "_" + randomNumber + ".mdl"; 
    imgFilepath = simvmaPath + "/tmp/simxample-suggs/suggestion" + rank + "_" + randomNumber + ".png";
    
    createMdlFileFromSource(source, mdlFilepath, simvmaPath); 
    exportMdlAsPng(mdlFilepath, imgFilepath); 
    
    suggestion = Suggestion(similarity, source, mdlFilepath, imgFilepath, rank); 
end 