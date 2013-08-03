function fish_greeting -d "Set the value of fish_greeting"
  if set -q GREETING
    echo $GREETING
    return
  end

  set GREETING (uname -srp) " -- "

  if test -x /usr/bin/java
    set JAVA_VERSION (java -version 2>| awk '/java version/ { print $3 }')
    set GREETING $GREETING "Java $JAVA_VERSION, "
  end

  if test -x (which python)
    set PYFULLVERSION (python -V 2>| awk '{print $2}')
    set GREETING $GREETING "Python $PYFULLVERSION, "
  end

  if test -x (which ruby)
    set RUBY_VERSION (ruby --version | awk '{print $2}')
    set GREETING $GREETING "Ruby $RUBY_VERSION, "
  end

  if test -x (which node)
    set NODE_VERSION (node --version)
    set GREETING $GREETING "Node.js $NODE_VERSION"
  end

  # Set a global variable as a signal, so we don't run these commands again
  # each time we open a new shell.
  # Erase the global variable to reset.
  set -g GREETING $GREETING
  echo "$GREETING"
end
