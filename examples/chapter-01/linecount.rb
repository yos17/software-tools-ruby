#!/usr/bin/env ruby
# linecount.rb — count lines
# Usage: cat file.txt | ruby linecount.rb
#
# As a library: SoftwareTools.linecount(text)

require_relative "../../lib/software_tools"

if __FILE__ == $PROGRAM_NAME
  puts SoftwareTools.linecount(ARGF.read)
end
