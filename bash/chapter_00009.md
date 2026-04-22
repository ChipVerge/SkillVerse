# Best Practices for Shell Scripting

## Writing Readable Code

Writing readable code is crucial for maintainability and collaboration.  Well-structured code is easier to understand, debug, and modify, especially in the long run or when others need to work with your scripts.

### Use Meaningful Variable Names

Choose variable names that clearly indicate the purpose and content of the variable.  Avoid single-letter or cryptic names.  Descriptive names make your code self-documenting.

**Example:**

```bash
#!/bin/bash
# Bad - unclear what 'a' represents
a=10

# Good - 'file_count' clearly indicates the variable's purpose
file_count=10

# Even Better - more context in a script snippet
#!/bin/bash
# Script to process log files

# Bad - 'f' and 'i' are not descriptive
f=$(ls *.log | wc -l)
for i in $(seq 1 $f); do
  echo "Processing log file $i"
done

# Good - 'log_file_count' and 'log_index' are much clearer
log_file_count=$(ls *.log | wc -l)
for log_index in $(seq 1 $log_file_count); do
  echo "Processing log file $log_index"
done
```

### Use Indentation and Consistent Spacing

Indent your code blocks (like loops, conditionals, and functions) to visually represent the code's structure and control flow. Consistent indentation and spacing significantly improve readability, making it easier to follow the logic.  Generally, two or four spaces are preferred for indentation.  Avoid tabs, as their display can vary across editors.

**Example:**

```bash
#!/bin/bash
# Less Readable - difficult to see the structure
if [ -d "$directory" ]; then if [ "$(ls -A "$directory")" ]; then echo "Directory is not empty"; else echo "Directory is empty"; fi; else echo "Directory does not exist"; fi

# More Readable - indentation clearly shows nested structure
if [ -d "$directory" ]; then
  if [ "$(ls -A "$directory")" ]; then
    echo "Directory is not empty"
  else
    echo "Directory is empty"
  fi
else
  echo "Directory does not exist"
fi
```

## Commenting and Documentation

Comments are essential for explaining what your code does, especially for complex logic or scripts intended for reuse.  Good comments explain the *why* and the *how* of your code, not just the *what* which should be evident from the code itself.  For longer scripts, consider adding a header comment block outlining the script's purpose, author, and date.

**Example:**

```bash
#!/bin/bash
# Script Name: count_files.sh
# Description: This script counts the number of files in a specified directory.
# Author: Gemini
# Date: 2025-02-21

# --- Configuration ---
directory="/path/to/directory" # Set the target directory for file counting

# --- Main Script Logic ---
# Count files using ls and wc -l.
#   - ls lists files in the directory
#   - wc -l counts the number of lines (which corresponds to files in this case)
file_count=$(ls "$directory" | wc -l)

# Output the result to the console
echo "Number of files in $directory: $file_count"
```

## Script Optimization

Optimizing your scripts is important for efficiency, especially when dealing with large datasets or frequent execution. Optimization can reduce script runtime and resource consumption.

### Avoid Unnecessary Commands and Operations

Eliminate commands and operations that don't contribute to the script's functionality.  Piping data through multiple commands when a single command can achieve the same result is inefficient.

**Example:**

```bash
#!/bin/bash
# Bad - 'cat' is unnecessary here
count=$(cat file.txt | grep "error" | wc -l)

# Good - 'grep' can directly read from the file
count=$(grep -c "error" file.txt) # -c option counts matching lines
```

### Use Built-in Commands and Features

Bash built-in commands are generally faster than external commands because they are executed directly by the shell without forking a new process.  Utilize shell built-ins and features like parameter expansion and built-in commands whenever possible.

**Example:**

```bash
#!/bin/bash
# Bad - 'cut' is an external command
filename="my_report_2025-02-21.txt"
date=$(cut -d'_' -f3 <<< "$filename" | cut -d'.' -f1)
echo "Date: $date"

# Good - Parameter expansion is a built-in shell feature
filename="my_report_2025-02-21.txt"
date="${filename##*_}"  # Remove longest prefix up to last '_'
date="${date%.*}"       # Remove shortest suffix starting from '.'
echo "Date: $date"
```

### Efficient Looping and File Processing

Optimize loops for faster execution, especially when processing files.  Globbing is often more efficient than using `ls` in loops.  For file processing, consider using tools like `awk` or `sed` for efficient text manipulation.

**Example:**

```bash
#!/bin/bash
# Inefficient - using 'ls' in a loop and unnecessary 'cat'
for file in $(ls *.txt); do
  cat "$file" | grep "keyword"
done

# More Efficient - globbing and direct grep on files
for file in *.txt; do
  grep "keyword" "$file"
done

# Even More Efficient - using awk for file processing (complex example)
awk '/keyword/ {print FILENAME, $0}' *.txt
```

