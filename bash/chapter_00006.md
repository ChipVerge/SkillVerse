# Advanced Scripting Techniques

## Regular Expressions (RegEx)
Regular expressions are pattern-matching tools using special syntax to identify text patterns. They're essential for search, validation, and text transformations. Common in tools like `grep`, `sed`, and `awk`.

**Key Concepts**:
- `^` = Start of line, `$` = End of line
- `[0-9]` = Digit, `+` = One or more occurrences
- `\d` = Digit (Perl-style, use `grep -P` where supported)
- `.*` = Any character (wildcard)

**Examples**:
```bash
# Find lines containing digits (extended regex)
echo "Hello 123" | grep -E '[0-9]+'

# Validate email format (simplified)
echo "test@domain.com" | grep -E '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'
```


## Sed: Stream Editor
A line-oriented text processor for substitutions, deletions, and transformations.

**Common Flags**:
- `s/pattern/replacement/` = Substitute first match per line
- `/g` = Global replacement (all matches in line)
- `-i` = In-place file modification (caution advised)

**Examples**:
```bash
# Basic substitution
echo "Hello World" | sed 's/World/Linux/'

# Replace all digits with 'X'
echo "User123" | sed 's/[0-9]/X/g'

# Delete lines containing 'error' (case insensitive)
sed '/error/Id' logfile.txt
```


## Awk: Column-Based Processing
A versatile programming language for structured text parsing, ideal for columnar data.

**Key Features**:
- `$1`, `$2` = First/second column fields
- `NF` = Number of fields, `NR` = Current record number
- Built-in math functions and variables

**Examples**:
```bash
# Sum values in the first column
echo -e "5 apple\n3 banana\n2 cherry" | awk '{sum += $1} END {print sum}'  # Output: 10

# Print lines where column 2 > 100
awk '$2 > 100 {print $1, $3}' data.csv

# Calculate average of second field
awk '{total += $2; count++} END {print "Avg:", total/count}' numbers.txt
```


## Process Substitution
Treat command outputs as temporary files for programs requiring file arguments.

**Syntax**: `<(command)` or `>(command)`

**Examples**:
```bash
# Compare directory listings
diff <(ls dir1) <(ls dir2)

# Merge sorted outputs
sort -m <(sort file1) <(sort file2) > combined_sorted.txt
```


## Command Substitution
Embed command output into variables or other commands.

**Best Practices**:
- Prefer `$(...)` over backticks `` `...` `` for readability and nesting
- Use quotes to preserve whitespace: `"$(...)"`

**Examples**:
```bash
# Store date in variable
current_date=$(date +%F)
echo "Today: $current_date"

# Inline usage in strings
echo "System has $(df -h / | awk 'NR==2 {print $4}') free space in root."
```


## Exercise: Sum Numbers in a File
Create a script using `awk` to sum numbers from a file with one number per line.

**Enhanced Solution**:
```bash
#!/bin/bash
# Calculates sum of numbers with basic error checking

file="numbers.txt"

# Verify file exists and is readable
if [[ ! -f "$file" || ! -r "$file" ]]; then
  echo "Error: Cannot read $file" >&2
  exit 1
fi

# Calculate sum, handle empty files
sum=$(awk '{sum += $1} END {printf sum}' "$file" 2>/dev/null)

# Validate numeric result
if [[ -n "$sum" ]]; then
  echo "Sum of numbers in $file: $sum"
else
  echo "No valid numbers found or empty file"
fi
```

##### Copyright (c) 2026 ChipVerge

