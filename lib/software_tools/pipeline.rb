# Chainable pipeline DSL
# Usage:
#   Tools::Pipeline.new(text).grep("error").sort.uniq.result
#   Tools.pipe(text).grep("error").sort.uniq.result
module SoftwareTools
  class Pipeline
    include Intro
    include Filters
    include FileIO
    include Sorting
    include Find
    include Change
    include Format
    include Macros

    attr_reader :text

    def initialize(text)
      @text = text.to_s
    end

    # Chain any SoftwareTools method that takes text as first arg
    def method_missing(name, *args, **kwargs, &block)
      if SoftwareTools.respond_to?(name)
        result = SoftwareTools.send(name, @text, *args, **kwargs, &block)
        result.is_a?(String) ? Pipeline.new(result) : result
      else
        super
      end
    end

    # Explicitly override methods that conflict with Ruby built-ins
    def sort(**kwargs)
      Pipeline.new(SoftwareTools.sort(@text, **kwargs))
    end

    def uniq(**kwargs)
      Pipeline.new(SoftwareTools.uniq(@text, **kwargs))
    end

    def grep(pattern, **kwargs)
      Pipeline.new(SoftwareTools.grep(pattern, @text, **kwargs))
    end

    def change(pattern, replacement, **kwargs)
      Pipeline.new(SoftwareTools.change(@text, pattern, replacement, **kwargs))
    end

    def format(**kwargs)
      Pipeline.new(SoftwareTools.fmt(@text, **kwargs))
    end

    def respond_to_missing?(name, include_private = false)
      SoftwareTools.respond_to?(name) || super
    end

    # Get final result
    def result
      @text
    end

    alias to_s result

    # Print to stdout
    def print_result
      print @text
      self
    end

    # Write to file
    def write_to(path)
      File.write(path, @text)
      self
    end

    # Split into lines array
    def lines
      @text.lines
    end
  end

  # Convenience method: SoftwareTools.pipe(text)
  def self.pipe(text)
    Pipeline.new(text)
  end
end
