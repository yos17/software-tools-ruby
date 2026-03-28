#!/usr/bin/env ruby
# copy.rb — copy stdin to stdout
# Usage: ruby copy.rb [file...]  OR  echo "hello" | ruby copy.rb
#
# As a library: SoftwareTools.copy(text)

require_relative "../../lib/software_tools"

# CLI mode
if __FILE__ == $PROGRAM_NAME
  print SoftwareTools.copy(ARGF.read)
end
