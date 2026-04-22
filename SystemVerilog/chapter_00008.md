# Control Flow in SystemVerilog: Directing Execution

## Introduction

Control flow statements are the traffic directors of SystemVerilog, determining the execution order of your code. They empower you to create dynamic and responsive designs and verification environments.  Mastering these constructs is essential for modeling complex hardware behavior, building sophisticated testbenches, and implementing algorithms within SystemVerilog.  Effective control flow leads to code that is not only functional but also readable, maintainable, and efficient for both simulation and hardware synthesis.

## Conditional Statements: Branching Logic

Conditional statements allow your SystemVerilog code to make decisions, executing different code blocks based on whether specific conditions are met.

### `if-else` Statements: Binary and Multi-way Decisions

The `if-else` statement is the cornerstone of conditional logic. It executes one block of code if a condition is true, and optionally another block if the condition is false.  `else if` clauses extend this to handle multiple, mutually exclusive conditions.

**Key Design and Style Points:**

-   **`else if` for Mutually Exclusive Choices**: Use `else if` to efficiently handle a series of conditions where only one branch should execute.
-   **Braces for Clarity**: While optional for single-line blocks following `if`, `else if`, and `else`, using `begin` and `end` braces consistently enhances readability and avoids potential errors when modifying code.

```SV
module if_else_example;
  parameter  THRESHOLD_HIGH = 50;
  parameter  THRESHOLD_MID  = 30;
  logic [7:0] data_value = 42;

  initial begin
    if (data_value > THRESHOLD_HIGH) begin
      $display("%0d: Data is HIGH (above %0d)", data_value, THRESHOLD_HIGH);
    end else if (data_value > THRESHOLD_MID) begin
      $display("%0d: Data is MEDIUM (between %0d and %0d)", data_value, THRESHOLD_MID + 1, THRESHOLD_HIGH); // Executes for data_value = 42
    end else begin
      $display("%0d: Data is LOW (at or below %0d)", data_value, THRESHOLD_MID);
    end
  end
endmodule
```

## Case Statements: Multi-Way Branching Based on Value

`case` statements provide a structured way to select one execution path from multiple possibilities, based on the value of an expression. SystemVerilog offers three main types of `case` statements, each with distinct matching behaviors.

### 1. `case`: Exact Value Matching

-   **Strict Equality**: The standard `case` statement performs exact value matching. It compares the case expression against each case item, and a match occurs only when they are identical bit-for-bit.
-   **`default` Case Essential**: Always include a `default` case in synthesizable `case` statements.  Omitting it can unintentionally create latches in hardware, as the synthesizer must infer behavior for non-matched cases.

```SV
module case_example;
  enum logic [2:0] { MONDAY=1, TUESDAY, WEDNESDAY, THURSDAY, FRIDAY, SATURDAY, SUNDAY, INVALID_DAY } day_e;
  day_e current_day = WEDNESDAY; // Assuming WEDNESDAY maps to 3'd3

  initial begin
    case (current_day)
      MONDAY:    $display("It's Monday");
      TUESDAY:   $display("It's Tuesday");
      WEDNESDAY: $display("It's Wednesday!"); // Matches: current_day is WEDNESDAY
      THURSDAY:  $display("It's Thursday");
      FRIDAY:    $display("It's Friday");
      SATURDAY:  $display("It's Saturday");
      SUNDAY:    $display("It's Sunday");
      default:   $display("Invalid day value!"); // Handles unexpected enum values
    endcase
  end
endmodule
```

### 2. `casez`: Don't-Care Matching for `z` and `?`

-   **'z' and '?' as Wildcards**: The `casez` statement treats `z` (high-impedance) and `?` as don't-care values in case items.  This is useful for pattern matching where certain bits are irrelevant.
-   **Verification and Protocol Decoding**:  `casez` is commonly used in verification for decoding instruction opcodes or protocol messages where some bits can be flexible.

