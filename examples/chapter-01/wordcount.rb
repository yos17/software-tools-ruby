#!/usr/bin/env ruby
# wordcount.rb — count words
# Usage: echo "one two three" | ruby wordcount.rb
#
# As a library: SoftwareTools.wordcount(text)

require_relative "../../lib/software_tools"

if __FILE__ == $PROGRAM_NAME
  puts SoftwareTools.wordcount(ARGF.read)
end
