#!/usr/bin/env ruby
# charcount.rb — count characters
# Usage: echo "hello" | ruby charcount.rb
#        ruby charcount.rb file.txt
#
# As a library: SoftwareTools.charcount(text)

require_relative "../../lib/software_tools"

if __FILE__ == $PROGRAM_NAME
  puts SoftwareTools.charcount(ARGF.read)
end
