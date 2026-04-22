# Control Structures: Adding Logic and Automation to Your Scripts

## **Conditional Statements: Making Smart Decisions in Your Scripts**

Conditional statements are the brain of your scripts, enabling them to react intelligently to different situations. They are fundamental for error handling, input validation, and creating scripts that can adapt to varying conditions.

### **`if`, `elif`, `else`: Branching Logic**

The `if` statement is the cornerstone of conditional logic in Bash. It allows your script to execute different blocks of code based on whether a condition is true or false.  You can extend `if` with `elif` (else if) to check multiple conditions and `else` to provide a default action.

**Syntax Deep Dive**:

```bash
if [ condition ]; then  #  '[' is actually a command! Spaces are required around brackets.
  # Code to execute if the first condition is TRUE
elif [ another condition ]; then # Optional 'else if' - check another condition if the first one was false
  # Code to execute if the 'elif' condition is TRUE
else # Optional 'else' - default action if no conditions were true
  # Code to execute if ALL conditions above were FALSE
fi #  'fi' marks the end of the 'if' block - essential!
```

**Important: Spaces around brackets `[ condition ]`**:  In Bash, `[` is not just syntax; it's actually a command (an alias for `test`). Therefore, you *must* have spaces between the brackets and the condition.  For example, `[ -f "$file" ]` is correct, while `[-f "$file"]` will cause a syntax error.

**Real-World Example**:  Checking for a configuration file and handling different scenarios:

```bash
#!/bin/bash
set -e # Exit on error

config_file="/etc/myapp/config.conf" # Path to the main configuration file
backup_dir="/etc/myapp/backups"     # Path to the backup directory

if [ -f "$config_file" ]; then  # '-f' file test operator: Checks if the file exists AND is a regular file
  echo "Configuration file found at '$config_file'. Starting service..."
  ./start_service.sh # Assume 'start_service.sh' is in the same directory or PATH
elif [ -d "$backup_dir" ]; then # '-d' file test operator: Checks if the directory exists
  echo "Main configuration missing! Checking for backups in '$backup_dir'..."
  backup_config="$backup_dir/config.conf.backup" # Assume backup config filename
  if [ -f "$backup_config" ]; then
    echo "Backup configuration found. Restoring from backup..."
    cp "$backup_config" "$config_file" # Copy backup to main config location
    ./start_service.sh # Try starting service again with restored config
  else
    echo "No backup configuration found either!" >&2 # Output error to standard error (stderr)
    echo "Critical error: Cannot start service without configuration." >&2
    exit 1 # Exit script with an error code (non-zero)
  fi
else # 'else' block: Executed if neither the config file nor backup directory exists
  echo "Critical error: No configuration file or backups directory found!" >&2 # Output critical error to stderr
  exit 1 # Exit script with an error code
fi

echo "Service startup process completed (script continuing)." # Script continues only if it reaches this point without exiting
exit 0 # Exit script with success code (zero)
```

**Key Condition Operators for `[ ... ]` and `[[ ... ]]`**:

*   **Numeric Comparisons**:
    *   `-eq`:  Equal to (e.g., `[ "$count" -eq "10" ]`)
    *   `-ne`:  Not equal to (e.g., `[ "$status" -ne "0" ]`)
    *   `-gt`:  Greater than (e.g., `[ "$age" -gt "18" ]`)
    *   `-lt`:  Less than (e.g., `[ "$score" -lt "60" ]`)
    *   `-ge`:  Greater than or equal to (e.g., `[ "$version" -ge "2.0" ]`)
    *   `-le`:  Less than or equal to (e.g., `[ "$limit" -le "100" ]`)

*   **File Test Operators**:
    *   `-f`:  File exists and is a regular file (e.g., `[ -f "$file_path" ]`)
    *   `-d`:  Directory exists (e.g., `[ -d "$dir_path" ]`)
    *   `-e`:  File or directory exists (e.g., `[ -e "$path" ]`)
    *   `-s`:  File exists and is not empty (e.g., `[ -s "$log_file" ]`)
    *   `-r`:  File is readable (e.g., `[ -r "$file" ]`)
    *   `-w`:  File is writable (e.g., `[ -w "$file" ]`)
    *   `-x`:  File is executable (e.g., `[ -x "$script" ]`)