```SV
module casez_example;
  logic [3:0] instruction_opcode = 4'b10xz; // 'x' and 'z' represent don't-cares

  initial begin
    casez (instruction_opcode)
      4'b1??1: $display("Instruction Type A (bits 3 and 0 are significant)"); // '?' matches 'x' or 'z'
      4'b10??: $display("Instruction Type B (bits 3 and 2 are significant)"); // Matches: opcode '10xz' fits '10??'
      default: $display("Unknown Instruction Type");
    endcase
  end
endmodule
```

### 3. `casex`: Extensive Don't-Care Matching (`x`, `z`, `?`)

-   **'x', 'z', and '?' as Wildcards**:  The `casex` statement extends don't-care matching to include `x` (unknown) in addition to `z` and `?`.
-   **Cautious RTL Use**: While flexible, `casex` should be used with caution in RTL design. Its aggressive wildcard matching can sometimes lead to unintended behavior in synthesis if not carefully managed.  It's more frequently used in verification for flexible pattern matching.

```SV
module casex_example;
  logic [3:0] status_flags = 4'b10x1; // 'x' represents an unknown flag state

  initial begin
    casex (status_flags)
      4'b101?: $display("Status Case 1: Priority handling (bit 2 and 0 are '1', bit 1 is don't-care)");
      4'b10x1: $display("Status Case 2: Direct match (bits 3, 2, and 0 are significant)"); // Exact match takes precedence over wildcards
      default: $display("Default Status Case: No specific pattern matched"); // Executes because Case 2 is a more specific match
    endcase
  end
endmodule
```

**Key `case` Statement Best Practices:**

-   **`unique case` for Single Match Enforcement**: Use `unique case` when you want to ensure that only one case branch is executed.  This can improve performance and catch potential design errors if multiple cases could unexpectedly match.
-   **`priority case` for Prioritized Branch Selection**: Use `priority case` when you need to prioritize case branches.  If multiple cases match, the first one in the code order will be executed.  This is important for implementing prioritized logic.
-   **`default` Case Always**: For synthesizable code, always include a `default` case to handle all possible input values and prevent unintended latch inference.

## Loop Constructs: Repetitive Operations

Loop constructs in SystemVerilog enable you to execute code blocks repeatedly, automating repetitive tasks in testbenches and, under certain constraints, in RTL designs.

### 1. `repeat` Loop: Fixed Iteration Count

-   **Predefined Iterations**: The `repeat` loop executes a block of code a fixed, predetermined number of times, specified at compile time.

```SV
module repeat_example;
  parameter NUM_REPEATS = 4;

  initial begin
    $display("Starting repeat loop...");
    repeat (NUM_REPEATS) begin
      $display("- Repeat iteration"); // Executes NUM_REPEATS times
    end
    $display("Repeat loop finished.");
  end
endmodule
```

### 2. `while` Loop: Condition-Based Iteration

-   **Condition-Controlled Execution**: The `while` loop continues to execute its code block as long as a specified condition remains true.

```SV
module while_example;
  integer counter = 0;
  parameter LIMIT = 5;

  initial begin
    $display("Starting while loop...");
    while (counter < LIMIT) begin
      $display("- While loop count: %0d", counter);
      counter++; // Increment counter to eventually exit loop
    end
    $display("While loop finished.");
  end
endmodule
```

### 3. `for` Loop: Compact Iteration with Initialization, Condition, Increment

-   **Combined Loop Control**: The `for` loop provides a concise syntax for loop control, combining initialization, a loop condition, and an increment/decrement step in a single statement.

```SV
module for_example;
  parameter ITERATIONS = 3;

  initial begin
    $display("Starting for loop...");
    for (integer i = 0; i < ITERATIONS; i++) begin // Loop variable 'i' scoped to loop
      $display("- For loop iteration i = %0d", i);
    end
    $display("For loop finished.");
  end
endmodule
```

### 4. `foreach` Loop: Array Element Iteration

-   **Simplified Array Traversal**: The `foreach` loop is specifically designed to iterate over the elements of an array, simplifying array processing.

