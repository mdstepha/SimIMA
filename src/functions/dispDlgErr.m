function  dispDlgErr(msg, title)
% Display error message in a Window.
% 
% PARAMETERS: 
% -----------
% msg (string): message to be displayed
% title(string): optional; title of the dialog window

    if nargin == 1  % title not provided
        title = "ERROR";
    end
    errordlg(msg, title);
end