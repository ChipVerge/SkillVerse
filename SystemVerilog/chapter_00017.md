# SystemVerilog Command Line Arguments: Parameterizing Simulations for Flexibility

## Introduction: Tailoring Simulation Behavior from the Command Line

Command line arguments in SystemVerilog provide a powerful mechanism to control and customize simulation runs without modifying the source code. This capability is crucial for creating flexible and reusable verification environments, enabling users to:

-   **Parameterize Simulations**: Modify design parameters, testbench configurations, and simulation settings directly from the command line. This eliminates the need to recompile code for different scenarios, streamlining the verification process.
-   **Test Case Selection**: Choose specific test cases or test suites to execute during a simulation run. This allows for focused verification and regression testing, targeting specific functionalities or bug fixes.
-   **Control Verbosity and Debugging**: Adjust the level of simulation output, enable or disable debug messages, and configure logging options through command line flags. This enhances debugging efficiency and allows for tailored output based on verification needs.
-   **Environment Configuration**: Specify paths to configuration files, input data files, and output directories via command line arguments. This improves portability and organization of simulation environments.

By leveraging command line arguments, verification engineers can create highly adaptable simulations that can be easily configured and executed for various verification tasks, promoting efficiency and reusability.

## Accessing Command Line Arguments

SystemVerilog provides system functions to access command line arguments passed to the simulator during invocation. The primary functions are `$value$plusargs` and `$test$plusargs`.

### `$value$plusargs`: Retrieving Argument Values

The `$value$plusargs` system function is used to retrieve the value associated with a specific command line argument. It searches for arguments starting with a plus sign (`+`) followed by a keyword and optionally an equals sign (`=`) and a value.

**Syntax:**

```SV
integer result;
result = $value$plusargs("<argument_format_string>", <variable1>, <variable2>, ...);
```

**Argument Format String:** The `<argument_format_string>` is a string that specifies the format of the command line argument to search for. It can include format specifiers to extract values into variables.

-   **Simple Keyword Matching**: If the format string contains only a keyword (e.g., `"TESTCASE"`), `$value$plusargs` checks for the presence of `+TESTCASE` on the command line. It returns `1` if found, `0` otherwise.
-   **Value Extraction**: To extract a value associated with an argument, use format specifiers within the format string. For example, `"TESTCASE=%s"` will match `+TESTCASE=test_name` and extract `"test_name"` into a string variable.

**Return Value:**

-   Returns the number of variables successfully assigned values from the command line arguments.
-   Returns `0` if the specified argument format string is not found on the command line.

**Example: Retrieving Test Case Name and Iteration Count**

```SV
module command_line_example;
  string test_name;
  integer iterations;
  integer result;

  initial begin
    result = $value$plusargs("TESTCASE=%s", test_name); // Try to get test case name
    if (result == 1) begin
      $display("Test case name from command line: %s", test_name);
    end else begin
      $display("Test case name not provided via command line, using default.");
      test_name = "default_test"; // Default test case if not provided
    end

    result = $value$plusargs("ITERATIONS=%d", iterations); // Try to get iteration count
    if (result == 1) begin
      $display("Iteration count from command line: %0d", iterations);
    end else begin
      $display("Iteration count not provided, using default (10).");
      iterations = 10; // Default iterations if not provided
    end

    $display("--- Simulation Configuration ---");
    $display("Running test case: %s", test_name);
    $display("Number of iterations: %0d", iterations);
  end
endmodule
```

**Simulation Command Example:**

```bash
vcs +TESTCASE=memory_test +ITERATIONS=100 command_line_example.sv
```

### `$test$plusargs`: Checking for Argument Presence

The `$test$plusargs` system function is simpler than `$value$plusargs`. It only checks for the presence of a command line argument that matches a given format string, but does not extract any values. It is primarily used for flag arguments.

**Syntax:**

```SV
integer found;
found = $test$plusargs("<argument_format_string>");
```

**Argument Format String:** The `<argument_format_string>` is similar to that of `$value$plusargs`, but it's mainly used for keyword matching. Format specifiers are generally not used with `$test$plusargs` as it only checks for presence.

**Return Value:**

-   Returns `1` if an argument matching the format string is found on the command line.
-   Returns `0` if no matching argument is found.

**Example: Using Flag Arguments for Verbosity Control**

