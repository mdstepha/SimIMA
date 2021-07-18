classdef Source 
    properties 
        filepath   % absolute path (unlike in simone report). This, unlike realFilepath, may be a symbolic link
        startline 
        endline 
        pcid 
        system 
        realFilepath % absolute path. This, unlike filepath, is always the real filepath. This prop is created to make SimIMA Windows-compatible.
    end 
    
    methods
        function obj = Source(filepath, startline, endline, pcid)
            filepath = string(filepath); 
            obj.filepath = filepath;
            obj.startline = startline; 
            obj.endline = endline;
            obj.pcid = pcid;
            
            % All this overhead about 'realFilepath' is to make SimIMA
            % Windows-compatible. This is because in Windows, 
            % getSystemPathFromStartline won't work with symlink as the filepath. 
            % So, we need to resolve it to the realpath pointed by the symlink.
            % Such path resolution is needed for Clone.source2 (which comes
            % from .../mdl-files/... (not for Clone.source1 which comes from
            % .../mdl-file/sud.mdl)
            
            prefix = getSimvmaPath() + "/Simone-2.0-Complete-Cygwin64-customized-for-simvma/mdl-files/";
                
            if filepath.startsWith(prefix) % true for Clone.source2 
                % convert symlink to realpath 
                symlinkMap = getSharedVar('simvma_symlinkMap'); 
                keys = symlinkMap.keys(); 
                for i = 1 : length(keys)
                    key = keys{i}; 
                    if filepath.startsWith(key)
                        value = symlinkMap(key); 
                        obj.realFilepath = filepath.replace(key, value); 
                        obj.system = getSystemPathFromStartline(obj.realFilepath, startline); 
                        break; 
                    end 
                end 
            else % true for Clone.source1
                obj.realFilepath = filepath; 
            end 
            obj.system = getSystemPathFromStartline(obj.realFilepath, startline); 
        end 
    end 
end 