#!/usr/bin/env ruby
# detab.rb — replace tabs with spaces
# Usage: printf "a\tb\tc\n" | ruby detab.rb [tab_width]
#        ruby detab.rb 4 file.txt
#
# As a library: SoftwareTools.detab(text, tab_width: 4)

require_relative "../../lib/software_tools"

if __FILE__ == $PROGRAM_NAME
  tab_width = 8
  tab_width = ARGV.shift.to_i if ARGV.first =~ /^\d+$/
  print SoftwareTools.detab(ARGF.read, tab_width: tab_width)
end
