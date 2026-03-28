# Chapter 1 — Intro tools: copy, charcount, linecount, wordcount, detab
module SoftwareTools
  module Intro
    # Copy text as-is
    def copy(text)
      text
    end

    # Count characters
    def charcount(text)
      text.length
    end

    # Count lines
    def linecount(text)
      text.lines.count
    end

    # Count words
    def wordcount(text)
      text.split.count
    end

    # All three counts at once
    def wc(text)
      {
        lines: linecount(text),
        words: wordcount(text),
        chars: charcount(text)
      }
    end

    # Replace tabs with spaces
    def detab(text, tab_width: 8)
      text.lines.map do |line|
        col    = 0
        result = ""
        line.each_char do |c|
          if c == "\t"
            spaces = tab_width - (col % tab_width)
            result << " " * spaces
            col += spaces
          else
            result << c
            col += 1 unless c == "\n"
          end
        end
        result
      end.join
    end

    # Number each line
    def number_lines(text)
      text.lines.each_with_index.map { |l, i| "%4d  %s" % [i + 1, l] }.join
    end
  end
end
