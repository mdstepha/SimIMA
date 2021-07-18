- This folder shall contain .mat files. 

- Each of these .mat file shall store exactly one variable. 

- The variable's name stored by any .mat file is the same
  as the name of the file itself (after removing the trailing .mat). 

- Naming convention of each .mat file (and hence that of the 
  stored variable) is : simvma_varNameCamelCase.
  By following this convention, will will avoid accidently overriding 
  user's workspace variables as the corresponding .mat file is loaded. 

- The variables which are accessed by mulitiple .m or .mlapp files in the 
  project, and are either not convenient or impossible to pass between those 
  .m or .mlapp files will be stored in this folder in their respective .mat 
  files. 

- Thus, this folder will serve as a 'database' for such variables. 

- Access/Modify these variables using functions 'getSharedVar', and 
  'setSharedVar'. To access simvma_appAdminState.nSuggsMax, we have a 
  dedicated function getNSuggMax() too. This function was created because 
  simvma_appAdminState.nSuggsMax is accessed frequently 
