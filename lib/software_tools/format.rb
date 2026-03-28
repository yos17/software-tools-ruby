# Chapter 7 — Format: word wrap, justify, center
module SoftwareTools
  module Format
    # Word-wrap text at width columns
    def fmt(text, width: 72)
      result = []
      buffer = []

      flush = ->(words) {
        return if words.empty?
        line = ""
        words.each do |word|
          if line.empty?
            line = word
          elsif line.length + 1 + word.length <= width
            line += " " + word
          else
            result << line + "\n"
            line = word
          end
        end
        result << line + "\n" unless line.empty?
        result << "\n"
      }

      text.lines.each do |raw|
        if raw.strip.empty?
          flush.call(buffer)
          buffer = []
        else
          buffer += raw.split
        end
      end
      flush.call(buffer)
      result.join
    end

    # Full justification
    def justify(text, width: 72)
      fmt(text, width: width).lines.each_with_object([]) do |line, res|
        words = line.chomp.split
        if words.length <= 1 || line.strip.empty?
          res << line
        else
          gaps       = words.length - 1
          total_sp   = width - words.map(&:length).sum
          base       = total_sp / gaps
          extra      = total_sp % gaps
          out = words[0]
          words[1..].each_with_index { |w, i| out += " " * (base + (i < extra ? 1 : 0)) + w }
          res << out + "\n"
        end
      end.join
    end

    # Center each line within width
    def center(text, width: 72)
      text.lines.map do |line|
        stripped = line.chomp
        pad = [(width - stripped.length) / 2, 0].max
        " " * pad + stripped + "\n"
      end.join
    end

    # Fold long lines at width
    def fold(text, width: 80)
      text.lines.flat_map do |line|
        line.chomp.scan(/.{1,#{width}}/).map { |chunk| chunk + "\n" }
      end.join
    end
  end
end