*   **String Comparisons**:
    *   `=` or `==`:  String equality (e.g., `[ "$string1" = "$string2" ]` or `[[ "$string1" == "$string2" ]]`)
    *   `!=`:  String inequality (e.g., `[ "$string1" != "$string3" ]` or `[[ "$string1" != "$string3" ]]`)
    *   `-z`:  String is empty (zero length) (e.g., `[ -z "$empty_var" ]`)
    *   `-n`:  String is not empty (non-zero length) (e.g., `[ -n "$non_empty_var" ]`)
    *   `<`:  Less than (lexicographical order) - **Use with `[[ ... ]]` for strings** (e.g., `[[ "$str1" < "$str2" ]]`)
    *   `>`:  Greater than (lexicographical order) - **Use with `[[ ... ]]` for strings** (e.g., `[[ "$str1" > "$str2" ]]`)

## **Loops: Automating Repetitive Tasks with Ease**

Loops are essential for automating tasks that need to be repeated multiple times. Bash provides several loop constructs to handle different types of iteration.

### **`for` Loop: Iterating Over Lists of Items**

The `for` loop is designed to iterate over a predefined list of items. This list can be explicitly defined, generated using brace expansion, or obtained from command output.

**Use Cases**: Processing multiple files, iterating through a list of servers, performing actions for each item in a collection.

**Enhanced Example**:  Renaming all `.txt` files in a directory to `.bak` and providing more informative output:

```bash
#!/bin/bash
set -e # Exit on error

# Check if there are any .txt files in the current directory
if ! shopt -s nullglob; files=(*.txt); shopt -u nullglob; then # Safely handle cases with no .txt files using globbing and shell options
  echo "No .txt files found in the current directory."
  exit 0 # Exit gracefully if no files to process
fi

echo "Renaming .txt files to .bak in the current directory:"

for file in *.txt; do # Iterate over all files matching the pattern '*.txt' (globbing)
  if [ -f "$file" ]; then # Double-check if it's a regular file (safety measure)
    new_name="${file%.txt}.bak" # Parameter expansion: Remove '.txt' suffix and add '.bak'
    mv "$file" "$new_name" # Rename the file
    echo "  Renamed: '$file'  -->  '$new_name'" # Provide clear output of the renaming action
  else
    echo "Warning: '$file' is not a regular file, skipping." # Handle cases where globbing might match directories or other non-files (unlikely with '*.txt' but good practice)
  fi
done

echo "File renaming process completed."
exit 0 # Exit with success
```

**Brace Expansion for Number Sequences**: A handy shortcut for generating sequences of numbers or characters directly within a `for` loop.

```bash
#!/bin/bash
set -e # Exit on error

echo "Processing items from 1 to 5:"

for i in {1..5}; do  # Brace expansion: Generates the sequence 1 2 3 4 5
  echo "  Processing item number: $i"
done

echo "Processing items from 10 to 20, stepping by 2:"

for j in {10..20..2}; do # Brace expansion with increment: 10 12 14 16 18 20
  echo "  Processing even item: $j"
done

echo "Processing letters from a to e:"

for letter in {a..e}; do # Brace expansion for characters: a b c d e
  echo "  Processing letter: $letter"
done

echo "Loop examples completed."
exit 0 # Exit with success
```

### **`while` Loop: Repeating Actions Based on a Condition**

The `while` loop continues to execute a block of code *as long as* a specified condition remains true. It's ideal for situations where you don't know in advance how many iterations are needed.

**Use Cases**: Reading data from a file line by line, continuously monitoring system resources, waiting for a specific event to occur.

**Real-World Example**: Monitoring memory usage and triggering an alert when it exceeds a threshold:

