function createOrUpdateSimoneConfigFile(difflimit, minsize, maxsize, rename, simvmaPath)
% Create or Update configuration file for Simone 
% A new file will be created if a configuration file is not found matching
% provided difflimit
% If a configuration file exists for given difflimit, the same file will be
% updated. 
% The file will be located at:
%    .../simvma/Simone-2.0-Complete-Cygwin64-customized-for-simvma/config/
%
% PARAMETERS:
% -----------
% difflimit    : int -- maximum allowable difference between clones 
% minsize      : int -- minimum number of lines required for a (sub)system 
%                to be considered as a potential clone 
% maxsize      : int -- maximum  number of lines allowed for a (sub)system 
%                to be considered as a potential clone 
% rename       : string -- what kind of filtering to be applies
%                  Possible values: "none"/"blind"/"consistent"
% simvmaPath   : absolute path of simvma project 

    configFilepath = simvmaPath + "/Simone-2.0-Complete-Cygwin64-customized-for-simvma/config/simone" + difflimit + ".cfg"; 
    templatePath = simvmaPath + "/Simone-2.0-Complete-Cygwin64-customized-for-simvma/config/template.cfg"; 

    lines = string.empty;
    fid = fopen(templatePath, 'r'); 
    while ~feof(fid)
        line = fgets(fid); % char vector 
        line = string(line);
        
        tokens = line.split('='); 
        if length(tokens) == 2 
            if tokens(1) == "threshold"
                tokens(2) = string(difflimit / 100) + "\n"; 
              
            elseif tokens(1) == "minsize" 
                tokens(2) = string(minsize) + "\n"; 
               
            elseif tokens(1) == "maxsize" 
                tokens(2) = string(maxsize) + "\n"; 
               
            elseif tokens(1) == "rename" 
                tokens(2) = rename + "\n";                
            end
            
            line = tokens.join('='); 
        end
        lines = [lines line]; 
    end 
    fclose(fid); 

    fid = fopen(configFilepath, 'w'); 
    for i = 1:length(lines)
        line = lines{i}; 
        line = strrep(line, '%', '%%');  % because '%' is escaped by matlab 
        fprintf(fid, line); 
    end 
    fclose(fid); 
end