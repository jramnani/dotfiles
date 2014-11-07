function top -d "display and update sorted information about processes"
  if test $MYOS = "OSX"
    # On OS X top defaults to sorting by PID descending.
    # That is never what I want when I'm checking process usage.
    command top -o cpu $argv
  else
    command top $argv
  end
end
