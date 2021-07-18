function simvmaPath = getSimvmaPath()
% Return simvma project's absolute path. If not found, return empty string.
% 
% IMPORTANT: 
% ----------
%  Unlike other functions, this function must not reside inside src/functions
%  because this function is used by initialize.m. (When initialize.m is
%  first invoked, the path src/functions is not yet added to Matlab's
%  path.)

    simvmaPath = ""; 
    % to avoid redundant computation, we first check if the variable 
    % 'simvma_simvmaPath' exists in the workspace. If found, the same 
    % path is returned. If not, a search is made on Matlab's path list to 
    % determine simvmaPath 
    if exist('simvma_simvmaPath', 'var')
        simvmaPath = simvma_simvmaPath; 
    else 
        % the command 'path' returns all paths as a ONE LONG char vector
        paths = string(path);
        if ispc
            % MATLAB recognizes both '\' and '/' as path separators for
            % windows. We make this replacement to avoid the mixing of
            % these two symbols (although that would not be a problem for
            % MATLAB). 
            paths = paths.replace('\', '/'); 
            paths = paths.split(";");
        else 
            paths = paths.split(":");   
        end 
        
        for i=1:length(paths)
           p = string(paths(i));
           if p.endsWith('SimIMA') 
               % more validation to make sure this is indeed the path we are
               % looking for
               dirs = ["src", "Simone-2.0-Complete-Cygwin64-customized-for-simvma"];
               files = ["initialize.m", "getSimvmaPath.m", "sl_customization.m", "README.md"]; 

               okay = true; 
               for i = 1:length(dirs)
                   abspath = p + "/" + dirs(i); 
                  if ~ exist(abspath, 'dir')
                      disp("From getSimvmaPath(): Directory " + abspath + " not found"); 
                      okay = false; 
                      break;
                  end 
               end 

               if okay
                  for i = 1:length(files)
                      abspath = p + "/" + files(i); 
                      if ~ exist (abspath, 'file')
                          disp("From getSimvmaPath(): File " + abspath + " not found");
                          okay = false; 
                          break;  
                      end 
                  end
               end 

               if okay
                   simvmaPath = p;
                   break; 
               end
           end 
        end
    end 
    
    if boolean(simvmaPath)
        % this is not just for debugging, so don't delete
        % we store simvmaPath in workspace to use as a 'cache' for 
        % subsequent calls to getSimvmaPath(). 
        assignin('base', 'simvma_simvmaPath', simvmaPath); 
    end  
end 