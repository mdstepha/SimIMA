function changed = detectChangesInRepos(prevAppAdminState, newAppAdminState, verbose)
    % returns true if there is any change in any default or custom
    % repository. A change means one or more of the following:
    % - addition/deletion of a mdl or slx file in a default repo
    % - addition/deletion of a mdl or slx file in a custom repo
    % - change of 'checked' status for 1 or more default repo
    % * if a custom repopath NOT containing any mdl or slx files 
    %   is added, it won't be detected as a 'change' (which is
    %   good as we don't want to update our prediction models in
    %   that case)

    if verbose
        dispUnderlined("Previous State")
        disp(prevAppAdminState);
        dispUnderlined("New State")
        disp(newAppAdminState);
        disp("Detecting changes in repositories...");
    end 

    changed = false;  % default 

    % loop over default repos  
    for i = 1 : 6
        % check for potential change of 'checked' status of 1 or more default repos 
        status1 = prevAppAdminState.("defRepo" + i + "Checked");
        status2 = newAppAdminState.("defRepo" + i + "Checked");
        if status1 ~= status2
             changed = true; 
             if verbose
                 disp("Change detected in default repo " + i + " checked status");
             end
             return; 
        end

        % check for potential addition/deletion of mdl/slx files in default repos       
        paths1 = prevAppAdminState.("relpathsOfMdlSlxInDefRepo" + i);
        paths2 = newAppAdminState.("relpathsOfMdlSlxInDefRepo" + i);

        diff1 = setdiff(paths1, paths2);
        diff2 = setdiff(paths2, paths1); 
        diff = union(diff1, diff2);

        if ~isempty(diff)
            changed = true; 
            if verbose
               disp("Change detected in relpathsOfMdlSlxInDefRepo " + i);
            end
            return; 
        end
    end

    % loop over custom repos 
    % check for potential addition/deletion of mdl/slx files in custom repos             
    for i = 1 : 5 
        paths1 = prevAppAdminState.("abspathsOfMdlSlxInCstRepo" + i);
        paths2 = newAppAdminState.("abspathsOfMdlSlxInCstRepo" + i); 

        diff1 = setdiff(paths1, paths2);
        diff2 = setdiff(paths2, paths1); 
        diff = union(diff1, diff2);

        if ~isempty(diff)
            changed = true; 
            if verbose
               disp("Change detected in abspathsOfMdlSlxInCstRepo " + i);
            end
            return; 
        end
    end

    if verbose
        disp("No change detected in repositories.");
    end
end