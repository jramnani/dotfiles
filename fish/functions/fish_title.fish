function fish_title
    printf "\033]0;%s@%s: %s\007" $USER (hostname) $PWD
end
