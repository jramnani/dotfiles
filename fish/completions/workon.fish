#complete -c workon -a "(set OLDPWD $PWD; cd $WORKON_HOME; ls -d *; cd $OLDPWD)"

complete -x -c workon -a "(find $WORKON_HOME -maxdepth 1 -type d -print | xargs basename | grep -v (basename $WORKON_HOME))"
