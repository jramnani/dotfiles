function java_version -d "Configure the version of Java to use for your shell. (OS X only)"
  set -l USAGE "Usage: java_version [JAVA_VERSION]"

  if not count $argv >/dev/null
    echo "$USAGE"
    return 1
  end

  if count $argv >/dev/null
    switch $argv[1]
      case -h --h --he --hel --help "help"
        echo $USAGE
        return 1
    end
  end

  set -l JAVA_VERSION $argv[1]
  set -x JAVA_HOME (/usr/libexec/java_home -v $JAVA_VERSION)
end
