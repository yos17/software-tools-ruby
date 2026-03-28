# Chapter 8 — Macros: define, expand, ERB templates
module SoftwareTools
  module Macros
    # Process #define macros in text
    def define(text)
      macros = {}
      result = []
      text.lines.each do |line|
        case line.chomp
        when /^#define\s+(\w+)\s+(.*)/  then macros[$1] = $2
        when /^#undef\s+(\w+)/          then macros.delete($1)
        else                                  result << _expand_macros(line, macros)
        end
      end
      result.join
    end

    # Expand a hash of macros in text
    def expand_macros(text, macros = {})
      _expand_macros(text, macros)
    end

    # Process .define macro with $1 $2 arguments
    def macro(text)
      macros = {}
      result = []
      text.lines.each do |line|
        if line =~ /^\.define\s+(\w+)\s+(.*)/
          macros[$1] = $2.chomp
        else
          result << _expand_macro_line(line, macros)
        end
      end
      result.join
    end

    # Process ERB template with a hash of variables
    def template(text, vars = {})
      require 'erb'
      b = binding
      vars.each { |k, v| b.local_variable_set(k.to_sym, v) }
      ERB.new(text).result(b)
    end

    private

    def _expand_macros(text, macros, depth = 0)
      return text if depth > 20
      result = text.dup
      macros.each do |name, value|
        next unless result.include?(name)
        result = result.gsub(/\b#{Regexp.escape(name)}\b/, _expand_macros(value, macros, depth + 1))
      end
      result
    end

    def _expand_macro_line(line, macros, depth = 0)
      return line if depth > 20
      if line.lstrip.start_with?(".")
        parts = line.lstrip[1..].chomp.split(/\s+/, -1)
        name  = parts[0]
        args  = parts[1..] || []
        if macros.key?(name)
          body = macros[name].dup
          args.each_with_index { |arg, i| body = body.gsub("$#{i+1}", arg) }
          return _expand_macro_line(body + "\n", macros, depth + 1)
        end
      end
      line
    end
  end
end
