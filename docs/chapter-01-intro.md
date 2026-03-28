# Chapter 1 — Introduction: The Unix Way

## What You'll Learn
- How Ruby reads from stdin / files (`ARGF`, `$stdin`, `ARGV`)
- Basic loops: `while`, `each_line`, `each_char`
- String methods: `length`, `split`, `chomp`
- Writing to stdout with `print`, `puts`, `$stdout`
- Running Ruby scripts as Unix tools with pipes

## The Core Idea

A **filter** is a program that:
- Reads from stdin (or files given as arguments)
- Writes to stdout
- Does exactly one transformation

This lets you chain them: `cat file.txt | copy | charcount`

---

## Concept: ARGF

`ARGF` is Ruby's magic object that reads from files listed in `ARGV`, or falls back to stdin if none given. Use it to write tools that work both ways:

```bash
ruby copy.rb file.txt        # reads file
cat file.txt | ruby copy.rb  # reads stdin
```

---

## Tools to Build

### 1. `copy.rb` — copy stdin to stdout

```ruby
ARGF.each_line do |line|
  print line
end
```

That's it. The simplest possible filter.

**Run it:**
```bash
echo "hello world" | ruby copy.rb
ruby copy.rb copy.rb   # copy itself!
```

---

### 2. `charcount.rb` — count characters

```ruby
count = 0
ARGF.each_char { |c| count += 1 }
puts count
```

**Run it:**
```bash
echo "hello" | ruby charcount.rb   # => 6 (includes newline)
ruby charcount.rb charcount.rb     # count chars in the script itself
```

---

### 3. `linecount.rb` — count lines

```ruby
count = 0
ARGF.each_line { |_| count += 1 }
puts count
```

**Run it:**
```bash
cat README.md | ruby linecount.rb
ruby linecount.rb linecount.rb *.rb
```

---

### 4. `wordcount.rb` — count words

```ruby
count = 0
ARGF.each_line do |line|
  count += line.split.length
end
puts count
```

**Run it:**
```bash
echo "one two three" | ruby wordcount.rb   # => 3
```

---

### 5. `detab.rb` — replace tabs with spaces

Tabs are ugly when you don't control the tab width. This replaces each `\t` with N spaces.

```ruby
tab_width = (ARGV.first&.to_i) || 8
# Remove tab_width from ARGV so ARGF doesn't try to open it as a file
ARGV.shift if ARGV.first =~ /^\d+$/

ARGF.each_line do |line|
  col = 0
  line.each_char do |c|
    if c == "\t"
      spaces = tab_width - (col % tab_width)
      print " " * spaces
      col += spaces
    else
      print c
      col += 1
    end
  end
end
```

**Run it:**
```bash
printf "a\tb\tc\n" | ruby detab.rb       # 8-space tabs (default)
printf "a\tb\tc\n" | ruby detab.rb 4     # 4-space tabs
```

---

## Exercises

1. **wc clone**: combine charcount + linecount + wordcount into one `wc.rb` that prints all three
2. **entab**: reverse of detab — replace N spaces at the start of a line with a tab
3. **Modify detab** to accept multiple files: `ruby detab.rb 4 file1.txt file2.txt`
4. **Print line numbers**: write `number.rb` that prepends each line with its line number
5. **Reverse lines**: write `tac.rb` (reverse of `cat`) — print lines in reverse order

## Key Ruby Methods Learned
| Method | What it does |
|--------|-------------|
| `ARGF.each_line` | iterate over lines from files/stdin |
| `ARGF.each_char` | iterate over individual characters |
| `line.split` | split on whitespace, returns array |
| `line.chomp` | remove trailing newline |
| `line.length` | string length |
| `print` vs `puts` | print = no newline, puts = adds newline |
| `ARGV` | array of command-line arguments |
