function  dispDlgMsg(msg, title)
% Display message in a Window.
% 
% PARAMETERS: 
% -----------
% msg (string): message to be displayed
% title(string): optional; title of the dialog window

    if nargin == 1  % title not provided
        title = "User's action required!";
    end
    warndlg(msg, title);
end