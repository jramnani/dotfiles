function workon -d "Activate virtual environment in $WORKON_HOME"
  if test -z $argv[1]
    find $WORKON_HOME -maxdepth 1 -type d -print | xargs basename 
  else
    set tgt {$WORKON_HOME}/$argv[1]
    if [ -d $tgt ]

      deactivate

      set -gx VIRTUAL_ENV $tgt
      set -gx _OLD_VIRTUAL_PATH $PATH
      set -gx PATH $VIRTUAL_ENV/bin $PATH

      # unset PYTHONHOME, if set
      if set -q PYTHONHOME
        set -gx _OLD_VIRTUAL_PYTHONHOME $PYTHONHOME
        set -e PYTHONHOME
      end
    else
      echo "$tgt not found"
    end
  end
end
