# Error Handling in Bash Scripting

Robust error handling is crucial for writing reliable Bash scripts. It allows your scripts to gracefully manage unexpected situations, provide informative feedback, and prevent abrupt termination. This section explores key techniques for implementing effective error handling in Bash.

## Exit Status

Every command executed in Bash, whether it's a built-in command, a function, or an external program, returns an **exit status**. This is a numerical code indicating the command's execution outcome.

*   **Success:** An exit status of **`0`** signifies that the command executed successfully without any errors.
*   **Failure:** Any **non-zero** exit status (typically between 1 and 255) indicates that the command encountered an error. Different non-zero values can represent specific error types, although the conventions can vary between commands.

You can access the exit status of the most recently executed command using the special variable **`$?`**.

**Example:**

```bash
#!/bin/bash

# Successful command
ls /home
echo "Exit status of 'ls /home': $?"

# Command that will likely fail (directory likely doesn't exist)
ls /nonexistent_directory
echo "Exit status of 'ls /nonexistent_directory': $?"

# Custom command with a specific exit status
false # 'false' command always exits with status 1
echo "Exit status of 'false': $?"

true  # 'true' command always exits with status 0
echo "Exit status of 'true': $?"
```

**Explanation:**

*   The `ls /home` command will likely succeed if the `/home` directory exists and the user has permissions to list its contents. Thus, `$?` will likely be `0`.
*   `ls /nonexistent_directory` will fail because the directory does not exist, resulting in a non-zero exit status in `$?`.
*   `false` and `true` are built-in commands specifically designed to return exit status 1 (failure) and 0 (success) respectively, useful for scripting logic.

**Importance of Exit Status:**

Exit statuses are fundamental for conditional execution and error checking in scripts. You can use them with control flow structures like `if`, `elif`, `else`, `while`, and `until` to make decisions based on the success or failure of commands.

## Trap Command: Handling Signals and Errors

The `trap` command in Bash is a powerful mechanism for intercepting **signals** and **errors** that can occur during script execution. It allows you to specify commands to be executed when particular events happen, enabling you to handle interruptions, errors, and script termination gracefully.

**Syntax:**

```bash
trap 'command(s)' signal(s)
```

*   **`command(s)`**:  The command or commands to be executed when the specified signal(s) are received or the event occurs.
*   **`signal(s)`**:  One or more signals or special conditions that `trap` should watch for. Signals can be specified by name (e.g., `INT`, `TERM`, `ERR`, `EXIT`) or signal number (e.g., `2` for `INT`, `15` for `TERM`).

**Common Signals and Conditions for `trap`:**

*   **`INT` (Signal 2):**  Interrupt signal. Sent when you press `Ctrl+C` to interrupt a running process.
*   **`TERM` (Signal 15):**  Terminate signal.  The default signal sent by `kill` command to request a process to terminate gracefully.
*   **`EXIT` (Signal 0):**  Not a signal, but a special condition.  The `trap EXIT` command is executed when the script exits, regardless of the exit status or how it terminates (normal exit, error, or `exit` command).
*   **`ERR`:**  Not a signal, but a condition. The `trap ERR` command is executed when a command exits with a non-zero exit status (failure).
*   **`DEBUG`:** Not a signal, but a condition. The `trap DEBUG` command is executed before each command in the script. Useful for debugging.
*   **`signal_name` or `signal_number` (e.g., `USR1`, `USR2`, `HUP`, `1`, `9`):** Various other signals that can be used for inter-process communication or specific system events.

**Examples:**

**1. Handling Interrupt Signal (`INT`):**

```bash
#!/bin/bash
trap 'echo "Script interrupted! Cleaning up..."; exit 130' INT

echo "Starting a long process..."
sleep 10

echo "Process finished."
```

**Explanation:**

