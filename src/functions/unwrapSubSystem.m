function unwrapSubSystem(subSystemPath)
% Un-wrap the given (sub)system. 
%
% PARAMETERS
% ---------- 
% subSystemPath : string -- path of the subsystem to be unwrapped
%
% ASSUMPTIONS: 
% ------------
%  - path is a valid path to a sub-system (not the top-system)
 

  Simulink.BlockDiagram.expandSubsystem(subSystemPath); 
  
  % by default, after unwrapping (expanding) the original subsystem, 
  % it is wrapped in an 'annotation' whose name is the same as that of 
  % expanded subsystem 
  % we want to remove this annotation. 

  %   APPROACH: 
  %   1. get path of parent system  
  %   2. get all annotations in parent system  
  %   3. remove the annotation whose name matches with that of expanded subsystem
  
  
  subSystemPath = string(subSystemPath); 
  tokens = subSystemPath.split('/'); 
  subsystemName = tokens(end); % to be used later 
  tokens(end) = []; % remove last token 
  parentPath = tokens.join('/'); 
  
  annotations = find_system(parentPath, 'FindAll', 'on', 'Type', 'annotation'); 
  annotationNames = get_param(annotations, 'Name');  % cell array 
  for i = 1: length(annotationNames)
    annotationName = string(annotationNames(i)); 
    if annotationName == subsystemName
       delete(annotations(i));
    end
  end
end