**Syntax**: `foreach (array_name[index_variable]) begin ... end`

```SV
module foreach_example;
  integer data_values[5] = '{15, 25, 35, 45, 55};

  initial begin
    $display("Iterating with foreach loop:");
    foreach (data_values[index]) begin // 'index' automatically iterates through array indices
      $display("- data_values[%0d] = %0d", index, data_values[index]);
    end
    $display("Foreach loop finished.");
  end
endmodule
```

### 5. `forever` Loop: Continuous Execution (Testbenches)

-   **Infinite Loop**: The `forever` loop executes its code block indefinitely, creating an infinite loop.  It is primarily used in testbenches to generate continuous stimuli or to model systems that run continuously.
-   **Timing Control and Exit Mechanisms**:  **Crucially, always include a timing control (`#delay`) or a loop exit mechanism (like `disable`) within a `forever` loop to prevent simulation from hanging indefinitely.**

```SV
module forever_example;
  initial begin : forever_block // Named block for disabling
    integer cycle_count = 0;
    $display("Starting forever loop (simulating clock)...");
    forever begin
      $display("- Cycle %0d", cycle_count);
      cycle_count++;
      #10; // Simulate clock period - Delay for 10 time units
      if (cycle_count >= 5) disable forever_block; // Exit loop after 5 cycles
    end
    $display("Forever loop disabled after 5 cycles.");
  end
endmodule
```

**Looping Best Practices for RTL and Verification:**

-   **RTL Loops - Static Bounds for Synthesis**: When using loops in RTL designs (within `always` blocks for sequential logic), ensure that loop bounds are statically determinable at compile time (e.g., using parameters or constants).  Synthesizers typically unroll loops with static bounds into combinational or sequential logic.
-   **Avoid Infinite Loops in RTL Synthesis**:  Do not use `forever` loops or `while(1)` loops directly in synthesizable RTL code, as they represent infinite processes and cannot be directly implemented in hardware.  Use them carefully for initialization or specific modeling scenarios if supported by your synthesis tool.
-   **`forever` Loops in Testbenches - Timing is Key**:  `forever` loops are invaluable in testbenches for tasks like clock generation, continuous monitoring, and stimulus generation.  Always incorporate delays (`#`) to control simulation time and prevent runaway simulations. Use `disable` statements or event-based control to terminate `forever` loops in testbenches when needed.

## Exercises to Solidify Control Flow Understanding

1.  **Number Classifier (`if-else`)**: Write a module that takes an integer input and uses `if-else` statements to classify it as "Positive," "Negative," or "Zero," displaying the classification.
2.  **Weekday Name (`case`)**: Implement a module that takes a number from 1 to 7 as input and uses a `case` statement to output the corresponding weekday name (1=Monday, 2=Tuesday, etc.). Include a `default` case for invalid inputs.
3.  **`repeat` Loop Counter**: Create a module using a `repeat` loop to display numbers from 1 to a parameterized limit (e.g., `parameter LIMIT = 7;`).
4.  **Array Traversal (`while` Loop)**: Write a module that initializes an integer array and uses a `while` loop to iterate through the array, displaying each element's value and index.
5.  **Factorial Calculation (`for` Loop)**: Implement a module that calculates the factorial of a parameterized non-negative integer input using a `for` loop and displays the result.
6.  **Array Summation (`foreach` Loop)**: Write a module that initializes an integer array and uses a `foreach` loop to calculate and display the sum of all elements in the array.
7.  **Controlled Clock Generator (`forever` Loop)**: Create a testbench module that uses a `forever` loop with a `#delay` to simulate a clock signal.  Have the simulation run for a fixed number of clock cycles (e.g., 20 cycles) and then terminate using `disable`. Display the cycle count in each iteration.

By practicing with these exercises and understanding the nuances of each control flow statement, you'll gain the proficiency to write effective and well-structured SystemVerilog code for a wide range of hardware design and verification tasks.

##### Copyright (c) 2026 ChipVerge

