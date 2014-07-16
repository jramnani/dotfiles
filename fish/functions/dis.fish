# I apparently need this convenience function becase I started on Solaris.
# Old habits die hard.
function dis -d "Convenience function to run the object code dissassembler."
  switch $MYOS
    case '*BSD' Linux
      command objdump -d $argv
    case OSX
      command otool -t -V $argv
    case '*'
      command dis $argv
  end
end