```bash
#!/bin/bash
set -e # Exit on error

threshold=90 # Memory usage threshold in percentage

echo "Monitoring memory usage. Alert threshold: $threshold%..."

while true; do # 'true' is always true, creating an infinite loop (until explicitly broken)
  usage=$(free | awk '/Mem/{printf "%.0f", $3/$2*100}') # Calculate memory usage percentage using 'free' and 'awk'
  echo "Current memory usage: $usage%" # Display current memory usage

  if [ "$usage" -ge "$threshold" ]; then # Check if usage is greater than or equal to the threshold
    echo "ALERT! Memory usage is over $threshold% ($usage%)!" >&2 # Output alert message to stderr
    # Add actions to take when memory is high, e.g., send email, restart service, etc.
    exit 1 # Exit script with an error code, indicating a problem
  fi

  sleep 5 # Wait for 5 seconds before checking again - prevent excessive CPU usage
done # Loop continues indefinitely until the condition inside the 'if' is met and the script exits
```

**Important: Loop Termination**:  When using `while true`, ensure there is a mechanism within the loop to eventually break out of it (e.g., using `break` statement based on a condition, or `exit` to terminate the script).  Otherwise, you'll create an **infinite loop** that runs forever, potentially consuming system resources. In the example above, the `exit 1` statement inside the `if` condition serves as the termination mechanism when memory usage gets too high.

### **`until` Loop:  Repeating Actions Until a Condition Becomes True**

The `until` loop is the inverse of the `while` loop. It executes a block of code *until* a specified condition becomes true.  It's useful for waiting for a service to start, retrying operations until they succeed, or polling for a specific state.

**Real-World Example**:  Waiting for a web server to become responsive before proceeding:

```bash
#!/bin/bash
set -e # Exit on error

server_url="http://localhost:8080/healthcheck" # URL to check for server health

echo "Waiting for server at '$server_url' to become available..."

until curl -s "$server_url" > /dev/null 2>&1; do # 'until' loop: Continues until the command succeeds (exit code 0)
  # 'curl -s "$server_url"' attempts to access the URL silently (-s)
  # '> /dev/null 2>&1' redirects both standard output and standard error to /dev/null (discarding output)
  echo "Server not yet ready. Waiting..."
  sleep 10 # Wait for 10 seconds before retrying
done # Loop continues until 'curl' command succeeds (server is up and responding)

echo "Server is up and responding at '$server_url'!" # Executed once the 'until' loop terminates (server is ready)
# Proceed with actions that require the server to be running
echo "Continuing with script execution..."

exit 0 # Exit with success
```

**Explanation of `curl -s http://localhost:8080/healthcheck > /dev/null 2>&1`**:

*   `curl -s "$server_url"`:  Uses the `curl` command to make an HTTP request to the specified `$server_url`. The `-s` option makes `curl` silent, suppressing progress bars and error messages to standard error.
*   `> /dev/null 2>&1`:  This part redirects the output of the `curl` command.
    *   `> /dev/null`: Redirects the standard output (where `curl` normally prints the webpage content) to `/dev/null`. `/dev/null` is a special "black hole" file that discards anything written to it.
    *   `2>&1`:  Redirects standard error (file descriptor 2) to the same location as standard output (file descriptor 1), which is `/dev/null`. This ensures that any error messages from `curl` are also discarded.

    The key here is that the `until` loop cares about the **exit code** of the `curl` command, not its output. If `curl` successfully connects to the server and gets a response (even an error response like 404, as long as the connection is established), it will typically exit with a zero exit code (success). If `curl` fails to connect (e.g., server is down, URL is wrong), it will exit with a non-zero exit code (failure). The `until` loop continues to iterate as long as `curl` fails (non-zero exit code), and stops when `curl` succeeds (zero exit code).

## **`case` Statements: Handling Multiple Choices Efficiently**

The `case` statement provides a structured way to handle multiple conditional branches based on matching a value against a series of patterns. It's particularly useful for creating menus, processing command-line arguments, or handling different input options.

**Ideal For**:  Creating command-line interfaces, parsing user input, handling different file types, implementing menu-driven scripts.

**Advanced Example**:  Creating a CLI tool to manage a service (start, stop, restart, status):

