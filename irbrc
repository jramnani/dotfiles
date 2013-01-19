require 'rubygems'
require 'irb/completion'

ARGV.concat [ "--readline", "--prompt-mode", "simple"]

def ri(*names)
    system(%{ri #{names.collect { |name| name.to_s } } } )
end

def cls
    system('clear')
end

class Object
    # methods that are relatively unique to the object in question.
    def my_methods(x)
        (x.methods - Object.new.methods)
    end
end

