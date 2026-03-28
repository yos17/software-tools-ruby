# Chapter 3 — File I/O: compare, concat, head, tail, include
module SoftwareTools
  module FileIO
    # Compare two strings line by line, return first diff or nil
    def compare(text1, text2)
      lines1 = text1.lines
      lines2 = text2.lines
      [lines1.length, lines2.length].max.times do |i|
        l1 = lines1[i]
        l2 = lines2[i]
        return { line: i + 1, a: l1&.chomp, b: l2&.chomp } if l1 != l2
      end
      nil
    end

    # Concatenate multiple strings
    def concat(*texts)
      texts.join
    end

    # First N lines
    def head(text, n: 10)
      text.lines.first(n).join
    end

    # Last N lines
    def tail(text, n: 10)
      text.lines.last(n).join
    end

    # Expand #include directives in text
    def include_files(text, base_dir: ".", depth: 0)
      return text if depth > 10
      text.lines.map do |line|
        if line =~ /^#include\s+"?([^\s"]+)"?/
          path = File.join(base_dir, $1)
          File.exist?(path) ? include_files(File.read(path), base_dir: base_dir, depth: depth + 1) : line
        else
          line
        end
      end.join
    end
  end
end
