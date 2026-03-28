# Chapter 5 — Find: grep, amatch
module SoftwareTools
  module Find
    # Find lines matching pattern (grep)
    def grep(pattern, text, ignore_case: false, invert: false, line_numbers: false)
      flags = ignore_case ? Regexp::IGNORECASE : 0
      regex = pattern.is_a?(Regexp) ? pattern : Regexp.new(pattern, flags)
      lines = text.lines
      result = []
      lines.each_with_index do |line, i|
        matched = line =~ regex
        matched = !matched if invert
        if matched
          prefix = line_numbers ? "#{i+1}:" : ""
          result << "#{prefix}#{line}"
        end
      end
      result.join
    end

    # Count matching lines
    def grep_count(pattern, text, ignore_case: false)
      grep(pattern, text, ignore_case: ignore_case).lines.count
    end

    # Simple pattern match (hand-built engine: . * ^ $)
    def amatch(pattern, text)
      text.lines.select { |line| _amatch(pattern, line.chomp) }.join
    end

    private

    def _amatch(pattern, text)
      return _match_here(pattern, 1, text, 0) if pattern[0] == '^'
      (0..text.length).any? { |i| _match_here(pattern, 0, text, i) }
    end

    def _match_here(pat, pi, txt, ti)
      return true if pi >= pat.length
      return ti >= txt.length if pat[pi] == '$' && pi == pat.length - 1
      if pi + 1 < pat.length && pat[pi + 1] == '*'
        return _match_star(pat, pi, txt, ti)
      end
      return false if ti >= txt.length
      return false unless pat[pi] == '.' || pat[pi] == txt[ti]
      _match_here(pat, pi + 1, txt, ti + 1)
    end

    def _match_star(pat, pi, txt, ti)
      loop do
        return true if _match_here(pat, pi + 2, txt, ti)
        break if ti >= txt.length || !(pat[pi] == '.' || pat[pi] == txt[ti])
        ti += 1
      end
      false
    end
  end
end
