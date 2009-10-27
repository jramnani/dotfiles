require 'rubygems'
require 'irb/completion'
ARGV.concat [ "--readline", "--prompt-mode", "simple"]
begin
    # load wirble
    require 'wirble'

    # start wirble (with color)
    Wirble.init
    Wirble.colorize
rescue LoadError => err
    warn "Couldn't load Wirble: #{err}"
end

def ri(*names)
    system(%{ri #{names.collect { |name| name.to_s } } } )
end

def cls
    system('cls')
end

class Object
    def my_methods(x)
        (x.methods - Object.new.methods)
    end
end