```SV
module verbosity_control;
  bit verbose_mode;

  initial begin
    if ($test$plusargs("VERBOSE")) begin // Check for +VERBOSE flag
      verbose_mode = 1;
      $display("Verbose mode enabled via command line.");
    end else begin
      verbose_mode = 0;
      $display("Verbose mode disabled (default).");
    end

    $display("--- Simulation Verbosity Setting ---");
    $display("Verbose mode: %0b", verbose_mode);

    if (verbose_mode) begin
      $display("--- Detailed Simulation Output ---");
      // ... more detailed output statements ...
    end else begin
      $display("--- Summary Simulation Output ---");
      // ... summary output statements ...
    end
  end
endmodule
```

**Simulation Command Examples:**

```bash
// Verbose mode disabled
vcs verbosity_control.sv

// Verbose mode enabled
vcs +VERBOSE verbosity_control.sv
```

## Parameter Overriding with Command Line Arguments

Command line arguments can directly override `parameter` values defined within SystemVerilog modules. This is a powerful feature for configuring module behavior without code modification.

**Mechanism:**

-   When a simulator encounters a command line argument that matches a module parameter name (prefixed with `+`), it attempts to override the parameter's default value with the value provided in the argument.
-   Parameter overriding is typically done using the `+parameter_name=value` format.

**Example: Overriding Module Parameter `DATA_WIDTH`**

```SV
module parameterized_module #(parameter DATA_WIDTH = 8) (
  input logic [DATA_WIDTH-1:0] data_in,
  output logic [DATA_WIDTH-1:0] data_out
);
  assign data_out = data_in;
  initial $display("Module instantiated with DATA_WIDTH = %0d", DATA_WIDTH);
endmodule

module top_module;
  parameterized_module instance1 (); // Instance with default DATA_WIDTH
  parameterized_module #(.DATA_WIDTH(16)) instance2 (); // Instance with explicitly set DATA_WIDTH = 16
  parameterized_module instance3 (); // Another instance to be overridden by command line

  initial begin
    $display("--- Module Instantiation ---");
  end
endmodule
```

**Simulation Command Examples:**

```bash
// Using default DATA_WIDTH for instance3
vcs top_module.sv

// Overriding DATA_WIDTH for instance3 to 32
vcs +parameterized_module.DATA_WIDTH=32 top_module.sv
```

In the second example, the command line argument `+parameterized_module.DATA_WIDTH=32` overrides the default `DATA_WIDTH` parameter of `instance3` in `top_module`. Instances `instance1` and `instance2` retain their original parameter values.

## Best Practices for Command Line Arguments

-   **Descriptive Argument Names**: Use clear and descriptive names for command line arguments (e.g., `TESTCASE`, `ITERATIONS`, `VERBOSE_LEVEL`, `CONFIG_FILE`) to improve readability and maintainability.
-   **Document Command Line Options**: Provide clear documentation of all supported command line arguments, their purpose, expected values, and default behaviors. This documentation is crucial for users to effectively utilize the simulation environment.
-   **Implement Default Values**: Assign sensible default values to parameters and configurations within the SystemVerilog code. This ensures that simulations can run even if command line arguments are not provided, while still allowing for customization when needed.
-   **Robust Argument Parsing and Validation**: Implement error handling to check for invalid or missing command line arguments. Validate the format and range of argument values to prevent unexpected simulation behavior. Provide informative error messages to guide users in case of incorrect argument usage.
-   **Consistent Argument Conventions**: Establish consistent conventions for argument prefixes (`+`, `-`, etc.) and value delimiters (`=`, `:`, etc.) within your verification environment to maintain uniformity and ease of use.

## Comprehensive Function Reference Table

| Function                                      | Description                                                                                                                                                                                                   | Return Value                                     | Notes                                                                                                                                           |
| :---------------------------------------------------- | :-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | :---------------------------- | :-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `$value$plusargs("<format>", <variable1>, ...)`     | Searches for command line arguments matching `<format>` string (starting with `+`). Extracts values based on format specifiers in `<format>` and assigns them to variables.                                                                                                                                                                                                                                                                                                                                                                                                                                     | Number of variables assigned (int) | Use for retrieving values associated with command line arguments (e.g., test case name, iteration count, file paths). Use format specifiers (like `%s`, `%d`, `%h`) in `<format>` to specify the expected data type and extract values into corresponding variables. Returns 0 if the argument is not found.                                                                                                                                                                                                                                                                                                             |
| `$test$plusargs("<format>")`                           | Checks for the presence of command line arguments matching `<format>` string (starting with `+`). Does not extract values. Primarily used for flag arguments (boolean switches).                                                                                                                                                                                                                                                                                                                                                                                                                                         | 1 (found), 0 (not found)    | Use for checking if a specific flag argument is provided (e.g., +VERBOSE, +DEBUG_MODE).  No value extraction is performed. Returns 1 if the argument is present, 0 otherwise.                                                                                                                                                                                                                                                                                                               |

