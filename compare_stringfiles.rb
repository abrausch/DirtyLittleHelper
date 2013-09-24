require 'rake'

# Sample call
# ruby compare_stringfiles.rb Resources/de.lproj/Localizable.strings Resources/pl.lproj/Localizable.strings
# ruby compare_stringfiles.rb "Sources/**/de.lproj/*.strings" "Sources/**/pl.lproj/*.strings"

BASE_STRING_LIST = FileList[ARGV[0]]

compare_string_list = []

if ARGV.size > 1
  compare_string_list = FileList[ARGV[1]]
else
  compare_string_list = FileList["sources/**/*.strings"].exclude(BASE_STRING_LIST)
end

hash = Hash.new

BASE_STRING_LIST.each do |base_file_name|
  base_strings = []
  File.open(base_file_name, 'r') do |base_file|
    while line = base_file.gets
      match = /(")([^"]*)(")/.match(line)
      unless match.nil?
        base_strings << match[2]
        hash[match[2]] = line
      end
    end
  end

  compare_string_list.each do |compare_file_name|
    compare_strings = []
    if File.basename(base_file_name) == File.basename(compare_file_name)
      File.open(compare_file_name, 'r') do |compare_file|
        while line = compare_file.gets
          match = /(")([^"]*)(")/.match(line)
          unless match.nil?
            compare_strings << match[2]
          end
        end
      end
      missing_string = base_strings - compare_strings

      if missing_string.size > 0
        p compare_file_name
        missing_string.each do |string|
          p hash[string]
        end
      end
    end
  end
end


