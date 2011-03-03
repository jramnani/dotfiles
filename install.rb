#!/usr/bin/env ruby

# == Synopsis
#
# install.rb: Installs my profile on a given machine.
#
# == Usage
#
# install.rb [OPTIONS]
#
# -h, --help:
#    show help
#
# --eggs, -e
#    Install the Python Eggs specified in the file, "eggs_to_install"
#
# --gems, -g
#    Install the RubyGems specified in the file, "gems_to_install"
#
# --profile, -p
#    Install profile on local machine

require 'fileutils'
require 'getoptlong'
require 'rdoc/usage'

NOT_PROFILE_FILES = %w[eggs_to_install examples gems_to_install install.rb 
                       LICENSE Rakefile rakefile README windows ipython ipythonrc]
def install_profile
  # Create the directory where I place my Vim backup files.
  FileUtils.mkdir_p File.join(ENV['HOME'], 'tmp', 'vim')
  # Copy IPython configuration file.
  FileUtils.mkdir_p(File.join(ENV["HOME"], ".ipython"))
  target = "#{File.join(FileUtils.pwd, "ipython", "ipy_user_conf.py")}"
  link = "#{File.join(ENV['HOME'], '.ipython', 'ipy_user_conf.py')}"
  FileUtils.ln_s(target, link, :force => true)

  replace_all = false

  Dir['*'].each do |file|
    next if NOT_PROFILE_FILES.include? file

    if File.exist?(File.join(ENV['HOME'], ".#{file}"))
      if replace_all
        replace_file(file)
      else
        print "overwrite ~/.#{file}? [ynaq] "
        case $stdin.gets.chomp
        when 'a'
          replace_all = true
          replace_file(file)
        when 'y'
          replace_file(file)
        when 'q'
          exit
        else
          puts "skipping ~/.#{file}"
        end
      end
    else
      link_file(file)
    end
  end
end

def replace_file(file)
  FileUtils.rm_rf("#{ENV["HOME"]}/.#{file}")
  link_file(file)
end
 
def link_file(file)
  puts "linking ~/.#{file}"
  FileUtils.ln_s "#{FileUtils.pwd}/#{file}", "#{ENV["HOME"]}/.#{file}"
end

def install_gems
  File.open("gems_to_install").each do |gem|
    next if gem =~ /^#/
    Kernel.system("gem install #{gem.chomp}")
  end 
end

def install_eggs
  File.open("eggs_to_install").each do |egg|
    next if egg =~ /^#/
    Kernel.system("easy_install #{egg.chomp}")
  end
end

## MAIN ##

opts = GetoptLong.new(
  [ '--eggs', '-e', GetoptLong::NO_ARGUMENT ],
  [ '--gems', '-g', GetoptLong::NO_ARGUMENT ],
  [ '--help', '-h', GetoptLong::NO_ARGUMENT ],
  [ '--profile', '-p', GetoptLong::NO_ARGUMENT ]
)

opts.each do |opt, arg|
  case opt
  when "--eggs"
    install_eggs
    exit
  when "--gems"
    install_gems
    exit
  when "--help"
    RDoc::usage
  when "--profile"
    install_profile
    exit
  end
end

if ARGV.length == 0
  RDoc::usage
end

