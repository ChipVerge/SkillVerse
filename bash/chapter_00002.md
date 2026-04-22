# Bash Scripting Essentials: Your Toolkit

## **Your First Script: "Hello, World!" and Beyond**

Let's break down the "Hello, World!" script to grasp the fundamental concepts of Bash scripting. It's simple, but packed with essential elements.

### **Step-by-Step Breakdown**

1.  **Create `hello_world.sh`**: Open your text editor and create a new file named `hello_world.sh`.  Add the following lines:

    ```bash
    #!/bin/bash  #  The "Shebang" -  Specifies Bash as the script interpreter
    echo "Hello, World!"  #  The 'echo' command - Prints text to your terminal
    ```

    *   **Explanation:**
        - `#!/bin/bash`:  This is the **shebang** line (pronounced "sha-bang"). It's the very first line of your script and is crucial. It tells the operating system which interpreter should be used to execute the script. In this case, we're specifying `/bin/bash`, which is the path to the Bash executable.  Without this line, the system might not know how to run your script directly.
        - `echo "Hello, World!"`:  `echo` is a built-in Bash command that displays text (or variables) to the standard output, which is typically your terminal screen.  Here, it will print the literal text "Hello, World!".

2.  **Make the Script Executable**: In your terminal, navigate to the directory where you saved `hello_world.sh`.  Use the `chmod` command to add execute permissions:

    ```bash
    chmod +x hello_world.sh  #  'chmod +x' - Grants execute permission to the script file
    ```

    *   **Explanation:**  By default, newly created files are not executable for security reasons.  The `chmod +x` command modifies the file's permissions, specifically adding the "execute" permission (`+x`) for the user, group, and others. This allows you to run the script directly.

3.  **Run Your Script**:  Execute the script from your current directory:

    ```bash
    ./hello_world.sh  #  Executes the script located in the current directory
    ```

    *   **Explanation:**  `./`  is a shorthand way to tell your shell to look in the *current directory* for the executable named `hello_world.sh`. Without `./`, the shell would search for `hello_world.sh` in the directories listed in your system's `PATH` environment variable (which usually doesn't include the current directory for security reasons).

**Pro Tip**:  You can also run the script using the `bash` command directly, even without execute permissions: `bash hello_world.sh`. This explicitly tells Bash to interpret and run the script, regardless of its execute permissions. This is useful for testing scripts before making them executable or in situations where you don't have permission to change file permissions.

**Troubleshooting**:

*   **"Permission denied" error?**  Double-check that you ran `chmod +x hello_world.sh`.  If you just created the file, this step is essential.
*   **"Command not found" error?**
    *   Ensure you are in the same directory where you saved `hello_world.sh` when you run `./hello_world.sh`. Use `pwd` to check your current directory and `ls` to see if `hello_world.sh` is there.
    *   Verify the shebang line `#!/bin/bash` is correctly typed and is the very first line of the file.

## **Core Shell Commands: Your Navigation and File Management Toolkit**

Master these fundamental commands to navigate your file system and manage files and directories efficiently. These are the building blocks for more complex scripts.

| Command   | Description                                   | Common Flags & Usage Examples                                                  |
| :-------- | :-------------------------------------------- | :----------------------------------------------------------------------------- |
| `ls`      | **List files and directories**                | `-l`:  **Detailed list** (permissions, size, date). `ls -l`<br> `-a`: **Show all** (including hidden files/directories starting with `.`). `ls -a`<br> `-h`: **Human-readable sizes**. `ls -lh`<br> `ls <directory>`: List contents of a specific directory. `ls /home/user/documents` |
| `cd`      | **Change directory**                          | `cd <directory>`: Change to a specific directory. `cd documents`<br> `cd ~`: Go to your **home directory**. `cd ~`<br> `cd -`: Go to the **previous directory**. `cd -`<br> `cd ..`: Go **up one directory level**. `cd ..`                                  |
| `pwd`     | **Print working directory** (show current path) | No common flags. Simply `pwd` to display the full path of your current location. |
| `cp`      | **Copy files and directories**                | `cp <source> <destination>`: Copy a file. `cp file.txt backup.txt`<br> `-r`: **Recursive copy** for directories (copy directory and its contents). `cp -r directory1 directory_backup`<br> `cp file.txt directory2/`: Copy file into a directory. `cp file.txt documents/` |
| `mv`      | **Move or rename files and directories**      | `mv <source> <destination>`: Move a file (or rename if destination is in the same directory). `mv old_file.txt new_file.txt`<br> `mv file.txt documents/`: Move file to a different directory. `mv file.txt documents/`<br> `-i`: **Interactive mode** (prompt before overwriting). `mv -i file1.txt existing_file.txt` |
| `rm`      | **Remove (delete) files and directories**      | `rm <file>`: Delete a file. `rm temp_file.txt`<br> `-r`: **Recursive removal** for directories (delete directory and its contents). `rm -r directory_to_delete` <br> `-f`: **Force removal** (ignore non-existent files, no prompts). **Use with extreme caution, especially with `-rf`!** `rm -rf directory_to_delete` |
| `mkdir`   | **Make directory** (create directories)       | `mkdir <directory_name>`: Create a directory. `mkdir new_directory`<br> `-p`: **Parents** - Create parent directories if they don't exist. `mkdir -p projects/bash_scripts/utilities`                                  |

