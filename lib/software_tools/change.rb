# Chapter 6 — Change: substitute, sed-like processing
module SoftwareTools
  module Change
    # Substitute pattern with replacement (global by default)
    def change(text, pattern, replacement, global: true)
      regex = pattern.is_a?(Regexp) ? pattern : Regexp.new(pattern)
      text.lines.map do |line|
        global ? line.gsub(regex, replacement) : line.sub(regex, replacement)
      end.join
    end

    # Delete lines matching pattern
    def delete_lines(text, pattern)
      regex = pattern.is_a?(Regexp) ? pattern : Regexp.new(pattern)
      text.lines.reject { |l| l =~ regex }.join
    end

    # Keep only lines matching pattern
    def keep_lines(text, pattern)
      grep(pattern, text)
    end

    # Insert a line after every line matching pattern
    def insert_after(text, pattern, new_line)
      regex = pattern.is_a?(Regexp) ? pattern : Regexp.new(pattern)
      text.lines.flat_map do |line|
        (line =~ regex) ? [line, new_line.end_with?("\n") ? new_line : new_line + "\n"] : [line]
      end.join
    end

    # Apply multiple sed-style commands: [[:sub, /pat/, repl, global], [:delete, /pat/], ...]
    def sed(text, *commands)
      lines  = text.lines
      result = []
      lines.each do |line|
        deleted = false
        commands.each do |cmd|
          case cmd[0]
          when :sub
            _, pat, repl, global = cmd
            line = global ? line.gsub(pat, repl) : line.sub(pat, repl)
          when :delete
            deleted = true if line =~ cmd[1]
          end
          break if deleted
        end
        result << line unless deleted
      end
      result.join
    end
  end
end
