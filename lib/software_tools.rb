require_relative "software_tools/version"
require_relative "software_tools/intro"
require_relative "software_tools/filters"
require_relative "software_tools/fileio"
require_relative "software_tools/sorting"
require_relative "software_tools/find"
require_relative "software_tools/change"
require_relative "software_tools/format"
require_relative "software_tools/macros"
require_relative "software_tools/pipeline"

# SoftwareTools — Unix text processing tools in Ruby
# Inspired by "Software Tools in Pascal" by Kernighan & Plauger
#
# Usage as library:
#   require 'software_tools'
#
#   SoftwareTools.wordcount("hello world\n")    # => { lines: 1, words: 2, chars: 12 }
#   SoftwareTools.sort(text)                    # => sorted string
#   SoftwareTools.grep("error", text)           # => matching lines
#
# Chainable:
#   Tools.new(text).grep("error").sort.uniq.result
module SoftwareTools
  extend Intro
  extend Filters
  extend FileIO
  extend Sorting
  extend Find
  extend Change
  extend Format
  extend Macros
end

# Shorthand alias
Tools = SoftwareTools