**Example Workflow**:  Let's say you want to organize your scripts:

```bash
mkdir -p ~/projects/bash_scripts  # Create nested directories: projects, then bash_scripts inside projects, if they don't exist in your home directory (~)
cd ~/projects/bash_scripts         # Change directory into the newly created 'bash_scripts' directory
ls                                # List the contents of 'bash_scripts' (it will be empty initially)
pwd                               # Print the current directory path to confirm you are in '~/projects/bash_scripts'
```

## **Variables: Your Script's Memory for Storing Data**

Bash variables are used to store information that your scripts can use and manipulate. Think of them as containers for data.

### **Key Concepts**:

*   **String-Based**: In Bash, **all variables are treated as strings by default**, even if they contain numbers. Bash automatically handles type conversion when needed for arithmetic or comparisons.
*   **Declaration and Assignment**: You assign a value to a variable using the syntax: `var_name="value"`.  **Crucially, there should be no spaces around the `=` sign.**
*   **Accessing Variable Values**: To use the value stored in a variable, you need to **dereference** it using a `$` prefix: `$var_name` or `${var_name}`.  Using curly braces `${var_name}` is often recommended as it can prevent ambiguity in more complex cases.

**Best Practices for Variable Naming and Usage**:

```bash
#!/bin/bash

# Variable assignments
user_name="Alice"        # Use lowercase with underscores for local variables - improves readability
readonly PI=3.14159      # Use uppercase for constants (values that shouldn't change) - convention to indicate constants
file_list=$(ls *.txt)   # Store the output of a command in a variable - capture command results

# Displaying variable values
echo "User: $user_name, PI: ${PI}"  # Access variables using $ or ${}
echo "Text files in current directory: $file_list" # Output the list of text files

# Example of using a variable in a command
log_directory="/var/log/myapp"
ls -l "$log_directory" # Always quote variables, especially when used in commands, to prevent issues with spaces in paths
```

### **Arrays: Managing Collections of Data**

Bash arrays allow you to store ordered lists of items (strings or numbers) within a single variable.

```bash
#!/bin/bash

# Declare and initialize an array of fruits
fruits=("Apple" "Banana" "Cherry" "Date") # Elements are space-separated within parentheses

# Accessing array elements
echo "First fruit: ${fruits[0]}"   # Array indexing starts at 0. Output: Apple
echo "Second fruit: ${fruits[1]}"  # Output: Banana

# Accessing all elements of the array
echo "All fruits: ${fruits[@]}"   #  '${fruits[@]}' expands to all array elements, each as a separate word. Output: Apple Banana Cherry Date
echo "All fruits as a single string: ${fruits[*]}" # '${fruits[*]}' expands to all elements as one string, joined by the first character of IFS (usually space). Output: Apple Banana Cherry Date

# Array length
echo "Number of fruits: ${#fruits[@]}" # '${#fruits[@]}' gives the number of elements in the array. Output: 4

# Adding elements to an array
fruits+=("Elderberry" "Fig") # Append new elements to the array
echo "Updated fruits: ${fruits[@]}" # Output: Apple Banana Cherry Date Elderberry Fig
```

**Pro Tip**: While Bash arrays are dynamically typed, if you want to be explicit about declaring an array, you can use `declare -a array_name`:  `declare -a my_array`. This is good practice for code clarity, especially in larger scripts.

