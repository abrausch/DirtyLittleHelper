#!/usr/bin/env ruby

require 'xcoder'
require 'rake'
#require 'ruby-prof'

#RubyProf.start

project_file = ARGV[0]
source_target_name = ARGV[1]
destination_target_name = ARGV[2]

p project_file
p source_target_name
p destination_target_name

project = Xcode.project(project_file)

source_target = project.target(source_target_name)
destination_target = project.target(destination_target_name)

source_compile_build_files = source_target.sources_build_phase.build_files
source_resource_build_files = source_target.resources_build_phase.build_files

destination_compile_build_files = destination_target.sources_build_phase.build_files
destination_resource_build_files = destination_target.resources_build_phase.build_files

p "Working on the compile build phase"
source_compile_build_files.each do |build_file|
  found = false
  
  destination_compile_build_files.each do |destination_build_file|
    if build_file.path == destination_build_file.path 
      found = true
      break
    end
  end
  
  if !found 
    p "Adding #{build_file}"
    destination_target.sources_build_phase.add_build_file_unsafe build_file
  end
end

p "Working on the resource build phase"
source_resource_build_files.each do |build_file|
  found = false
  
  destination_resource_build_files.each do |destination_build_file|
    if build_file.path == destination_build_file.path 
      found = true
      break
    end
  end
  
  if !found 
    p "Adding #{build_file}"
    destination_target.resources_build_phase.add_build_file_unsafe build_file
  end
end



#result = RubyProf.stop
#printer = RubyProf::MultiPrinter.new(result)
#printer.print(:path => ".", :profile => "profile")

project.save!