#!/usr/bin/env ruby

require 'xcoder'
require 'rake'
# require 'ruby-prof'

# RubyProf.start

container_files = Rake::FileList.new("Sources/**/*.x5c")

project = Xcode.project('LidlClient.xcodeproj')
registry = project.registry
objects = registry.objects
named_objects = Hash[objects.map { |key, value| [value["path"], key]}]

def find_file(name, files) 
  files.find {|file| file.name == name or file.path == name }
end

def find_object(file_name, objects, registry)
  result = nil
  objects.each do |key, value|
    if value["path"] == file_name
      return registry.object key
      break
    end    
  end
end
  

project.targets.each do |target|
  p "Working on target: #{target.name}"
  if target.product_type == "com.apple.product-type.application"
    build_phase = target.sources_build_phase
    build_files = build_phase.build_files
    
    resource_phase = target.resources_build_phase    
    resource_files = resource_phase.build_files
    
    container_files.each do |container_file|
      file_name = File.basename(container_file)
      
      
      if find_file(file_name, build_files) == nil
        file_key = named_objects[file_name]
        p "adding #{file_name}"
        build_phase.add_build_file registry.object(file_key)
      end
      
      if  find_file(file_name, resource_files) != nil
        build_file = resource_phase.file(file_name)
        
        if build_file != nil
          resource_phase.properties["files"].delete(build_file.identifier)
        end        
      end  
    end    
  end
end

#result = RubyProf.stop
#printer = RubyProf::MultiPrinter.new(result)
#printer.print(:path => ".", :profile => "profile")

project.save!