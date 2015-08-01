# Snippet from Issue #417
# https://github.com/fish-shell/fish-shell/issues/417

# OS X uses the contents of /etc/paths and /etc/paths.d/* to set the PATH.
function load_path_helper_paths
  # clear the prev path
  set PATH

  # add each dir in /etc/paths, topmost first
  if test -f /etc/paths
      for dir in (cat /etc/paths)
          if test -d $dir
              set PATH $PATH $dir
          end
      end
  end

  # append content of each file in /etc/paths.d
  if test -d /etc/paths.d
      for file in /etc/paths.d/*
          if test -d (cat $file)
              set PATH $PATH (cat $file)
          end
      end
  end

  # if there is nothing, use a default path (should not happen, but who knows)
  if [ (count $PATH) = 0 ]
      set PATH /usr/bin /bin
  end

  # export the path
  set -x PATH $PATH
end
