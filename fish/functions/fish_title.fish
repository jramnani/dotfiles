function fish_title
    echo $USER'@'(hostname -s) (basename (pwd))
end
