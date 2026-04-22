# Working with Files in Bash

## File Test Operators
Use test operators to verify file properties. Always quote variables to handle spaces in filenames.

**Common Operators:**
| Operator | Description                      |
|----------|----------------------------------|
| `-e`     | File exists                      |
| `-f`     | Regular file (not directory)     |
| `-d`     | Directory                        |
| `-s`     | File exists and is not empty     |
| `-r`     | Readable by current user         |
| `-w`     | Writable by current user         |
| `-x`     | Executable by current user       |
| `-L`     | Symbolic link                    |
| `-O`     | Owned by current user            |

**Improved Example:**
```bash
#!/bin/bash
file="example.txt"

if [ -e "$file" ]; then
  echo "File exists"
  if [ -s "$file" ]; then
    echo "File is non-empty"
  fi
else
  echo "File does not exist" >&2
  exit 1
fi
```

## Reading and Writing Files
### Best Practices:
- Use `printf` for more reliable output formatting
- Prefer `$(< file)` for efficient file reading
- Always check write permissions before modifying files

**Enhanced Examples:**
```bash
# Safe write with error checking
if [ -w . ]; then
  printf "%s\n" "Hello World" "Second line" > example.txt
else
  echo "No write permission in current directory" >&2
  exit 1
fi

# Read file into variable (alternative to cat)
content=$(< example.txt)
echo "$content"

# Process file line-by-line
while IFS= read -r line; do
  echo "Processing: $line"
done < example.txt
```

## File Permissions
Understand permission modes:
- Symbolic: `u+r` (user read), `g-w` (group write remove)
- Octal: `755` (rwxr-xr-x), `644` (rw-r--r--)

**Practical Examples:**
```bash
# Set secure permissions
chmod 644 config.txt  # Owner: read/write, Others: read-only

# Make executable and verify
chmod u+x script.sh
[ -x script.sh ] && ./script.sh
```

## Directory Management
**Key Commands:**
- `mkdir -p`: Create nested directories
- `rm -rf`: Remove directories recursively (use with caution)
- `find`: Advanced directory operations

**Improved Examples:**
```bash
# Create nested directory structure
mkdir -p project/{src,dist,test}

# Safe directory removal
dir_to_remove="temp/"
if [ -d "$dir_to_remove" ]; then
  rm -rf "$dir_to_remove"
  echo "Directory removed"
fi
```

## File Handling Best Practices
1. Always quote file path variables
2. Verify operations with `-i` flags (e.g., `rm -i`)
3. Use `mktemp` for temporary files
4. Prefer absolute paths in critical operations

## Enhanced Exercise
Create a script that:
1. Accepts a filename as an argument
2. Checks if it's a regular file and readable
3. Displays contents with line numbers
4. Handles edge cases (missing arguments, special files)

**Improved Solution:**
```bash
#!/bin/bash
# File inspection script

# Verify argument provided
if [ $# -ne 1 ]; then
  echo "Usage: $0 <filename>" >&2
  exit 1
fi

filename="$1"

# Perform safety checks
if [ ! -e "$filename" ]; then
  echo "Error: File '$filename' does not exist" >&2
  exit 2
elif [ ! -f "$filename" ]; then
  echo "Error: '$filename' is not a regular file" >&2
  exit 3
elif [ ! -r "$filename" ]; then
  echo "Error: No read permission for '$filename'" >&2
  exit 4
fi

# Display contents with line numbers
echo "Contents of $filename:"
nl -ba "$filename"
```

##### Copyright (c) 2026 ChipVerge

