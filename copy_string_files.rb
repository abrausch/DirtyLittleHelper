#! /usr/bin/env ruby

require 'optparse'
require 'pp'
require 'ostruct'
require 'rake'
require 'pathname'

# Helper script to get rid of the manual copy actions to add language files to a xcode project
# Example:
# copy_string_files.rb -s ~/Downloads/output/sl -l sl -t /Users/..../XXXClient/Sources

options = OpenStruct.new

OptionParser.new do |opts|
  opts.banner = "Usage copy_string_files.rb [options]"

  opts.on "-s", "--sourceDir SourceDirectory", "Directory containing all the source string files"  do |s|
    options.source_dir = s
  end

  opts.on "-t", "--targetDir TargetDirectory", "Directory containing all the source string files to overwrite"  do |s|
    options.target_dir = s
  end

  opts.on "-l", "--languageCode LanguageCode", "Language code of the target string files. Default is de" do |l|
    options.language_code = l
  end

  # No argument, shows at tail.  This will print an options summary.
  # Try it and see!
  opts.on_tail("-h", "--help", "Show this message") do
    puts opts
    exit
  end

  # Another typical switch to print the version.
  opts.on_tail("--version", "Show version") do
    puts OptionParser::Version.join('.')
    exit
  end
end.parse!

sourceFiles = FileList[options.source_dir + "/*.strings"]

sourceFiles.each do |source_file|
  path_name = Pathname.new(source_file)
  file_name = path_name.basename.to_s

  pattern = options.target_dir + "/**/" + options.language_code + ".lproj/" + file_name

  target_files = FileList[pattern]

  if target_files.size == 0
  end

  target_files.each do |target_file_name|
    target_file = Pathname.new(target_file_name)

    FileUtils.copy_file(path_name,target_file,true)
  end
end




