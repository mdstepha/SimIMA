function cygwinPath = getCygwinPath()
% Return cygwin's path 
    
    % MATLAB recognizes both '\' and '/' as path separators for
    % windows. So, we use '/' instead of '\' for consistency
    cygwinPath = "C:/cygwin64";  
    
end 