```bash
#!/bin/bash
set -e # Exit on error

service_name="myservice" # Name of the service to manage

# Prompt user for action
read -p "Enter action for service '$service_name' (start/stop/restart/status): " user_input

case "$user_input" in # 'case' statement:  Match the user input against patterns
  start|s) # Pattern 'start' OR 's' (using '|') - case-sensitive matching
    echo "Starting service '$service_name'..."
    systemctl start "$service_name" # Replace with actual service management command
    echo "Service '$service_name' started."
    ;; #  Double semicolon ';;' is essential to terminate each case block and prevent fall-through

  stop|halt) # Pattern 'stop' OR 'halt'
    echo "Stopping service '$service_name'..."
    systemctl stop "$service_name" # Replace with actual service management command
    echo "Service '$service_name' stopped."
    ;;

  restart|reload) # Pattern 'restart' OR 'reload'
    echo "Restarting service '$service_name'..."
    systemctl restart "$service_name" # Replace with actual service management command
    echo "Service '$service_name' restarted."
    ;;

  status) # Pattern 'status'
    echo "Checking status of service '$service_name'..."
    systemctl status "$service_name" # Replace with actual service management command
    ;;

  *) # Default case - matches anything that didn't match the above patterns ('* ' is a wildcard)
    echo "Invalid action: '$user_input'" >&2 # Output error to stderr
    echo "Usage: $0 {start|stop|restart|status}" >&2 # Provide usage instructions
    exit 1 # Exit with error code
    ;; # Terminate the default case as well

esac # 'esac' marks the end of the 'case' statement - like 'fi' for 'if'
exit 0 # Exit with success if a valid action was processed
```

**Pattern Matching Features in `case`**:

*   `|` (OR operator):  Allows matching multiple patterns for a single case (e.g., `start|s)` matches both "start" and "s").
*   `*` (Wildcard):  Matches any string. Used for the default case (often named `*)` to handle unexpected input.
*   `?` (Wildcard): Matches any single character.
*   `[]` (Character ranges):  Matches any character within the specified range (e.g., `[0-9]` matches any digit, `[a-z]` matches any lowercase letter).
*   `\` (Escape character):  Used to escape special characters if you want to match them literally (e.g., `\*` matches a literal asterisk).

## **Exercise: Automate an Enhanced Number Generator and Analyzer**

**Task**: Write a script named `number_analyzer.sh` that:

1.  **Prints numbers from 1 to 20** using a `for` loop.
2.  **Bonus 1:  Even/Odd Check**: Inside the loop, use a conditional statement (`if` or `case`) to check if each number is even or odd. Print each number along with its type (e.g., "Number 2 is Even", "Number 3 is Odd").  *Hint: Use the modulo operator `%` to check for even/odd.*
3.  **Bonus 2: Summation and Average**: Calculate the sum of all numbers from 1 to 20 and compute the average. Print the total sum and the average after the loop completes.
4.  **Expert Challenge:  Prime Number Check**: For each number, add a check to determine if it's a prime number. If it is, print "(Prime)" after the number and its even/odd type (e.g., "Number 7 is Odd (Prime)"). *Prime number check logic will require nested loops or a function.*

**Example Solution (including Even/Odd and Summation Bonuses)**:

```bash
#!/bin/bash
set -e # Exit on error

total_sum=0 # Initialize variable to store the sum of numbers
count=0     # Initialize variable to count the numbers

echo "Analyzing numbers from 1 to 20:"

for num in {1..20}; do # Loop through numbers 1 to 20
  count=$((count + 1)) # Increment the count of numbers processed

  # Check if the number is even or odd using the modulo operator (%)
  if (( num % 2 == 0 )); then # '(( ... ))' for arithmetic conditions, check if remainder when divided by 2 is 0
    type="Even"
  else
    type="Odd"
  fi

  echo "Number $num is $type" # Print the number and its type

  total_sum=$((total_sum + num)) # Add the current number to the total sum
done

average=$((total_sum / count)) # Calculate the average (integer division) - for more precise average, use awk or bc for floating-point arithmetic

echo "-------------------------"
echo "Total sum of numbers: $total_sum" # Print the total sum
echo "Average of numbers: $average"     # Print the average (integer average)

exit 0 # Exit with success
```

**Example Solution (Expert Challenge - Prime Number Check)**:

```bash
#!/bin/bash
set -e # Exit on error

total_sum=0
count=0

is_prime() { # Function to check if a number is prime
  local n="$1" # Function argument: number to check
  if (( n < 2 )); then # Numbers less than 2 are not prime
    return 1 # Return 'false' (non-zero exit code) - not prime
  fi
  for (( i=2; i*i<=n; i++ )); do # Loop from 2 up to the square root of n
    if (( n % i == 0 )); then # If n is divisible by i, it's not prime
      return 1 # Return 'false' - not prime
    fi
  done
  return 0 # If loop completes without finding a divisor, it's prime - return 'true' (zero exit code)
}

echo "Analyzing numbers from 1 to 20 (including prime check):"

for num in {1..20}; do
  count=$((count + 1))

  if (( num % 2 == 0 )); then
    type="Even"
  else
    type="Odd"
  fi

  if is_prime "$num"; then # Call the is_prime function to check if the number is prime
    prime_status="(Prime)"
  else
    prime_status=""
  fi

  echo "Number $num is $type $prime_status" # Print number, type, and prime status

  total_sum=$((total_sum + num))
done

average=$((total_sum / count))

echo "-------------------------"
echo "Total sum of numbers: $total_sum"
echo "Average of numbers: $average"

exit 0
```

## **Pro Tips for Mastering Control Structures**

1.  **Avoid Infinite Loops (Especially with `while true`)**:  Always ensure that `while true` loops have a clear exit condition within their body, typically using `break` or `exit` statements based on some condition.  Unintentional infinite loops can freeze your script and consume system resources.
2.  **Quote Your Variables in Conditions**:  Just like with commands, always quote your variables when using them in conditional expressions (e.g., `[ "$var" -eq "10" ]`, `[[ "$string_var" == "value" ]]`). This prevents word splitting and pathname expansion issues, making your conditions reliable, especially when dealing with strings that might contain spaces or special characters.
3.  **Use `(( ... ))` for Arithmetic Conditions**:  For numerical comparisons and arithmetic operations within conditions, use the `$(( ... ))` arithmetic expansion or `(( ... ))` for arithmetic evaluation within `if` or loop conditions.  `(( ... ))` is often preferred within conditionals for better readability and cleaner syntax (e.g., `if (( count > 10 )); then ...`).
4.  **Understand Exit Codes**:  Bash conditions and control structures heavily rely on command exit codes.  A command that executes successfully typically returns an exit code of 0 (true in conditional contexts), while a command that fails returns a non-zero exit code (false in conditional contexts).  Utilize exit codes effectively for error handling and control flow.

**Common Gotchas to Watch Out For**:

*   **Forgetting `;;` in `case` Statements**:  In `case` statements, remember to terminate each case block with `;;` (double semicolon).  Forgetting `;;` will cause "fall-through," where the script will continue executing the code blocks of subsequent cases, even if they don't match, leading to unexpected and incorrect behavior.
*   **Missing Spaces in `[ $a -eq $b ]`**:  As mentioned earlier, remember that `[` is a command, and it requires spaces around its arguments and operators.  `[ $a -eq $b ]` is correct, but `[$a -eq $b]` or `[ $a-eq $b ]` will result in syntax errors because Bash will not recognize them as valid commands with properly separated arguments.
*   **Confusing String and Numeric Operators**:  Be mindful of using the correct operators for string and numeric comparisons.  Using numeric operators (like `-eq`, `-gt`) for strings or string operators (like `==`, `<`) for numbers can lead to incorrect comparisons and logic errors.  Always use `-eq`, `-ne`, `-lt`, `-gt`, `-le`, `-ge` for numerical comparisons within `[ ... ]` and `[[ ... ]]`. Use `==`, `!=`, `<`, `>` for string comparisons within `[[ ... ]]`.

##### Copyright (c) 2026 ChipVerge

