#!/usr/bin/env ruby

require 'nokogiri'

file = File.open(ARGV[0])
filename = File.basename(file, ".storyboard")
doc = Nokogiri::XML(file)

objects = doc.xpath("//objects")


objects.each do |object|
  object.children.each do |child|
    if child.instance_of? Nokogiri::XML::Element
      p child['userLabel']
      input = STDIN.gets.chomp
      p input
      if input == "j"
        userDefinedRuntimeAttributes = Nokogiri::XML::Node.new "userDefinedRuntimeAttributes", doc
        userDefinedRuntimeAttribute1 = Nokogiri::XML::Node.new "userDefinedRuntimeAttribute", doc
        userDefinedRuntimeAttribute2 = Nokogiri::XML::Node.new "userDefinedRuntimeAttribute", doc
        userDefinedRuntimeAttribute1['type'] = "string"
        userDefinedRuntimeAttribute1['keyPath'] = "containerName"
        userDefinedRuntimeAttribute1['value'] = filename
        userDefinedRuntimeAttribute2['type'] = "string"
        userDefinedRuntimeAttribute2['keyPath'] = "containerConfigurationName"
        userDefinedRuntimeAttribute2['value'] = child['userLabel']
        userDefinedRuntimeAttributes.add_child userDefinedRuntimeAttribute1
        userDefinedRuntimeAttributes.add_child userDefinedRuntimeAttribute2

        child.add_child(userDefinedRuntimeAttributes)
      end
    end
  end
end

File.open(file, 'w') {|f| f.write(doc.to_xml) }
