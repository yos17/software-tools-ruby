# software-tools-ruby

Unix text processing tools built in Ruby — inspired by *Software Tools in Pascal* by Kernighan & Plauger (1981).

Each tool works **three ways**:
1. As a **CLI command**: `st-grep "error" file.txt`
2. As a **library**: `SoftwareTools.grep("error", text)`
3. As a **chainable pipeline**: `Tools.pipe(text).grep("error").sort.uniq.result`

---

## Install

```bash
gem install software-tools-ruby   # once published
# or locally:
git clone https://github.com/yos17/software-tools-ruby
cd software-tools-ruby
gem build software_tools.gemspec
gem install software-tools-ruby-0.1.0.gem
```

## CLI Usage

```bash
# Word count
st-wc file.txt

# Search (grep)
st-grep "error" log.txt
st-grep -i -n "warning" *.log

# Sort
st-sort -r -n numbers.txt

# Sort + deduplicate
cat words.txt | st-sort | st-uniq

# Substitute
echo "hello world" | st-change world Ruby

# Word wrap at 60 columns
cat essay.txt | st-fmt 60

# Translate characters (like tr)
echo "hello world" | st-translit 'a-z' 'A-Z'

# Process macros
st-macro template.txt
```

## Library Usage

```ruby
require 'software_tools'

# Individual functions
SoftwareTools.wc("hello world\n")
# => { lines: 1, words: 2, chars: 12 }

SoftwareTools.grep("error", log_text, ignore_case: true)
SoftwareTools.sort(text, reverse: true, unique: true)
SoftwareTools.change(text, /foo/, "bar")
SoftwareTools.fmt(text, width: 72)
SoftwareTools.translit(text, "a-z", "A-Z")

# Macro processing
SoftwareTools.define("#define NAME Yosia\nHello NAME!\n")
# => "Hello Yosia!\n"
```

## Chainable Pipeline

```ruby
require 'software_tools'

result = SoftwareTools.pipe(text)
  .grep("error")
  .sort
  .uniq
  .result

# Or use the Tools alias
Tools.pipe(text)
  .grep("def ", ignore_case: true)
  .change(/def (\w+)/, 'METHOD: \1')
  .fmt(width: 60)
  .print_result
```

## Tools Reference

| CLI | Library | Description |
|-----|---------|-------------|
| `st-copy` | `copy(text)` | Copy stdin to stdout |
| `st-wc` | `wc(text)` | Count lines/words/chars |
| `st-grep [-i] [-v] [-n]` | `grep(pat, text)` | Find matching lines |
| `st-sort [-r] [-i] [-n] [-u]` | `sort(text)` | Sort lines |
| `st-uniq [-c]` | `uniq(text)` | Remove duplicate lines |
| `st-change [-1] pat repl` | `change(text, pat, repl)` | Substitute pattern |
| `st-fmt [width]` | `fmt(text, width:)` | Word-wrap paragraphs |
| `st-translit from to` | `translit(text, from, to)` | Translate characters |
| `st-macro` | `macro(text)` | Process .define macros |

## Chapters (learning path)

The gem is organized as a course:

```
lib/software_tools/
  intro.rb     # Ch1: copy, wc, detab
  filters.rb   # Ch2: compress, squeeze, translit
  fileio.rb    # Ch3: compare, head, tail, include
  sorting.rb   # Ch4: sort, uniq, merge, kwic
  find.rb      # Ch5: grep, amatch (hand-built regex engine)
  change.rb    # Ch6: change, delete_lines, sed
  format.rb    # Ch7: fmt, justify, center, fold
  macros.rb    # Ch8: define, macro, template (ERB)
  pipeline.rb  # Chainable DSL
```

## Run tests

```bash
ruby spec/software_tools_spec.rb
```

---

Inspired by: *Software Tools in Pascal*, Kernighan & Plauger, 1981.
