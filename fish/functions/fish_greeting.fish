function fish_greeting -d "Set the value of fish_greeting"
  if set -q GREETING
    echo $GREETING
    return
  end

  set GREETING (uname -srp) " -- "

  set -l JAVA (which java)
  if test -x "$JAVA"
    set JAVA_VERSION (java -version 2>| awk '/ version / { print $3 }')
    set GREETING $GREETING "Java $JAVA_VERSION, "
  end

  set -l PYTHON (which python)
  if test -x "$PYTHON"
    set PYFULLVERSION (python -V 2>| awk '{print $2}')
    set GREETING $GREETING "Python $PYFULLVERSION, "
  end

  set -l RUBY (which ruby)
  if test -x "$RUBY"
    set RUBY_VERSION (ruby --version | awk '{print $2}')
    set GREETING $GREETING "Ruby $RUBY_VERSION, "
  end

  set -l NODEJS (which node)
  if test -x "$NODEJS"
    set NODE_VERSION (node --version)
    set GREETING $GREETING "Node.js $NODE_VERSION"
  end

  # Set a global variable as a signal, so we don't run these commands again
  # each time we open a new shell.
  # Erase the global variable to reset.
  set -g GREETING $GREETING
  echo "$GREETING"
end
