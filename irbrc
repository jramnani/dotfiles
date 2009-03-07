require 'irb/completion'
ARGV.concat [ "--readline", "--prompt-mode", "simple"]

def ri(*names)
    system(%{ri #{names.collect { |name| name.to_s } } } )
end

def cls
    system('cls')
end