*   `trap 'echo "Script interrupted! Cleaning up..."; exit 130' INT` sets up a trap for the `INT` signal.
*   If you press `Ctrl+C` while the `sleep 10` command is running, the script will not terminate immediately. Instead, it will execute the trapped command: `echo "Script interrupted! Cleaning up..."; exit 130`.
*   The message "Script interrupted! Cleaning up..." will be printed, and the script will exit with status `130` (128 + signal number 2).

**2. Cleaning up on Exit (`EXIT`):**

```bash
#!/bin/bash
trap 'rm -f /tmp/my_temp_file; echo "Temporary file removed on exit."' EXIT

echo "Creating a temporary file..."
touch /tmp/my_temp_file

echo "Script running..."
sleep 5

echo "Exiting script."
```

**Explanation:**

*   `trap 'rm -f /tmp/my_temp_file; echo "Temporary file removed on exit."' EXIT` ensures that the temporary file `/tmp/my_temp_file` is deleted and a message is printed when the script finishes, regardless of whether it completes successfully or is terminated by a signal or error.

**3. Error Handling with `ERR`:**

```bash
#!/bin/bash
trap 'echo "An error occurred! Exit status: $?"; exit 1' ERR

mkdir /root/protected_directory  # This will likely fail due to permissions
echo "This line will not be reached if mkdir fails."
```

**Explanation:**

*   `trap 'echo "An error occurred! Exit status: $?"; exit 1' ERR` sets up an error trap.
*   If the `mkdir /root/protected_directory` command fails (returns a non-zero exit status), the trapped command will be executed.
*   The error message and the exit status of the failing command (`$?`) will be printed, and the script will exit with status `1`.
*   The `echo "This line will not be reached..."` command will not be executed if `mkdir` fails because the script exits in the trap handler.

**4. Ignoring Signals:**

You can use `trap ""` to ignore a signal. For example, `trap "" INT` will make the script ignore `Ctrl+C`.

**Important Notes about `trap`:**

*   **Scope:** Traps are typically set for the current script and its child processes.
*   **Multiple Traps:** You can set multiple traps for different signals or conditions.
*   **Resetting Traps:** You can reset a trap by using `trap - signal(s)` or remove a trap by using `trap signal(s)`.
*   **Signal Numbers vs. Names:** Using signal names (e.g., `INT`, `TERM`) is generally preferred for readability, but signal numbers can also be used.

## Debugging Techniques

Debugging Bash scripts is essential for identifying and resolving errors. Bash provides several built-in features and common techniques to aid in the debugging process.

### 1. Using the `set` Command for Debugging Options

The `set` command is versatile and can enable various debugging options that control Bash's behavior during script execution.

*   **`set -x` (or `set -o xtrace`):  Execution Tracing**

    This is one of the most valuable debugging options. When `-x` is enabled, Bash will print each command **before** executing it, preceded by a `+` symbol. This allows you to follow the script's execution flow step-by-step and see the commands being run with variable expansions.

    ```bash
    #!/bin/bash
    set -x  # Enable execution tracing

    name="Debugging Example"
    echo "Script name: $name"
    ls -l /tmp

    set +x  # Disable execution tracing
    echo "Tracing disabled"
    ```

    **Output (with `set -x` enabled):**

    ```text
    + name='Debugging Example'
    + echo 'Script name: Debugging Example'
    Script name: Debugging Example
    + ls -l /tmp
    ... (output of ls -l /tmp) ...
    + set +x
    + echo 'Tracing disabled'
    Tracing disabled
    ```

*   **`set -v` (or `set -o verbose`): Verbose Mode**

    When `-v` is enabled, Bash will print each line of the script as it is read. This is useful for seeing the raw script code as it's being processed, before any expansions or executions.

    ```bash
    #!/bin/bash
    set -v  # Enable verbose mode

    name="Verbose Example"
    echo "Script name: $name"
    ```

    **Output (with `set -v` enabled):**

    ```text
    #!/bin/bash
    set -v  # Enable verbose mode

    name="Verbose Example"
    echo "Script name: $name"
    name="Verbose Example"
    Script name: Verbose Example
    ```