## **Operators:  Performing Math, Logic, and Comparisons**

Bash provides a range of operators for arithmetic calculations, logical evaluations, and comparisons.

### **Arithmetic Operations**

Bash uses `$(( ... ))` (preferred) or the older `let` command for arithmetic operations.  `$(( ... ))` is generally recommended for its clarity and versatility.

```bash
#!/bin/bash

# Using $(( ... )) for arithmetic
sum=$((5 + 3 * 2))    # Arithmetic expansion. Multiplication and addition are performed.
echo "Sum: $sum"       # Output: Sum: 11

difference=$((10 - 4))
echo "Difference: $difference" # Output: Difference: 6

product=$((7 * 3))
echo "Product: $product"   # Output: Product: 21

quotient=$((20 / 4))
echo "Quotient: $quotient"  # Output: Quotient: 5

remainder=$((17 % 5))    # Modulo operator (%) - remainder of division
echo "Remainder: $remainder" # Output: Remainder: 2

# Increment and Decrement
count=10
((count++))           # Increment count by 1 (post-increment)
echo "Incremented count: $count" # Output: Incremented count: 11
((count--))           # Decrement count by 1 (post-decrement)
echo "Decremented count: $count" # Output: Decremented count: 10
```

### **Comparison Operators**

Bash offers distinct sets of operators for comparing numbers and strings.  It's important to use the correct set to avoid unexpected results.

| Operator Type | Numeric Operators | String Operators | Purpose                               | Example                                      |
| :------------ | :---------------- | :--------------- | :------------------------------------ | :------------------------------------------- |
| **Equality**  | `-eq`             | `==` or `=`      | **Equal to**                          | `if [ "$num" -eq "10" ]` or `if [ "$str1" == "$str2" ]` |
| **Inequality**| `-ne`             | `!=`             | **Not equal to**                      | `if [ "$num" -ne "20" ]` or `if [ "$str1" != "$str3" ]` |
| **Less Than** | `-lt`             | `<`              | **Less than**                         | `if [ "$num" -lt "100" ]` or `if [[ "$str1" < "$str2" ]]`<sup>\*</sup> |
| **Greater Than**| `-gt`             | `>`              | **Greater than**                      | `if [ "$num" -gt "5" ]` or `if [[ "$str1" > "$str2" ]]`<sup>\*</sup> |
| Less or Equal| `-le`             |                  | **Less than or equal to**             | `if [ "$num" -le "10" ]`                     |
| Greater or Equal| `-ge`             |                  | **Greater than or equal to**          | `if [ "$num" -ge "0" ]`                      |

**Important Notes on String Comparisons:**

*   For string comparisons with `<`, `>`, use **double square brackets `[[ ... ]]`** instead of single square brackets `[ ... ]`.  Within `[[ ... ]]`,  `<` and `>` perform lexicographical (dictionary) ordering. In `[ ... ]`, they redirect input/output.
*   When using `==` or `!=` for string equality in `[ ... ]`, quoting variables is crucial: `[ "$str1" == "$str2" ]`.

**Example**:

```bash
#!/bin/bash

username="$1" # First command-line argument
argument_count="$#" # Number of command-line arguments

if [ "$username" == "admin" ] && [ "$argument_count" -eq 1 ]; then # String comparison with ==, numeric comparison with -eq, logical AND with &&
  echo "Welcome, administrator!"
elif [ "$username" != "" ]; then # String inequality with !=
  echo "Hello, $username!"
else
  echo "Welcome, guest user."
fi
```

### **Logical Operators: Combining Conditions**

Use logical operators to create more complex conditions by combining simpler ones.

*   `&&` (**AND**):  Both conditions must be true for the combined condition to be true.
*   `||` (**OR**):  At least one of the conditions must be true for the combined condition to be true.
*   `!`  (**NOT**):  Negates a condition.

**Example**:

```bash
#!/bin/bash

# Check if file 'data.txt' exists OR create it if it's missing
if [ ! -f "data.txt" ] || touch data.txt; then # Logical OR (||), file existence check (-f), NOT operator (!)
  echo "Ensured 'data.txt' exists."
fi

# Check if a directory 'scripts' exists AND is not empty
if [ -d "scripts" ] && [ "$(ls -A scripts)" ]; then # Logical AND (&&), directory existence check (-d), check if directory is not empty using ls -A and string length check
  echo "The 'scripts' directory exists and is not empty."
fi
```

