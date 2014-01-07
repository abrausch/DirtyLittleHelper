#!/usr/bin/env ruby

require 'securerandom'
require 'rexml/document'


ARGV.each do|a|
  puts "Reading file: #{a}"
  counter = 0;
  File.open(a, "r") do |infile|
    firstline = true
    i = 0
    while (line = infile.gets)
      #a new crash report starts
      if line.include? "<crash>"
        xmlString = ""
      end

      if line.include? "[TODO]"
        line.gsub!("[TODO]", i.to_s)
        i = i + 1
      end

      if (!xmlString.nil?)
        xmlString << line
      end

      if line.include? "</crash>"
        systemversion = "unknown"
        doc = REXML::Document.new(xmlString)
        system = doc.root.elements[3].text
        version = doc.root.elements[5].text

        puts version

        if (!File.directory?(version))
          Dir.mkdir(version)
        end

        if (!File.directory?("#{version}/#{system}"))
          Dir.mkdir("#{version}/#{system}")
        end

        fileName = "#{version}/#{system}/#{counter}.crash"
        crashReport = doc.root.elements["log"].text

        File.open(fileName, 'w') {|f| f.write(crashReport) }

      end

      counter = counter + 1
    end
  end
end
