# Chapter 2 — Filters: compress, squeeze, translit, expand
module SoftwareTools
  module Filters
    # Compress runs of spaces and blank lines
    def compress(text)
      prev_blank = false
      result = []
      text.lines.each do |line|
        line = line.gsub(/ {2,}/, " ")
        is_blank = line.strip.empty?
        if is_blank
          result << "\n" unless prev_blank
        else
          result << line
        end
        prev_blank = is_blank
      end
      result.join
    end

    # Collapse consecutive repeated characters
    def squeeze(text, chars: nil)
      if chars
        pattern = "[#{Regexp.escape(chars)}]"
        text.gsub(/#{pattern}+/) { |m| m[0] }
      else
        text.gsub(/(.)\1+/, '\1')
      end
    end

    # Translate characters (like Unix tr)
    def translit(text, from, to)
      from_chars = expand_range(from).chars
      to_chars   = expand_range(to).chars
      table = {}
      from_chars.each_with_index { |c, i| table[c] = to_chars[i] || to_chars.last }
      text.chars.map { |c| table[c] || c }.join
    end

    # Expand tabs (alias for detab)
    def expand(text, tab_width: 8)
      detab(text, tab_width: tab_width)
    end

    # Replace leading spaces with tabs (entab)
    def entab(text, tab_width: 8)
      text.lines.map do |line|
        leading = line[/^ */].length
        tabs    = leading / tab_width
        spaces  = leading % tab_width
        "\t" * tabs + " " * spaces + line.lstrip
      end.join
    end

    private

    def expand_range(set)
      set.gsub(/(.)-(.)/){ ($1.ord..$2.ord).map(&:chr).join }
    end
  end
end