## **Exercise: Build a Dynamic Greeting System - Enhanced!**

**Task**:  Create a script named `greet.sh` that:

1.  **Takes a username as a command-line argument.**
2.  **Greets the user personally** (e.g., "Hello, Alice!") along with the current time in HH:MM format.
3.  **Bonus Feature: Error Handling**:
    *   If no username argument is provided, the script should print an informative error message to the standard error stream (stderr) and exit with an error code (non-zero).
    *   If the username provided is "root", print a special greeting "Greetings, root administrator!".

**Example Solution**:

```bash
#!/bin/bash
set -e  # Exit on error

# --- Input Validation and Error Handling ---
if [ "$#" -eq 0 ]; then # Check if no arguments are provided ($# is the number of arguments)
  echo "Error: Please provide a username as a command-line argument." >&2 # Print error message to stderr (>&2)
  echo "Usage: $0 <username>" >&2 # Print usage instructions
  exit 1 # Exit with error code 1 (non-zero exit code indicates failure)
fi

username="$1" # Get the first command-line argument (username)

# --- Greeting Logic ---
current_time=$(date +"%H:%M") # Get current time in HH:MM format using 'date' command and store in variable

if [ "$username" == "root" ]; then # Check if username is "root"
  greeting="Greetings, root administrator!" # Special greeting for root
else
  greeting="Hello, $username!" # Standard greeting for other users
fi

# --- Output ---
echo "$greeting Current time is $current_time." # Print the greeting message with the current time

exit 0 # Exit with success code 0
```

**Run It and Test**:

```bash
./greet.sh Alice         # Expected Output: Hello, Alice! Current time is ...
./greet.sh root          # Expected Output: Greetings, root administrator! Current time is ...
./greet.sh               # Expected Output: Error: Please provide a username as a command-line argument.
                         #                  Usage: ./greet.sh <username>
                         # (and the script will exit with a non-zero status)
```

## **Pro Tips for Bash Beginners (and Beyond!)**

1.  **Always Quote Your Variables**:  Get into the habit of quoting your variables (`"$var"`) unless you have a very specific reason not to.  Quoting prevents word splitting and pathname expansion, which can lead to unexpected behavior and errors, especially when dealing with filenames or strings containing spaces or special characters.

2.  **Use `[[ ]]` for Advanced Conditional Checks**:  The `[[ ... ]]` construct is a more modern and robust alternative to `[ ... ]` for conditional expressions.  It offers several advantages, including:
    *   **Regular Expression Matching**:  Supports regex matching using `=~`.
    *   **No Pathname Splitting or Word Splitting**: Less prone to errors with unquoted variables.
    *   **Logical Operators**: `&&`, `||`, `!` work as expected within `[[ ]]`.

    ```bash
    #!/bin/bash

    file="my_log_file.log"

    if [[ "$file" =~ ^my_.*\.log$ ]]; then  # Regex matching to check if filename starts with "my_" and ends with ".log"
      echo "'$file' looks like a log file."
    fi

    string_with_space="hello world"
    if [[ "$string_with_space" == "hello world" ]]; then # No need to worry about word splitting with [[ ]]
      echo "String comparison works correctly with spaces."
    fi
    ```

3.  **Enable Debug Mode with `bash -x script.sh`**:  When your script isn't behaving as expected, run it with `bash -x script.sh`.  This turns on **xtrace** mode, which prints each command to the terminal *before* it is executed.  This is invaluable for tracing the script's execution flow, variable values, and identifying where things go wrong.

**Important Gotcha Alerts**:

*   **Variable Assignment vs. Arithmetic**:  Be careful with variable assignment and arithmetic.  `var=5+2`  assigns the *string* `"5+2"` to `var`, not the number 7.  To perform arithmetic, always use `$(( ... ))`: `var=$((5+2))`.
*   **Unquoted Variables and `rm` (Danger!)**:  Never use unquoted variables with commands like `rm`, `mv`, or `cp` if there's any chance the variable might contain spaces or special characters.  For example, if `$file` is unquoted and contains `"file1 file2"`,  `rm $file` will be interpreted as `rm file1 file2`, deleting both `file1` and `file2`!  **Always quote variables in commands: `rm "$file"`**.

##### Copyright (c) 2026 ChipVerge

