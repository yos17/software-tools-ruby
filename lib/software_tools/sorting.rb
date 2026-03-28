# Chapter 4 — Sorting: sort, uniq, merge
module SoftwareTools
  module Sorting
    # Sort lines
    def sort(text, reverse: false, ignore_case: false, numeric: false, unique: false)
      lines = text.lines
      lines.sort_by! do |line|
        key = line.chomp
        key = key.downcase if ignore_case
        key = key.to_f     if numeric
        key
      end
      lines.reverse! if reverse
      lines.uniq!    if unique
      lines.join
    end

    # Remove adjacent duplicate lines (like uniq)
    def uniq(text, count: false)
      lines  = text.lines
      result = []
      prev   = nil
      n      = 0

      lines.each do |line|
        if line == prev
          n += 1
        else
          result << (count ? "%7d %s" % [n, prev] : prev) if prev
          prev = line
          n    = 1
        end
      end
      result << (count ? "%7d %s" % [n, prev] : prev) if prev
      result.join
    end

    # Merge two sorted texts
    def merge(text1, text2)
      lines1 = text1.lines
      lines2 = text2.lines
      result = []
      i = j = 0
      while i < lines1.length && j < lines2.length
        if lines1[i] <= lines2[j]
          result << lines1[i]; i += 1
        else
          result << lines2[j]; j += 1
        end
      end
      result.concat(lines1[i..]).concat(lines2[j..]).join
    end

    # KWIC — rotate each line to put each word first
    def kwic(text)
      text.lines.flat_map do |line|
        words = line.chomp.split
        words.length.times.map { |i| (words[i..] + words[0...i]).join(" ") }
      end.join("\n") + "\n"
    end
  end
end