*   **`set -n` (or `set -o noexec` or `set -n`): No Execution (Syntax Check)**

    When `-n` is enabled, Bash will read and parse the script but will **not execute** any commands. This is extremely useful for performing a syntax check of your script without actually running it. It will identify syntax errors without causing any side effects.

    ```bash
    #!/bin/bash
    set -n  # Enable noexec mode (syntax check)

    ech "Typo in command name" # Intentional typo
    variable=value
    if [ condition ] # Incomplete if statement
    then
      echo "This will not be executed"
    fi

    set +n  # Disable noexec mode
    echo "Syntax check complete (no execution)"
    ```

    **Output (with `set -n` enabled if there's a syntax error):**

    ```text
    /tmp/your_script.sh: line 4: ech: command not found
    /tmp/your_script.sh: line 5: conditional binary operator expected
    /tmp/your_script.sh: line 5: syntax error near `condition'
    Syntax check complete (no execution)
    ```

*   **`set -e` (or `set -o errexit`): Exit on Error**

    When `-e` is enabled, the script will exit immediately if any command exits with a non-zero status (failure). This is helpful for ensuring that your script stops as soon as an error occurs, preventing it from proceeding with potentially problematic operations.

    ```bash
    #!/bin/bash
    set -e  # Enable exit on error

    mkdir /tmp/my_directory  # Assuming /tmp is writable
    cd /tmp/my_directory
    mkdir /root/protected_directory # Will likely fail

    echo "This line will NOT be reached if the previous mkdir fails."
    ```

    **Explanation:**

    If `mkdir /root/protected_directory` fails (due to permissions), the script will exit immediately, and the `echo` command will not be executed.

**Combining `set` Options:**

You can combine multiple `set` options for more comprehensive debugging. For example, `set -x -e` will enable both execution tracing and exit-on-error.

### 2. Using `trap DEBUG` for Line-by-Line Inspection

As demonstrated earlier, `trap DEBUG` is a powerful debugging tool. It allows you to execute a command **before every command** in your script. This can be used to:

*   **Print Line Numbers:**  `trap 'echo "Line $LINENO"' DEBUG` will print the line number before each line is executed.
*   **Print Commands:** `trap 'echo "Command: $BASH_COMMAND"' DEBUG` will print the command about to be executed.
*   **Inspect Variables:** `trap 'echo "Variable value: \$my_var = $my_var"' DEBUG` (escape `$` for variable name in the trap command) will print the value of `$my_var` before each command.
*   **Function Call Tracing:** If you have functions, you can use `FUNCNAME` and `BASH_LINENO` within a `DEBUG` trap to trace function calls.

**Example: Combining Line Number and Command Printing**

```bash
#!/bin/bash
trap 'echo "Line $LINENO: $BASH_COMMAND"' DEBUG

my_var="initial value"
echo "Variable is: $my_var"
my_var="updated value"
ls -l /tmp
```

**Output:**

```text
Line 2: trap 'echo "Line $LINENO: $BASH_COMMAND"' DEBUG
Line 4: my_var="initial value"
Line 5: echo "Variable is: $my_var"
Variable is: initial value
Line 6: my_var="updated value"
Line 7: ls -l /tmp
... (output of ls -l /tmp) ...
```

### 3. Simple `echo` Statements for Debugging

Sometimes, the simplest debugging technique is the most effective. Inserting `echo` statements at strategic points in your script to print variable values, messages, or track program flow can be very helpful.

```bash
#!/bin/bash

username="test_user"
echo "Debugging: Username before check is: $username"

if id -u "$username" >/dev/null 2>&1; then
  echo "Debugging: User '$username' exists."
  echo "User '$username' exists."
else
  echo "Debugging: User '$username' does not exist."
  echo "User '$username' does not exist."
fi
```

**Explanation:**

The `echo "Debugging: ..."` lines are added to print messages that help you understand the script's state and logic during execution. Once you've debugged, you can easily remove or comment out these `echo` statements.

### 4. Using a Bash Debugger (e.g., `bashdb`, `shdb`)

For more complex scripts, dedicated debuggers like `bashdb` (for Bash) or `shdb` (for Bourne shell compatible scripts) provide advanced debugging features similar to debuggers in other programming languages. These debuggers allow you to:

*   **Set Breakpoints:** Pause script execution at specific lines.
*   **Step Through Code:** Execute the script line by line.
*   **Inspect Variables:** Examine the values of variables at any point.
*   **Watch Variables:** Monitor variable changes.
*   **Stack Tracing:** See the function call stack.

Using a debugger typically involves installing the debugger tool and running your script under its control. Debuggers provide a more interactive and structured debugging experience compared to `set` options or `echo` statements.

**Example (Conceptual - using `bashdb`):**

```bash
# Assuming bashdb is installed

bashdb your_script.sh
```

Once inside the debugger, you can use commands like:

*   `break line_number`: Set a breakpoint at a specific line.
*   `step` (or `s`): Execute the next line.
*   `next` (or `n`): Execute the next line, stepping over function calls.
*   `print variable_name`: Print the value of a variable.
*   `continue` (or `c`): Continue execution until the next breakpoint or the end of the script.
*   `quit` (or `q`): Exit the debugger.

Refer to the documentation of `bashdb` or `shdb` for detailed usage instructions and features.

## Exercise: Robust Directory Creation Script

**Task:**

Create a Bash script that attempts to create a directory specified by the user. The script should:

1.  **Prompt the user** to enter the name of the directory to create.
2.  **Check if the directory already exists.** If it does, print an informative message and exit with an appropriate exit status.
3.  **Attempt to create the directory.**
4.  **Handle potential errors** during directory creation using the `trap ERR` command. If an error occurs:
    *   Print an error message indicating directory creation failure.
    *   Exit with a non-zero exit status (e.g., `exit 1`).
5.  If directory creation is successful, print a success message.

**Example Solution:**

```bash
#!/bin/bash

# Script to create a directory and handle errors

# Prompt user for directory name
read -p "Enter the name of the directory to create: " directory_name

# Check if directory already exists
if [ -d "$directory_name" ]; then
  echo "Error: Directory '$directory_name' already exists."
  exit 1
fi

# Trap errors during directory creation
trap 'echo "Error: Failed to create directory '$directory_name'."; exit 1' ERR

# Attempt to create the directory
mkdir "$directory_name"

# Check if mkdir was successful (optional, trap ERR already handles failures)
if [ $? -eq 0 ]; then
  echo "Directory '$directory_name' created successfully."
else
  # This part is technically redundant because trap ERR would have already exited
  echo "Error: Directory creation may have failed (check previous error message)."
  exit 1
fi

# Remove the trap after directory creation (optional, depends on script needs)
trap - ERR
```

**Explanation of the Solution:**

*   **User Input:** The script prompts the user to enter a directory name using `read -p`.
*   **Directory Existence Check:**  It uses `[ -d "$directory_name" ]` to check if a directory with the given name already exists. If it does, an error message is printed, and the script exits with status `1`.
*   **Error Trapping:** `trap '...' ERR` sets up an error handler. If `mkdir` fails, the trapped command is executed, printing an error message and exiting with status `1`.
*   **Directory Creation:** `mkdir "$directory_name"` attempts to create the directory.
*   **Success Message:** If `mkdir` succeeds (and the script reaches this point without triggering the `ERR` trap or the directory existence check), a success message is printed.
*   **Redundant Exit Status Check (Optional):** The `if [ $? -eq 0 ]` block after `mkdir` is technically redundant in this specific example because the `trap ERR` already handles and exits on `mkdir` failure. However, in more complex scenarios where you might want to perform additional actions after a potential error but still exit, you might keep such checks.
*   **Removing the Trap (Optional):** `trap - ERR` removes the `ERR` trap after the directory creation. Whether you remove traps depends on your script's logic. If you want error handling for the rest of the script, you would typically leave the trap in place.

##### Copyright (c) 2026 ChipVerge

