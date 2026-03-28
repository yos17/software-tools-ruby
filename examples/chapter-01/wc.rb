#!/usr/bin/env ruby
# wc.rb — count lines, words, and characters (like Unix wc)
# Usage: cat file.txt | ruby wc.rb
#        ruby wc.rb file1.txt file2.txt
#
# As a library: SoftwareTools.wc(text) => { lines:, words:, chars: }

require_relative "../../lib/software_tools"

if __FILE__ == $PROGRAM_NAME
  r = SoftwareTools.wc(ARGF.read)
  puts "%8d %8d %8d" % [r[:lines], r[:words], r[:chars]]
end
