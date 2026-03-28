require_relative "../lib/software_tools"

# Minimal test suite (no rspec needed — plain Ruby assertions)
T = SoftwareTools

def assert(desc, got, expected)
  if got == expected
    puts "  ✅ #{desc}"
  else
    puts "  ❌ #{desc}"
    puts "     expected: #{expected.inspect}"
    puts "     got:      #{got.inspect}"
    $failures = ($failures || 0) + 1
  end
end

puts "\n=== Chapter 1: Intro ==="
assert "copy",       T.copy("hello"),          "hello"
assert "charcount",  T.charcount("hello"),     5
assert "linecount",  T.linecount("a\nb\nc\n"), 3
assert "wordcount",  T.wordcount("one two 3"), 3
assert "wc",         T.wc("hello\nworld\n"),   { lines: 2, words: 2, chars: 12 }
assert "detab",      T.detab("a\tb", tab_width: 4), "a   b"

puts "\n=== Chapter 2: Filters ==="
assert "compress spaces",  T.compress("a  b   c"),        "a b c"
assert "squeeze",          T.squeeze("aaabbbccc"),         "abc"
assert "translit upper",   T.translit("hello", "a-z", "A-Z"), "HELLO"
assert "translit vowels",  T.translit("hello", "aeiou", "*"), "h*ll*"

puts "\n=== Chapter 3: FileIO ==="
assert "head",    T.head("a\nb\nc\nd\ne\n", n: 3), "a\nb\nc\n"
assert "tail",    T.tail("a\nb\nc\nd\ne\n", n: 2), "d\ne\n"
assert "compare same",  T.compare("a\nb\n", "a\nb\n"), nil
assert "compare diff",  T.compare("a\nb\n", "a\nX\n")[:line], 2

puts "\n=== Chapter 4: Sorting ==="
assert "sort asc",     T.sort("banana\napple\ncherry\n"),           "apple\nbanana\ncherry\n"
assert "sort desc",    T.sort("banana\napple\ncherry\n", reverse: true), "cherry\nbanana\napple\n"
assert "sort numeric", T.sort("10\n3\n25\n1\n", numeric: true),    "1\n3\n10\n25\n"
assert "uniq",         T.uniq("a\na\nb\nb\nb\nc\n"),               "a\nb\nc\n"

puts "\n=== Chapter 5: Find ==="
assert "grep match",  T.grep("hello", "hello\nworld\nhello world\n"), "hello\nhello world\n"
assert "grep invert", T.grep("hello", "hello\nworld\n", invert: true), "world\n"
assert "grep icase",  T.grep("HELLO", "hello\nworld\n", ignore_case: true), "hello\n"

puts "\n=== Chapter 6: Change ==="
assert "change all",   T.change("hello world world", "world", "Ruby"), "hello Ruby Ruby"
assert "change first", T.change("hello world world", "world", "Ruby", global: false), "hello Ruby world"
assert "delete lines", T.delete_lines("# comment\ncode\n# comment2\n", /^#/), "code\n"

puts "\n=== Chapter 7: Format ==="
wrapped = T.fmt("one two three four five six seven eight nine ten\n", width: 20)
assert "fmt wraps",    wrapped.lines.all? { |l| l.chomp.length <= 20 }, true
assert "center",       T.center("hi\n", width: 10).chomp, "    hi"

puts "\n=== Chapter 8: Macros ==="
text = "#define NAME Yosia\nHello NAME!\n"
assert "define macro", T.define(text), "Hello Yosia!\n"

macro_text = ".define greet Hello, $1!\n.greet Yosia\n"
assert "macro args",   T.macro(macro_text), "Hello, Yosia!\n"

puts "\n=== Pipeline ==="
result = SoftwareTools.pipe("banana\napple\ncherry\napple\n")
  .sort
  .uniq
  .result
assert "pipeline sort+uniq", result, "apple\nbanana\ncherry\n"

result2 = SoftwareTools.pipe("hello world\ngoodbye world\nhello ruby\n")
  .grep("hello")
  .change("hello", "HI")
  .result
assert "pipeline grep+change", result2, "HI world\nHI ruby\n"

puts ""
if $failures.to_i > 0
  puts "❌ #{$failures} test(s) failed"
  exit 1
else
  puts "✅ All tests passed!"
end
