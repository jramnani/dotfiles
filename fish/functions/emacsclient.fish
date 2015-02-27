# If I'm on OS X, try to use the Cocoa version of Emacs as a server.
# If it isn't running, start it, then use emacsclient to open the file.
# Create a new frame to visit the file.
# Inspired by: http://emacsformacosx.com/tips
#
# NOTE: you must have (server-start) in your init.el.
#
# NOTE: Don't use an ALTERNATE_EDITOR that points to Cocoa Emacs. They will race
# start the server.

function emacsclient -d "Tell the Emacs server to visit the specified files."
    if test $MYOS = "OSX"
       osascript -e 'tell application "Emacs" to activate'
       command emacsclient $argv
    else
        command emacsclient $argv
    end
end
