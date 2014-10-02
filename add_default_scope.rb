#!/usr/bin/env ruby

require 'nokogiri'

file = File.open(ARGV[0])

doc = Nokogiri::XML(file)

components = doc.xpath("//component")

components.each do |component|
  if component["scope"] == nil
    component["scope"] = "call"
  end
end

File.open(file, 'w') {|f| f.write(doc.to_xml) }