## Error Handling

Robust scripts should include error handling to manage unexpected situations gracefully.  Use `set -e` to exit immediately if a command fails, and check command exit codes to handle errors explicitly.

**Example:**

```bash
#!/bin/bash
set -e # Exit immediately if a command exits with a non-zero status

# Attempt to create a directory
mkdir my_directory

# Check if directory creation was successful (though set -e would already exit on failure)
if [ $? -eq 0 ]; then
  echo "Directory created successfully"
else
  echo "Error creating directory"
  exit 1 # Explicitly exit with an error code
fi

# Script continues only if mkdir was successful
echo "Script continuing..."
```

## Input Validation

Always validate user input to prevent unexpected behavior and security vulnerabilities.  Check for the correct number of arguments, validate argument types, and handle missing or invalid input gracefully.

**Example:**

```bash
#!/bin/bash

# Check for the correct number of arguments
if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <directory_path>"
  exit 1
fi

directory="$1" # Get directory path from the first argument

# Check if the directory exists and is a directory
if [ ! -d "$directory" ]; then
  echo "Error: '$directory' is not a valid directory"
  exit 1
fi

# Script continues only if input is valid
echo "Counting files in directory: $directory"
file_count=$(ls "$directory" | wc -l)
echo "Number of files: $file_count"
```

## Use Functions for Reusability

Organize your code into functions to promote modularity and reusability. Functions make scripts easier to read, test, and maintain.  They also avoid code duplication.

**Example:**

```bash
#!/bin/bash

# Function to count files in a directory
count_files() {
  local dir="$1" # Local variable for directory path
  if [ ! -d "$dir" ]; then
    echo "Error: '$dir' is not a valid directory"
    return 1 # Indicate function failure
  fi
  local count=$(ls "$dir" | wc -l)
  echo "Number of files in $dir: $count"
  return 0 # Indicate function success
}

# --- Main Script ---
directory="/path/to/your/directory"

if count_files "$directory"; then # Call the function and check for success
  echo "File count completed successfully."
else
  echo "File count failed."
fi
```

## Always Quote Variables

Always quote your variables (e.g., `"$variable"`) to prevent word splitting and pathname expansion issues. This is especially important when dealing with filenames or strings that contain spaces or special characters.

**Example:**

```bash
#!/bin/bash
file_name="my file with spaces.txt"

# Bad - without quotes, word splitting occurs if file_name has spaces
ls $file_name # Might cause error or unexpected behavior

# Good - with quotes, the variable is treated as a single argument
ls "$file_name" # Correctly handles filenames with spaces
```

## Include `set -euxo pipefail`

Start your scripts with `set -euxo pipefail`. This command enhances script robustness and helps in debugging:

*   `set -e` or `set -o errexit`:  Exit immediately if a command exits with a non-zero status (indicating failure).
*   `set -u` or `set -o nounset`:  Treat unset variables as an error and exit. This helps catch typos and uninitialized variables.
*   `set -x` or `set -o xtrace`:  Print each command before executing it. Useful for debugging.
*   `set -o pipefail`:  Make the script exit if any command in a pipeline fails, not just the last one.

**Example:**

```bash
#!/bin/bash
set -euxo pipefail

# Your script commands follow
mkdir my_directory
cd my_directory
touch test_file.txt
```

## Exercise

Create a script that takes a directory path as an argument, counts the number of files in that directory, and prints the result.  The script should include:

*   Meaningful variable names
*   Proper indentation
*   Comments explaining the code
*   Input validation to ensure the argument is a valid directory
*   Error handling using `set -e` and exit codes
*   Use of a function to encapsulate the file counting logic

**Example Solution:**

```bash
#!/bin/bash
set -euxo pipefail

# Script Name: count_files_robust.sh
# Description: Counts files in a directory provided as an argument.
# Author: Gemini
# Date: 2025-02-21

# Function to count files in a directory
count_files() {
  local dir_path="$1" # Directory path passed as argument to function

  # Check if the directory exists
  if [ ! -d "$dir_path" ]; then
    echo "Error: '$dir_path' is not a valid directory."
    return 1 # Function returns failure status
  fi

  local file_count=$(ls -A "$dir_path" | wc -l) # Count files, excluding . and ..
  echo "Number of files in '$dir_path': $file_count"
  return 0 # Function returns success status
}

# --- Main Script Logic ---

# Check for the correct number of arguments
if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <directory_path>"
  exit 1 # Exit script with error if argument is missing
fi

directory="$1" # Get directory path from the first argument

if count_files "$directory"; then # Call function and check its exit status
  echo "File counting script completed."
else
  echo "File counting script failed."
  exit 1 # Exit script with error if function failed
fi
```

##### Copyright (c) 2026 ChipVerge

