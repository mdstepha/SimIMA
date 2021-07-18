function answer = dispDlgConfirmation(question)
% Return user's ans (true/false) by prompting the user to choose an option
% (YES/NO) to the passed question. 

    windowTitle = "User's confirmation required!"; 

    buttonName = questdlg(question, windowTitle, 'Yes', 'No', 'No');
   switch buttonName
     case 'Yes'
       answer = true; 
     case 'No'
       answer = false;
     otherwise 
       answer = false; 
   end
end 