# Use GnuPG 2.0.x if it exists, else try 1.0.x
function gpg -d "OpenPGP encryption and signing tool"
    if test (which gpg2)
        command gpg2 $argv
    else
        command gpg $argv
    end
end