## Robust Error Handling for Command Line Arguments

Error handling for command line arguments is essential to ensure simulation robustness and provide user-friendly feedback.

### Argument Presence and Value Validation

```SV
module robust_command_line;
  string test_name;
  integer iterations;
  integer result;

  initial begin
    // 1. Check for Test Case Argument
    result = $value$plusargs("TESTCASE=%s", test_name);
    if (result == 0) begin
      $warning("Warning: TESTCASE argument not provided. Using default 'regression_test'.");
      test_name = "regression_test"; // Use default test case
    end

    // 2. Check for Iterations Argument and Validate Value Range
    result = $value$plusargs("ITERATIONS=%d", iterations);
    if (result == 0) begin
      $display("Info: ITERATIONS argument not provided. Using default 10.");
      iterations = 10; // Default iterations
    end else if (iterations <= 0 || iterations > 1000) begin // Validate iteration count range
      $error("Error: Invalid ITERATIONS value (%0d). Must be between 1 and 1000.", iterations);
      $fatal(1, "Simulation terminated due to invalid command line argument."); // Terminate on invalid argument
    end

    // 3. Check for VERBOSE Flag (Optional Argument)
    if ($test$plusargs("VERBOSE")) begin
      $display("Verbose mode is enabled.");
    end

    $display("--- Simulation Configuration Summary ---");
    $display("Test Case: %s, Iterations: %0d, Verbose Mode: %s", test_name, iterations, ($test$plusargs("VERBOSE") ? "Enabled" : "Disabled"));
    // ... proceed with simulation ...
  end
endmodule
```

**Key Error Handling Practices:**

-   **Check `$value$plusargs` Return Value**: Verify the return value of `$value$plusargs` to determine if the argument was found. A return value of `0` indicates that the argument was not provided on the command line.
-   **Provide Default Values**: When an argument is optional, provide sensible default values within the SystemVerilog code to ensure the simulation can proceed even if the argument is missing.
-   **Validate Argument Values**: When arguments are expected to have specific formats or ranges, validate the extracted values after using `$value$plusargs`. Check for data type correctness, valid ranges, or allowed string values.
-   **Informative Error Messages**: If invalid or out-of-range argument values are detected, display informative error messages using `$error` or `$warning` to guide the user on correct argument usage.
-   **Terminate Simulation on Fatal Errors**: For critical command line arguments (e.g., required configuration parameters), use `$fatal` to terminate the simulation if invalid or missing arguments are encountered. This prevents simulations from running with incorrect configurations.
-   **Distinguish Warnings and Errors**: Use `$warning` for non-critical issues (e.g., using default values for optional arguments) and `$error` or `$fatal` for critical problems that may compromise simulation integrity.

## Best Practices Checklist for SystemVerilog Command Line Arguments

- **Use Descriptive Argument Names**: Choose meaningful names for command line arguments that clearly indicate their purpose and functionality.

- **Document Command Line Options**: Provide comprehensive documentation detailing each command line argument, its syntax, purpose, valid values, and default behavior.

- **Implement Default Values**: Set default values for parameters and configurations within the SystemVerilog code to ensure simulations can run without mandatory command line arguments.

- **Validate Argument Values**: Always validate the values retrieved from command line arguments to ensure they are within expected ranges and formats.

- **Provide Informative Error Messages**: Display clear and helpful error or warning messages when command line arguments are missing, invalid, or out of range.

- **Use `$value$plusargs` for Value Retrieval**: Utilize `$value$plusargs` to extract values associated with command line arguments using appropriate format specifiers.

- **Use `$test$plusargs` for Flag Arguments**: Employ `$test$plusargs` to efficiently check for the presence of flag arguments (boolean switches) on the command line.

