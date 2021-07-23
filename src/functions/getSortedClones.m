function [clones, simoneError] = getSortedClones(simvmaPath, clonePaths, maxClones, ... 
                      ignore100PercentMatchingClones, sudPath, simone_difflimit, ...
                      simone_minsize, simone_maxsize, simone_rename)
% get clones as 'cell'
% each clone is a Clone object, 
% and can be accessed as ans{index}.
% 
% We are returning simoneError in addition to clones because it is needed
% by evaluateOneSet.m (in SimXample-evaluation) 
%
% PARAMETERS:
% -----------
% simvmaPath        : string --absolute path of simvma project 
% clonePaths        : string -- list of absolute paths of the directories containing
%                     mdl files with potential clones
% simone_difflimit  : int -- maximum allowable difference between clones 
% simone_minsize    : int -- minimum number of lines required for a (sub)system 
%                            to be considered as a potential clone 
% simone_maxsize    : int -- maximum  number of lines allowed for a (sub)system 
%                            to be considered as a potential clone 
% simone_rename     : string -- what kind of filtering to be applies
%                            Possible values: "none"/"blind"/"consistent"

% simone_maxClones  : maximum number of clones to be returned
% ignore100PercentMatchingClones    : if true, 100% matching clones will be
%                                     ignored
 
    originalPath = pwd;        % backup 
    srcPath = simvmaPath + "/src"; 
    simonePath = simvmaPath + "/Simone-2.0-Complete-Cygwin64-customized-for-simvma"; 
    simoneXmlReportPath = simonePath + "/mdl-file_systems-sort-blind-crossclones/mdl-file_systems-sort-blind-crossclones-0." + simone_difflimit + ".xml";

    cd(simonePath)             
    disp("Removing links to previous clonePaths, if any ..."); 
    if exist('mdl-files', 'dir')
        rmdir('mdl-files', 's');  % remove directory mdl-files including its sub-directory tree 
    end 
    disp(" ");
    
    % remove previous simone results, if any 
    if ispc 
        cmd = getCygwinPath() + "/bin/bash cleanall";
    else 
        cmd = "./cleanall";
    end 
    disp(cmd); 
    unix(cmd); 
    
    mkdir('mdl-files');  % re-create empty mdl-files directory 
    
    % make symbolic links of all clone-paths to mdl-files/
    
    % NOTE: symbolic links will work fine for Simone under Windows too because Simone will be executed from within cygwin. 
    % However, later when creating Clone objects from the Simone xml report,  
    % MATLAB (in Windows) will complain "Invalid file identifier" as it won't be able to recognize the file using symbolic links. 
    % This error will be raised from getClonesFromXmlFile -> createCloneFromXmlElementLines -> createSourceFromXmlElement -> Source -> getSystemPathFromStartLine 
    % Thus, to make SimIMA windows-compatible, we save the mapping from the
    % symbolic link to the original file in shared-var simvma_symlinkMap. 
    % Since the filepaths include characters such as :, \, /, -, etc which
    % are not supported as keys in struct, we implement this map using
    % containers.Map 
    
    symlinkMap = containers.Map;  % key: symlink, val: original path 
    for i = 1:length(clonePaths)
        clonePath = clonePaths(i);
        if ispc 
            cmd = getCygwinPath() + "/bin/ln -s " + clonePath + " mdl-files/";   
        else 
            cmd = "ln -s " + clonePath + " mdl-files/";
        end 
        disp(cmd); 
        unix(cmd);
        
        clonePathTokens = clonePath.split('/'); 
        clonePathDirName = clonePathTokens(end); 
        symlinkPath = simonePath + "/mdl-files/" + clonePathDirName; 
        symlinkMap(symlinkPath) = clonePath;
    end    
    setSharedVar('simvma_symlinkMap', symlinkMap); 
    
    % make sure the configuration file for Simone exists
    createOrUpdateSimoneConfigFile(simone_difflimit, simone_minsize,  simone_maxsize, simone_rename, simvmaPath);  

    disp(newline + "Running SIMONE to extract clones ... "); 
    % eg: ./simonecross -difflimit 50% mdl-file mdl-files 
    if ispc 
        cmd = getCygwinPath() + "/bin/bash simonecross -difflimit " + simone_difflimit + "% mdl-file mdl-files"; 
    else 
        cmd = "./simonecross -difflimit " + simone_difflimit + "% mdl-file mdl-files"; 
    end 
    unix(cmd); 
    
    cd(srcPath);    
    
    if exist(simoneXmlReportPath, 'file')
        simoneError = false; 
        clones = getClonesFromXmlFile(simoneXmlReportPath, simvmaPath);
        clones = sortClonesBySimilarity(clones);
        clones = filterOutDuplicateClones(clones);
        
        assignin('base', 'allClones', clones); % export to workspace (for debugging) 
        dispClones(clones, "ALL SORTED CLONES ( Total : " + length(clones) + " )"); 
        dispSpaced("# All clones : " + length(clones)); 

        if ignore100PercentMatchingClones
            clones = filterOutClonesBeyondThreshold(clones, simone_difflimit, 99);
        else 
            clones = filterOutClonesBeyondThreshold(clones, simone_difflimit, 100); 
        end 
        
        dispSpaced("# clones < 100% similarity : " + length(clones)); 
                
        clones = filterOutClonesWithSource1NotMatchingSUD(clones, sudPath); 
        dispSpaced("# clones matching SUD : " + length(clones)); 
        assignin('base', 'clones', clones); % export to workspace (for debugging) 


        if length(clones) > maxClones
            clones = clones(1:maxClones);
        end 
        
        dispSpaced("# clones selected to create suggestions : " + length(clones)); 

        
    else
        simoneError = true; 
        clones = {}; 
    end 
        
    cd(originalPath)           % return to the original path 
end