- **Organize Arguments Logically**: Group related command line arguments and use consistent naming conventions to improve the organization and usability of command line options.

## Practical Exercises to Solidify Command Line Argument Skills

1.  **Parameterized DUT Simulation**:
    - Create a simple DUT module with parameters for data width and address width.
    - Instantiate this DUT in a testbench module.
    - Use command line arguments to override the `DATA_WIDTH` and `ADDR_WIDTH` parameters of the DUT instance.
    - Display the parameter values used in the DUT instance at the start of the simulation to verify the override.
    - Simulate with different values for `DATA_WIDTH` and `ADDR_WIDTH` provided via the command line.

2.  **Test Case Selection**:
    - Design a testbench with multiple test cases (e.g., `test_case_A`, `test_case_B`, `test_case_C`). Implement each test case as a separate task or function.
    - Use a command line argument `TESTCASE` to select which test case to run.
    - If no `TESTCASE` argument is provided, run a default test case (e.g., `test_case_A`).
    - Display the name of the test case being executed at the beginning of the simulation.
    - Run simulations with different `TESTCASE` arguments to execute specific test scenarios.

3.  **Verbosity Level Control**:
    - Implement different levels of verbosity in your testbench (e.g., `NONE`, `SUMMARY`, `DETAILED`, `DEBUG`).
    - Use a command line argument `VERBOSITY` to control the verbosity level.
    - Use `$value$plusargs` to retrieve the verbosity level from the command line.
    - Based on the verbosity level, control the amount of output generated by the testbench (e.g., using conditional `$display` statements).
    - Default verbosity level should be `SUMMARY` if no `VERBOSITY` argument is given.
    - Simulate with different `VERBOSITY` levels (e.g., `+VERBOSITY=NONE`, `+VERBOSITY=DETAILED`).

4.  **Configuration File Path from Command Line**:
    - Create a configuration file (e.g., `config.txt`) that contains simulation settings (e.g., clock period, timeout values).
    - Use a command line argument `CONFIG_FILE_PATH` to specify the path to the configuration file.
    - In your SystemVerilog testbench, use `$value$plusargs` to retrieve the configuration file path.
    - Open and read the configuration file using file operations (as learned in the previous chapter).
    - Parse the configuration parameters from the file and use them to configure the simulation environment.
    - Implement error handling for cases where the `CONFIG_FILE_PATH` is not provided or the file cannot be opened.

5.  **Argument Validation and Error Reporting**:
    - Extend Exercise 3 (Verbosity Level Control) to include robust argument validation.
    - Validate that the `VERBOSITY` argument, if provided, is one of the allowed values (`NONE`, `SUMMARY`, `DETAILED`, `DEBUG`).
    - If an invalid `VERBOSITY` value is provided, display an informative error message using `$error` and terminate the simulation using `$fatal`.
    - Ensure that the error message clearly indicates the allowed values for the `VERBOSITY` argument and guides the user on correct usage.

```SV
// Sample Solution for Exercise 2: Test Case Selection (Improved)
module test_case_selector;
  string test_case_name;

  initial begin
    if ($value$plusargs("TESTCASE=%s", test_case_name) == 0) begin
      $display("TESTCASE argument not provided. Running default test case 'test_case_A'.");
      run_test_case_A(); // Run default test case
    end else begin
      $display("TESTCASE argument provided: '%s'.", test_case_name);
      case (test_case_name)
        "test_case_A": run_test_case_A();
        "test_case_B": run_test_case_B();
        "test_case_C": run_test_case_C();
        default: begin
          $error("Error: Invalid TESTCASE '%s'. Allowed test cases are: test_case_A, test_case_B, test_case_C.", test_case_name);
          $fatal(1, "Simulation terminated due to invalid TESTCASE argument.");
        end
      endcase
    end
    $display("--- End of Test Case Execution ---");
  end

  task run_test_case_A();
    $display("--- Running Test Case A ---");
    #100ns;
    $display("Test Case A completed.");
  endtask : run_test_case_A

  task run_test_case_B();
    $display("--- Running Test Case B ---");
    #200ns;
    $display("Test Case B completed.");
  endtask : run_test_case_B

  task run_test_case_C();
    $display("--- Running Test Case C ---");
    #150ns;
    $display("Test Case C completed.");
  endtask : run_test_case_C

endmodule
```

##### Copyright (c) 2026 ChipVerge

