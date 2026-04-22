# SystemVerilog Built-in System Tasks and Functions

SystemVerilog provides a rich set of built-in system tasks and functions, identifiable by the '$' prefix. These constructs offer essential capabilities for simulation control, data manipulation, querying information, mathematical operations, assertion handling, coverage, file I/O, and much more, significantly enhancing the power and flexibility of the language for RTL design and verification.

Below is a categorized list of common SystemVerilog system tasks and functions:

## Simulation Control Tasks
These tasks are used to control the execution flow of a simulation.
### `$finish`

**Description:**

The `$finish` task is used to terminate a simulation. When `$finish` is called, the simulator typically cleans up resources, closes files opened with `$fopen`, and then exits. You can optionally provide an argument to specify the level of reporting before exiting.

-   `$finish;` or `$finish(0);`: Terminates simulation with no additional messages.
-   `$finish(1);`: Terminates simulation and prints the simulation time and location.
-   `$finish(2);`: Terminates simulation and prints the simulation time, location, and statistics about memory and CPU usage.

It is the most commonly used task for ending a simulation gracefully.

**Example:**

```SV
module finish_example;

  initial begin
    $display("Simulation started at time %0t", $time);

    #100; // Wait for 100 time units
    $display("Simulation reached 100 time units.");

    #50;  // Wait for another 50 time units
    $display("Simulation reached 150 time units. Calling $finish.");

    $finish(2); // Terminate simulation and report statistics
  end

  initial begin
      // Another process running in parallel
      #200;
      $display("This message might not be printed if $finish is called earlier.");
  end

endmodule
```

**Explanation:**

This example shows a simple module with an `initial` block. The simulation starts, prints a message, waits for 100 time units, prints another message, waits for another 50 time units (total 150), prints a final message, and then calls `$finish(2)`. The simulation will terminate at 150 time units. The second `initial` block, which waits for 200 time units, will not complete because the simulation finishes before that time.

### `$stop`

**Description:**

The `$stop` task pauses the simulation and leaves the simulator in an interactive mode (if supported by the simulator). This allows the user to examine signal values, set breakpoints, and continue the simulation manually. It's particularly useful for debugging. Similar to `$finish`, you can provide an optional argument to control reporting.

-   `$stop;` or `$stop(0);`: Pauses simulation with no additional messages.
-   `$stop(1);`: Pauses simulation and prints the simulation time and location.
-   `$stop(2);`: Pauses simulation and prints the simulation time, location, and statistics.

**Example:**

```SV
module stop_example;

  reg [7:0] data = 8'hAA;

  initial begin
    $display("Simulation started at time %0t", $time);

    #50; // Wait for 50 time units
    $display("Simulation reached 50 time units. Current data = %h", data);
    $display("Calling $stop. Simulation will pause here.");

    $stop(1); // Pause simulation and report location

    // The lines below will execute only if simulation is continued
    #50;
    data = 8'h55;
    $display("Simulation continued. Reached 100 time units. New data = %h", data);

    #50;
    $finish; // Eventually finish the simulation
  end

endmodule
```

**Explanation:**

In this example, the simulation starts, prints messages, waits for 50 time units, prints the current value of `data`, and then calls `$stop(1)`. The simulation will pause at this point. You would then interact with your simulator to inspect values, perhaps change them, and issue a command to continue (e.g., `run` in many simulators). If you continue, the simulation proceeds to the next `#50` delay, updates `data`, prints another message, waits again, and finally calls `$finish` to terminate.

### `$exit`

**Description:**

The `$exit` task is a more abrupt way to terminate simulation compared to `$finish`. It typically terminates the simulation immediately, bypassing the normal simulation cleanup procedures. This can be useful in specific scenarios, but generally `$finish` is preferred for a clean shutdown. You can provide an optional integer argument as an exit code for the simulation process.

-   `$exit;` or `$exit(0);`: Terminates simulation immediately with an exit code of 0 (indicating success).
-   `$exit(code);`: Terminates simulation immediately with the specified exit code.

**Example:**

```SV
module exit_example;

  parameter MAX_CYCLES = 100;
  integer cycle_count = 0;
  logic clk = 0;

  initial begin
    $display("Simulation started at time %0t", $time);

    // Simulate some clock cycles
    repeat (MAX_CYCLES) begin
      #10 clk = ~clk;
      cycle_count++;
      $display("Cycle %0d at time %0t", cycle_count, $time);

      if (cycle_count == 50) begin
        $display("Reached 50 cycles. Calling $exit.");
        $exit(1); // Terminate immediately with exit code 1
      end
    end

    // This line will not be reached because $exit is called at cycle 50
    $display("Simulation completed %0d cycles.", MAX_CYCLES);
    $finish;
  end

endmodule
```

**Explanation:**

This example simulates a clock and increments a `cycle_count`. When the `cycle_count` reaches 50, the code prints a message and calls `$exit(1)`. The simulation terminates immediately at that point, and the operating system process running the simulation will exit with a status code of 1. The code after the `if` block will not be executed. Using `$exit` means normal simulation shutdown procedures might be skipped, so use it cautiously.

## Simulation Time Functions
Functions to retrieve the current simulation time in various formats.
### `$realtime`

**Description:**

The `$realtime` function returns the current simulation time as a `real` number. The value is scaled to the simulation's *time unit* as defined by the `timescale` directive. This function provides the most precise representation of the current simulation time, including fractional parts if the precision is finer than the time unit.

**Return Type:** `real`

### `$stime`

**Description:**

The `$stime` function returns the current simulation time as a 32-bit unsigned integer. The value is scaled to the simulation's *time unit* as defined by the `timescale` directive. Any fractional part of the time is truncated.

**Return Type:** `unsigned integer` (specifically, the least significant 32 bits)

### `$time`

**Description:**

The `$time` function returns the current simulation time as a 32-bit unsigned integer. This is where it differs from `$realtime` and `$stime`. The value returned by `$time` is scaled *up* to the reference time unit specified in the `timescale` directive (e.g., the '1ns' part in `` `timescale 1ns / 1ps``). If no `timescale` is specified, a default timescale applies (which is simulator-dependent, often 1s / 1s). Similar to `$stime`, any fractional part after scaling is truncated, and the value is limited to the least significant 32 bits.

**Return Type:** `unsigned integer` (specifically, the least significant 32 bits)

**Example Demonstrating `$realtime`, `$stime`, and `$time`**

```SV
`timescale 1ns / 1ps

module time_functions_example;

  initial begin
    $display("Timescale set to 1ns / 1ps");
    $display("---------------------------");

    $display("Time 0:");
    $display("  $realtime: %f", $realtime);
    $display("  $stime:    %0d", $stime);
    $display("  $time:     %0d", $time); // Scaled to 1ns

    #10; // Delay of 10 time units (10ns)
    $display("\nTime after #10 (10ns):");
    $display("  $realtime: %f", $realtime);
    $display("  $stime:    %0d", $stime);
    $display("  $time:     %0d", $time); // Scaled to 1ns

    #0.5; // Delay of 0.5 time units (0.5ns, or 500ps) - requires precision <= time unit
    $display("\nTime after #0.5 (0.5ns):");
    $display("  $realtime: %f", $realtime);
    $display("  $stime:    %0d", $stime);
    $display("  $time:     %0d", $time); // Scaled to 1ns

    #100ps; // Delay of 100 precision units (0.1ns)
    $display("\nTime after #100ps (0.1ns):");
    $display("  $realtime: %f", $realtime);
    $display("  $stime:    %0d", $stime);
    $display("  $time:     %0d", $time); // Scaled to 1ns

    $finish;
  end

endmodule
```

**Explanation:**

With `` `timescale 1ns / 1ps``:

* **`$realtime`**: Returns the time in nanoseconds (the time unit) as a real number, including the precision.
    * At time 0: `0.000000`
    * After `#10`: `10.000000` (10ns)
    * After `#0.5`: `10.500000` (10.5ns)
    * After `#100ps`: `10.600000` (10.5ns + 0.1ns = 10.6ns)

* **`$stime`**: Returns the time in nanoseconds (the time unit) as an integer, truncated.
    * At time 0: `0`
    * After `#10`: `10` (10ns)
    * After `#0.5`: `10` (10.5ns truncated to 10)
    * After `#100ps`: `10` (10.6ns truncated to 10)

* **`$time`**: Returns the time scaled up to the reference unit (1ns in this case) as an integer, truncated. Since the time unit is already 1ns, `$time` behaves the same as `$stime` in this specific example.
    * At time 0: `0`
    * After `#10`: `10` (10ns scaled to 1ns is 10)
    * After `#0.5`: `10` (10.5ns scaled to 1ns is 10.5, truncated to 10)
    * After `#100ps`: `10` (10.6ns scaled to 1ns is 10.6, truncated to 10)

**Consider what would happen if the timescale was different, e.g., `` `timescale 1us / 1ns``:**

* A delay of `#10` would be 10 microseconds.
* `$realtime` would return the time in microseconds (e.g., `10.0` after `#10`).
* `$stime` would return the time in microseconds (e.g., `10` after `#10`).
* `$time` would return the time scaled to 1 microsecond (the reference unit). So after `#10us`, `$time` would return `10`. If you had a delay of `#1.5us`, `$time` would return `1`. If you had a delay of `#500ns`, `$time` would return `0` (since 500ns scaled to 1us is 0.5, truncated).

This illustrates the key difference: `$realtime` and `$stime` scale to the time unit, while `$time` scales to the reference time unit. `$realtime` provides floating-point precision, while `$stime` and `$time` provide integer values.

## Timescale Tasks
Tasks related to querying or setting timescale information.
### `$printtimescale`

**Description:**

The `$printtimescale` task is used to display the timescale and time precision in effect for a specific module or for the current scope. It helps verify the active timescale settings during simulation.

**Usage:**

-   `$printtimescale;`: Prints the timescale for the current module (the module where `$printtimescale` is called).
-   `$printtimescale(hierarchical_name);`: Prints the timescale for the module or instance specified by the `hierarchical_name`.

**Example:**

```SV
`timescale 10ns / 1ns

module module_a;
  initial begin
    $display("Inside module_a:");
    $printtimescale; // Print timescale for module_a
  end
endmodule

`timescale 1us / 100ps

module module_b;
  initial begin
    $display("Inside module_b:");
    $printtimescale; // Print timescale for module_b
  end
endmodule

module top;
  module_a instance_a();
  module_b instance_b();

  initial begin
    $display("Inside top module:");
    $printtimescale; // Print timescale for top

    $display("\nChecking timescales of instances:");
    $printtimescale(instance_a); // Print timescale for instance_a
    $printtimescale(top.instance_b); // Print timescale for instance_b using hierarchical path
  end
endmodule
```

**Explanation:**

This example defines three modules with different `timescale` directives. The `top` module instantiates `module_a` and `module_b`. The `initial` block in `top` calls `$printtimescale` for itself and then uses hierarchical names to call it for the instances `instance_a` and `instance_b`.

When simulated, the output will show the respective timescales:
-   For `top` and `instance_a` (which inherits from `module_a`): likely `10ns / 1ns`
-   For `instance_b` (which inherits from `module_b`): likely `1us / 100ps`

This helps confirm that the correct timescale is applied to each part of the design hierarchy.

### `$timeformat`

**Description:**

The `$timeformat` task controls how time values are displayed by the standard display tasks like `$display`, `$write`, `$monitor`, `$strobe`, and their file-based counterparts (`$fdisplay`, etc.). It allows you to specify the time units, the number of decimal places (precision), a suffix string (like "ns", "us"), and the minimum field width for printing time.

**Usage:**

`$timeformat(units, precision, suffix, minimum_field_width);`

-   `units`: An integer specifying the time units for display (e.g., -12 for ps, -9 for ns, -6 for us, -3 for ms, 0 for s). You can also use constants defined in the `uvm_pkg` like `UVM_FS`, `UVM_PS`, etc.
-   `precision`: An integer specifying the number of decimal places to display (0 or greater).
-   `suffix`: A string to be appended to the time value (e.g., " ns", " us"). Use `""` for no suffix.
-   `minimum_field_width`: An integer specifying the minimum width of the field for printing the time value. Useful for aligning output. Use 0 for no minimum width.

A call to `$timeformat` affects subsequent display task calls in the current scope or module.

**Example:**

```SV
`timescale 1us / 100ns

module time_format_example;

  initial begin
    $display("Current time scale: %0t", $time); // Use %0t to print time

    // Set time format to display in nanoseconds with 0 decimal places
    $timeformat(-9, 0, " ns", 10); // -9 for ns, 0 precision, " ns" suffix, 10 field width
    $display("After setting format 1:");
    #1.23; // Delay of 1.23 us = 1230 ns
    $display("Time at #1.23: %0t", $time); // Should print 1230 ns

    // Set time format to display in microseconds with 2 decimal places
    $timeformat(-6, 2, " us", 8); // -6 for us, 2 precision, " us" suffix, 8 field width
    $display("After setting format 2:");
    #0.5; // Delay of 0.5 us = 500 ns
    $display("Time after #0.5: %0t", $time); // Should print 1.73 us (1.23 + 0.5)

    // Set time format to display in picoseconds with 0 decimal places and no suffix
    $timeformat(-12, 0, "", 0); // -12 for ps, 0 precision, no suffix, no min width
    $display("After setting format 3:");
    #0.0001; // Delay of 0.0001 us = 100 ps
    $display("Time after #0.0001: %0t", $time); // Should print 1730100 ps (1.73 us = 1730000 ps + 100 ps)

    $finish;
  end

endmodule
```

**Explanation:**

The example starts with a timescale of 1us / 100ns. It then uses `$timeformat` multiple times to change how `$display` (specifically using the `%0t` format specifier for time) prints the simulation time.

-   Initially, `%0t` prints the time scaled to the reference unit (1 us), which might show unexpected results without a custom format.
-   The first `$timeformat` sets the display to nanoseconds (`-9`) with 0 decimal places and " ns" suffix, right-aligned in a field of 10.
-   The second `$timeformat` sets the display to microseconds (`-6`) with 2 decimal places and " us" suffix, right-aligned in a field of 8.
-   The third `$timeformat` sets the display to picoseconds (`-12`) with 0 decimal places and no suffix or minimum width.

The output clearly demonstrates how `$timeformat` controls the appearance of time in display messages, making simulation logs more readable and interpretable according to the desired time units.

## Conversion Functions
Functions for converting between different data types, such as real to bits and vice-versa, or signed/unsigned conversions.
### `$bitstoreal` and `$realtobits`

**Descriptions:**

-   `$bitstoreal(expression)`: This function interprets the bit pattern of a 64-bit expression as an IEEE 754 double-precision floating-point number and returns its equivalent `real` value. The input expression must be 64 bits wide.
-   `$realtobits(expression)`: This function takes a `real` number and returns its 64-bit representation as an IEEE 754 double-precision floating-point bit pattern.

**Example:**

```SV
module real_bits_conversion;

  real my_real_value = 3.14159;
  bit [63:0] real_bit_pattern;
  real converted_back_real;

  initial begin
    $display("Original real value: %f", my_real_value);

    // Convert real to its 64-bit bit pattern
    real_bit_pattern = $realtobits(my_real_value);
    $display("64-bit pattern (hex): %h", real_bit_pattern);
    $display("64-bit pattern (binary): %b", real_bit_pattern);

    // Convert the bit pattern back to real
    converted_back_real = $bitstoreal(real_bit_pattern);
    $display("Converted back real value: %f", converted_back_real);

    $finish;
  end

endmodule
```

**Explanation:**

The example demonstrates converting a `real` number (pi) into its 64-bit binary representation using `$realtobits`. It then takes that 64-bit pattern and converts it back into a `real` number using `$bitstoreal`. The output will show the original value, its hexadecimal and binary bit pattern according to IEEE 754 standard, and the value recovered from the bit pattern, which should match the original.

### `$bitstoshortreal` and `$shortrealtobits`

**Descriptions:**

-   `$bitstoshortreal(expression)`: Similar to `$bitstoreal`, but interprets a 32-bit expression as an IEEE 754 single-precision floating-point number and returns its `shortreal` value. The input expression must be 32 bits wide.
-   `$shortrealtobits(expression)`: Takes a `shortreal` number and returns its 32-bit representation as an IEEE 754 single-precision floating-point bit pattern.

**Example:**

```SV
module shortreal_bits_conversion;

  shortreal my_shortreal_value = 2.718f; // 'f' suffix for shortreal literal
  bit [31:0] shortreal_bit_pattern;
  shortreal converted_back_shortreal;

  initial begin
    $display("Original shortreal value: %f", my_shortreal_value);

    // Convert shortreal to its 32-bit bit pattern
    shortreal_bit_pattern = $shortrealtobits(my_shortreal_value);
    $display("32-bit pattern (hex): %h", shortreal_bit_pattern);
    $display("32-bit pattern (binary): %b", shortreal_bit_pattern);

    // Convert the bit pattern back to shortreal
    converted_back_shortreal = $bitstoshortreal(shortreal_bit_pattern);
    $display("Converted back shortreal value: %f", converted_back_shortreal);

    $finish;
  end

endmodule
```

**Explanation:**

This example is analogous to the `$bitstoreal`/`$realtobits` example but uses `shortreal` (single-precision) values, which are represented by 32 bits. It converts a `shortreal` value to its 32-bit pattern and back.

### `$itor` and `$rtoi`

**Descriptions:**

-   `$itor(expression)`: Converts an integer expression (e.g., `int`, `integer`, `logic`, `bit`) to a `real` value.
-   `$rtoi(expression)`: Converts a `real` or `shortreal` expression to an integer. The fractional part of the floating-point number is typically truncated (rounded towards zero).

**Example:**

```SV
module int_real_conversion;

  integer my_integer = 123;
  real my_real = 456.789;
  real integer_as_real;
  integer real_as_integer;

  initial begin
    $display("Original integer: %0d", my_integer);
    $display("Original real: %f", my_real);

    // Convert integer to real
    integer_as_real = $itor(my_integer);
    $display("Integer as real: %f", integer_as_real);

    // Convert real to integer (truncation)
    real_as_integer = $rtoi(my_real);
    $display("Real as integer (truncated): %0d", real_as_integer);

    $finish;
  end

endmodule
```

**Explanation:**

This example shows how `$itor` converts the integer `123` into the real value `123.0`. It also shows how `$rtoi` converts the real value `456.789` into the integer `456` by truncating the fractional part.

### `$signed` and `$unsigned`

**Descriptions:**

-   `$signed(expression)`: Treats the given expression as a signed value for the purpose of the current operation or assignment. This is useful when you need to ensure that operations on bit vectors are performed using signed arithmetic. The size of the expression is preserved.
-   `$unsigned(expression)`: Treats the given expression as an unsigned value for the purpose of the current operation or assignment. This is useful when you need to ensure that operations on bit vectors are performed using unsigned arithmetic. The size of the expression is preserved.

**Example:**

```SV
module signed_unsigned_example;

  logic [7:0] byte_data = 8'hFF; // Represents 255 unsigned or -1 signed

  initial begin
    $display("Original byte_data (unsigned): %0d", byte_data);
    $display("Original byte_data (signed view): %0d", $signed(byte_data));

    // Perform signed addition
    $display("Signed addition: $signed(byte_data) + 1 = %0d", $signed(byte_data) + 1);

    // Perform unsigned addition
    $display("Unsigned addition: $unsigned(byte_data) + 1 = %0d", $unsigned(byte_data) + 1);

    // Assignment where signed/unsigned matters
    integer signed_int = $signed(byte_data);
    integer unsigned_int = $unsigned(byte_data);

    $display("Assigned to signed integer: %0d", signed_int);
    $display("Assigned to unsigned integer: %0d", unsigned_int);

    $finish;
  end

endmodule
```

**Explanation:**

The `logic [7:0]` variable `byte_data` holds the bit pattern `8'hFF`. When treated as unsigned, this is 255. When treated as a signed 8-bit value (using two's complement), it's -1.

-   `$signed(byte_data)` explicitly tells the simulator to interpret `byte_data` as signed, resulting in -1.
-   `$unsigned(byte_data)` explicitly tells the simulator to interpret `byte_data` as unsigned, resulting in 255.
-   The addition examples show how the explicit `$signed` or `$unsigned` cast affects the arithmetic operation result.
-   Assigning to signed/unsigned integers also demonstrates the effect of the cast during assignment, where the value is sign-extended or zero-extended based on the cast and the destination type.

### `$cast`

**Description:**

The `$cast` system function attempts to convert a source expression or handle to a specified target type. It performs a dynamic cast, meaning the conversion is checked at runtime. If the conversion is successful, it returns 1; otherwise, it returns 0. The converted value is assigned to the variable provided as the first argument. `$cast` is frequently used for casting object handles in object-oriented SystemVerilog (like UVM), but it can also be used for value casting between compatible scalar or aggregate types.

**Usage:**

`$cast(target_variable, source_expression);`

**Example (Value Casting):**

```SV
module cast_example;

  real r_val = 123.45;
  integer i_val;
  shortreal sr_val;

  initial begin
    $display("Original real value: %f", r_val);

    // Attempt to cast real to integer
    if ($cast(i_val, r_val)) begin
      $display("Successfully cast real to integer: %0d", i_val); // Truncates
    end else begin
      $display("Failed to cast real to integer.");
    end

    $display("Original shortreal value: %f", 25.67f); // Using literal

    // Attempt to cast shortreal literal to real
    if ($cast(r_val, 25.67f)) begin
        $display("Successfully cast shortreal literal to real: %f", r_val);
    end else begin
        $display("Failed to cast shortreal literal to real.");
    end

    $finish;
  end

endmodule
```

**Explanation:**

This example shows `$cast` used for value conversion:

-   It attempts to cast a `real` value (`r_val`) to an `integer` (`i_val`). This is a valid conversion for scalar types, and `$cast` will succeed, assigning the truncated integer value (123) to `i_val`.
-   It attempts to cast a `shortreal` literal (`25.67f`) to a `real` variable (`r_val`). This is also a valid scalar conversion and will succeed, assigning the `shortreal` value converted to `real` format to `r_val`.

While explicit conversions like `$rtoi` are often used for simple scalar conversions, `$cast` provides a more general mechanism, especially powerful for polymorphic object handle assignments where the type is determined at runtime.

## Data Query Functions
Functions used to query information about data types and variables.
### `$bits`

**Description:**

The `$bits` function returns the total number of bits required to store a given data type or expression. For packed data types and arrays, it returns the total number of bits in the packed representation. For unpacked arrays or structures, it returns the total number of bits across all its packed and unpacked members.

**Usage:**

`$bits(data_type_or_expression)`

**Example:**

```SV
module bits_example;

  logic my_bit;
  logic [7:0] my_byte;
  int my_int;
  real my_real;
  enum {RED, GREEN, BLUE} my_enum;

  logic [3:0][7:0] packed_array; // Packed dimensions [3:0], unpacked [7:0] is illegal syntax, should be logic [3:0][7:0] packed;
                                // Correct packed multi-dim array: logic [3:0][7:0] packed_multidim;
                                // Let's use a correct example for packed/unpacked

  logic [7:0] unpacked_array [0:2]; // Unpacked dimension [0:2]
  struct packed {
    logic [1:0] opcode;
    logic [7:0] data;
  } packed_struct;

  struct { // Unpacked struct
    int id;
    logic [15:0] value;
  } unpacked_struct;


  initial begin
    $display("Size of my_bit: %0d bits", $bits(my_bit));
    $display("Size of logic: %0d bits", $bits(logic)); // Can query types directly
    $display("Size of my_byte: %0d bits", $bits(my_byte));
    $display("Size of logic [7:0]: %0d bits", $bits(logic [7:0]));
    $display("Size of my_int: %0d bits", $bits(my_int));
    $display("Size of int: %0d bits", $bits(int));
    $display("Size of my_real: %0d bits", $bits(my_real)); // real is typically 64 bits
    $display("Size of real: %0d bits", $bits(real));
    $display("Size of my_enum: %0d bits", $bits(my_enum)); // Size determined by value range
    $display("Size of enum {RED, GREEN, BLUE}: %0d bits", $bits(enum {RED, GREEN, BLUE}));

    $display("Size of packed_array logic [3:0][7:0]: %0d bits", $bits(logic [3:0][7:0])); // 4 * 8 = 32
    $display("Size of unpacked_array logic [7:0] [0:2]: %0d bits", $bits(logic [7:0] [0:2])); // (8 bits per element) * 3 elements = 24 bits (total storage)

    $display("Size of packed_struct: %0d bits", $bits(packed_struct)); // 2 + 8 = 10
    $display("Size of unpacked_struct: %0d bits", $bits(unpacked_struct)); // Size of int (32) + Size of logic [15:0] (16) = 48 bits
                                                                        // $bits for unpacked struct sums bits of members

    $finish;
  end

endmodule
```

**Explanation:**

The example shows how `$bits` reports the total number of bits for various data types:
-   Single bit (`logic`): 1
-   Vector (`logic [7:0]`): 8
-   Built-in integer type (`int`): typically 32
-   Floating-point type (`real`): typically 64
-   Enumeration: The size is determined by the minimum number of bits needed to represent the range of enumeration values. In this case, 3 values (0, 1, 2) need 2 bits.
-   Packed multi-dimensional array (`logic [3:0][7:0]`): 4 * 8 = 32 bits.
-   Unpacked array (`logic [7:0] [0:2]`): 3 elements * 8 bits/element = 24 bits. `$bits` on an unpacked array gives the total bits of all elements.
-   Packed struct: Sum of the bits of its members (2 + 8 = 10).
-   Unpacked struct: Sum of the bits of its members (Size of int + 16).

### `$isunbounded`

**Description:**

The `$isunbounded` function returns a boolean value (1 for true, 0 for false) indicating whether a data type is considered "unbounded". Unbounded data types are those whose size is not fixed by the type declaration itself but can vary based on the value assigned (though typically they have a minimum guaranteed range). In SystemVerilog, this primarily refers to `int`, `integer`, `longint`, `byte`, `shortint`, `real`, and `shortreal`. Sized vectors like `logic [7:0]` are *not* unbounded.

**Usage:**

`$isunbounded(data_type)`

**Example:**

```SV
module isunbounded_example;

  initial begin
    $display("Is int unbounded? %0d", $isunbounded(int));
    $display("Is integer unbounded? %0d", $isunbounded(integer));
    $display("Is longint unbounded? %0d", $isunbounded(longint));
    $display("Is byte unbounded? %0d", $isunbounded(byte));
    $display("Is shortint unbounded? %0d", $isunbounded(shortint));
    $display("Is real unbounded? %0d", $isunbounded(real));
    $display("Is shortreal unbounded? %0d", $isunbounded(shortreal));

    $display("Is logic [7:0] unbounded? %0d", $isunbounded(logic [7:0]));
    $display("Is bit unbounded? %0d", $isunbounded(bit));
    $display("Is enum {A, B} unbounded? %0d", $isunbounded(enum {A, B}));
    $display("Is struct {int i;} unbounded? %0d", $isunbounded(struct {int i;}));
    $display("Is unpacked array int [0:1] unbounded? %0d", $isunbounded(int [0:1]));


    $finish;
  end

endmodule
```

**Explanation:**

The example queries whether various data types are unbounded using `$isunbounded`. The output will show:
-   1 for `int`, `integer`, `longint`, `byte`, `shortint`, `real`, and `shortreal`.
-   0 for sized types like `logic [7:0]`, `bit`, enums, structs, and arrays, as their size is defined by the declaration.

### `$typename`

**Description:**

The `$typename` function returns a string containing the name of the data type of a given expression or type. This is helpful for debugging or for printing information about the types of variables.

**Usage:**

`$typename(data_type_or_expression)`

**Example:**

```SV
module typename_example;

  logic [15:0] address;
  integer count = 0;
  string name = "test_string";
  real temperature;
  enum {IDLE, RUNNING} state = IDLE;

  typedef struct packed {
    logic valid;
    logic [31:0] data;
  } packet_t;

  packet_t my_packet;
  packet_t packet_array [0:3];

  initial begin
    $display("Type of address: %s", $typename(address));
    $display("Type of count: %s", $typename(count));
    $display("Type of name: %s", $typename(name));
    $display("Type of temperature: %s", $typename(temperature));
    $display("Type of state: %s", $typename(state));
    $display("Type of the state enum: %s", $typename(enum {IDLE, RUNNING}));

    $display("Type of my_packet: %s", $typename(my_packet));
    $display("Type of packet_t: %s", $typename(packet_t)); // Can query typedefs
    $display("Type of packet_array: %s", $typename(packet_array));

    $finish;
  end

endmodule
```

**Explanation:**

This example uses `$typename` to print the type name of various variables and a typedef. The output will be strings corresponding to the SystemVerilog type names:

-   `logic [15:0]`
-   `integer`
-   `string`
-   `real`
-   The name of the enum type (might be internal or based on definition)
-   The name of the enum type itself
-   The name of the `packet_t` struct type
-   The name of the `packet_t` typedef
-   The type name including the unpacked dimension for the array (e.g., `packet_t [0:3]`)

This function is valuable for introspection and dynamic behavior based on data types.

## Array Query Functions
Functions to obtain information about arrays, including dimensions, bounds, and size.
Consider the following SystemVerilog array declarations to illustrate these functions:

```SV
module array_query_example;

  // 1D Packed array (vector)
  logic [7:0] packed_vec;

  // 1D Unpacked array
  int unpacked_arr [0:9];

  // 1D Unpacked array with descending index
  real descending_arr [99:10];

  // 2D Packed array
  logic [3:0][7:0] packed_2d; // [3:0] is dimension 0, [7:0] is dimension 1

  // 2D Unpacked array
  byte unpacked_2d [0:4][0:9]; // [0:4] is dimension 0, [0:9] is dimension 1

  // Mixed Packed/Unpacked array
  bit [1:0] mixed_array [0:2][3:4]; // [0:2] is unpacked dim 0, [3:4] is unpacked dim 1
                                   // [1:0] is packed dim 0

  initial begin
    $display("--- packed_vec (logic [7:0]) ---");
    $display("$unpacked_dimensions: %0d", $unpacked_dimensions(packed_vec)); // A vector is packed
    $display("$dimensions:          %0d", $dimensions(packed_vec)); // One packed dimension
    $display("$left(1):             %0d", $left(packed_vec, 1)); // Left bound of the 1st (only) packed dim
    $display("$right(1):            %0d", $right(packed_vec, 1)); // Right bound of the 1st (only) packed dim
    $display("$low(1):              %0d", $low(packed_vec, 1)); // Lower bound (min)
    $display("$high(1):             %0d", $high(packed_vec, 1)); // Upper bound (max)
    $display("$increment(1):        %0d", $increment(packed_vec, 1)); // Direction
    $display("$size(1):             %0d", $size(packed_vec, 1)); // Size of the dimension

    $display("\n--- unpacked_arr (int [0:9]) ---");
    $display("$unpacked_dimensions: %0d", $unpacked_dimensions(unpacked_arr)); // One unpacked dimension
    $display("$dimensions:          %0d", $dimensions(unpacked_arr)); // One unpacked dimension
    $display("$left(1):             %0d", $left(unpacked_arr, 1)); // Left bound of the 1st (only) unpacked dim
    $display("$right(1):            %0d", $right(unpacked_arr, 1)); // Right bound of the 1st (only) unpacked dim
    $display("$low(1):              %0d", $low(unpacked_arr, 1)); // Lower bound (min)
    $display("$high(1):             %0d", $high(unpacked_arr, 1)); // Upper bound (max)
    $display("$increment(1):        %0d", $increment(unpacked_arr, 1)); // Direction (ascending)
    $display("$size(1):             %0d", $size(unpacked_arr, 1)); // Size of the dimension (number of elements)
    $display("Total size ($size):   %0d", $size(unpacked_arr)); // Total elements in unpacked dimensions

    $display("\n--- descending_arr (real [99:10]) ---");
    $display("$left(1):             %0d", $left(descending_arr, 1));
    $display("$right(1):            %0d", $right(descending_arr, 1));
    $display("$low(1):              %0d", $low(descending_arr, 1));
    $display("$high(1):             %0d", $high(descending_arr, 1));
    $display("$increment(1):        %0d", $increment(descending_arr, 1)); // Direction (descending)
    $display("$size(1):             %0d", $size(descending_arr, 1));

    $display("\n--- packed_2d (logic [3:0][7:0]) ---");
    $display("$unpacked_dimensions: %0d", $unpacked_dimensions(packed_2d)); // No unpacked dims
    $display("$dimensions:          %0d", $dimensions(packed_2d)); // Two packed dimensions
    $display("$left(1):             %0d", $left(packed_2d, 1)); // 1st packed dim [3:0]
    $display("$right(1):            %0d", $right(packed_2d, 1));
    $display("$left(2):             %0d", $left(packed_2d, 2)); // 2nd packed dim [7:0]
    $display("$right(2):            %0d", $right(packed_2d, 2));
    $display("$size(1):             %0d", $size(packed_2d, 1)); // Size of 1st packed dim
    $display("$size(2):             %0d", $size(packed_2d, 2)); // Size of 2nd packed dim

    $display("\n--- unpacked_2d (byte [0:4][0:9]) ---");
    $display("$unpacked_dimensions: %0d", $unpacked_dimensions(unpacked_2d)); // Two unpacked dims
    $display("$dimensions:          %0d", $dimensions(unpacked_2d)); // Two unpacked dims
    $display("$left(1):             %0d", $left(unpacked_2d, 1)); // 1st unpacked dim [0:4]
    $display("$right(1):            %0d", $right(unpacked_2d, 1));
    $display("$left(2):             %0d", $left(unpacked_2d, 2)); // 2nd unpacked dim [0:9]
    $display("$right(2):            %0d", $right(unpacked_2d, 2));
    $display("$size(1):             %0d", $size(unpacked_2d, 1)); // Size of 1st unpacked dim
    $display("$size(2):             %0d", $size(unpacked_2d, 2)); // Size of 2nd unpacked dim
    $display("Total size ($size):   %0d", $size(unpacked_2d)); // Total elements in unpacked dims

    $display("\n--- mixed_array (bit [1:0] mixed_array [0:2][3:4]) ---");
    // Unpacked dimensions: [0:2], [3:4] (2 dimensions)
    // Packed dimension: [1:0] (1 dimension)
    $display("$unpacked_dimensions: %0d", $unpacked_dimensions(mixed_array)); // 2 unpacked dims
    $display("$dimensions:          %0d", $dimensions(mixed_array)); // Total dims (2 unpacked + 1 packed)
    // Unpacked dimensions are indexed starting from 1
    $display("$left(1):             %0d", $left(mixed_array, 1)); // 1st unpacked dim [0:2]
    $display("$right(1):            %0d", $right(mixed_array, 1));
    $display("$left(2):             %0d", $left(mixed_array, 2)); // 2nd unpacked dim [3:4]
    $display("$right(2):            %0d", $right(mixed_array, 2));
    $display("$size(1):             %0d", $size(mixed_array, 1)); // Size of 1st unpacked dim
    $display("$size(2):             %0d", $size(mixed_array, 2)); // Size of 2nd unpacked dim
    $display("Total size ($size):   %0d", $size(mixed_array)); // Total elements in unpacked dims

    // Packed dimensions are indexed starting AFTER the unpacked dimensions
    $display("$left(3):             %0d", $left(mixed_array, 3)); // 1st packed dim [1:0] (index 3 = 2 unpacked + 1 packed)
    $display("$right(3):            %0d", $right(mixed_array, 3));
    $display("$size(3):             %0d", $size(mixed_array, 3)); // Size of the packed dimension

    $finish;
  end

endmodule
```

Let's break down the functions based on the example:

### `$unpacked_dimensions`

**Description:** Returns the number of *unpacked* dimensions of an array. Returns 0 for packed vectors or packed multi-dimensional arrays.

**Example Output (based on the code):**
-   `packed_vec`: 0
-   `unpacked_arr`: 1
-   `descending_arr`: 1
-   `packed_2d`: 0
-   `unpacked_2d`: 2
-   `mixed_array`: 2

### `$dimensions`

**Description:** Returns the total number of dimensions, which is the sum of unpacked dimensions and packed dimensions.

**Example Output:**
-   `packed_vec`: 1
-   `unpacked_arr`: 1
-   `descending_arr`: 1
-   `packed_2d`: 2
-   `unpacked_2d`: 2
-   `mixed_array`: 3 (2 unpacked + 1 packed)

### `$left(array, dimension)`

**Description:** Returns the left-hand index bound of the specified `dimension`. Dimensions are numbered starting from 1. Unpacked dimensions are numbered first, followed by packed dimensions.

**Example Output:**
-   `packed_vec, 1`: 7
-   `unpacked_arr, 1`: 0
-   `descending_arr, 1`: 99
-   `packed_2d, 1`: 3 (1st packed dim)
-   `packed_2d, 2`: 7 (2nd packed dim)
-   `unpacked_2d, 1`: 0 (1st unpacked dim)
-   `unpacked_2d, 2`: 0 (2nd unpacked dim)
-   `mixed_array, 1`: 0 (1st unpacked dim)
-   `mixed_array, 2`: 3 (2nd unpacked dim)
-   `mixed_array, 3`: 1 (1st packed dim, indexed after the 2 unpacked dims)

### `$right(array, dimension)`

**Description:** Returns the right-hand index bound of the specified `dimension`. Dimensions are numbered starting from 1. Unpacked dimensions are numbered first, followed by packed dimensions.

**Example Output:**
-   `packed_vec, 1`: 0
-   `unpacked_arr, 1`: 9
-   `descending_arr, 1`: 10
-   `packed_2d, 1`: 0
-   `packed_2d, 2`: 0
-   `unpacked_2d, 1`: 4
-   `unpacked_2d, 2`: 9
-   `mixed_array, 1`: 2
-   `mixed_array, 2`: 4
-   `mixed_array, 3`: 0

### `$low(array, dimension)`

**Description:** Returns the lower bound of the specified `dimension` (minimum of the left and right bounds).

**Example Output:**
-   `packed_vec, 1`: 0 (min(7, 0))
-   `unpacked_arr, 1`: 0 (min(0, 9))
-   `descending_arr, 1`: 10 (min(99, 10))
-   `packed_2d, 1`: 0
-   `packed_2d, 2`: 0
-   `unpacked_2d, 1`: 0
-   `unpacked_2d, 2`: 0
-   `mixed_array, 1`: 0
-   `mixed_array, 2`: 3
-   `mixed_array, 3`: 0

### `$high(array, dimension)`

**Description:** Returns the upper bound of the specified `dimension` (maximum of the left and right bounds).

**Example Output:**
-   `packed_vec, 1`: 7 (max(7, 0))
-   `unpacked_arr, 1`: 9 (max(0, 9))
-   `descending_arr, 1`: 99 (max(99, 10))
-   `packed_2d, 1`: 3
-   `packed_2d, 2`: 7
-   `unpacked_2d, 1`: 4
-   `unpacked_2d, 2`: 9
-   `mixed_array, 1`: 2
-   `mixed_array, 2`: 4
-   `mixed_array, 3`: 1

### `$increment(array, dimension)`

**Description:** Returns 1 if the specified `dimension` has an ascending index range (left <= right), and -1 if it has a descending index range (left > right).

**Example Output:**
-   `packed_vec, 1`: -1 (7 down to 0)
-   `unpacked_arr, 1`: 1 (0 up to 9)
-   `descending_arr, 1`: -1 (99 down to 10)
-   `packed_2d, 1`: -1
-   `packed_2d, 2`: -1
-   `unpacked_2d, 1`: 1
-   `unpacked_2d, 2`: 1
-   `mixed_array, 1`: 1
-   `mixed_array, 2`: 1
-   `mixed_array, 3`: -1

### `$size(array, dimension)` and `$size(array)`

**Description:**

-   `$size(array, dimension)`: Returns the number of elements in the specified `dimension`. Calculated as `$high(array, dimension) - $low(array, dimension) + 1`.
-   `$size(array)`: Returns the total number of elements in all *unpacked* dimensions of the array. For an array with N unpacked dimensions with sizes S1, S2, ..., SN, this is S1 \* S2 \* ... \* SN. For a packed array, this returns 1 (representing the single 'element' which is the entire vector).

**Example Output:**
-   `packed_vec, 1`: 8 (Size of the 8-bit vector)
-   `unpacked_arr, 1`: 10 (Size of the 10-element unpacked array)
-   `unpacked_arr`: 10 (Total elements in unpacked dimensions)
-   `descending_arr, 1`: 90 (Size of the 90-element unpacked array)
-   `packed_2d, 1`: 4 (Size of the 4-element outer packed dim)
-   `packed_2d, 2`: 8 (Size of the 8-bit inner packed dim)
-   `unpacked_2d, 1`: 5 (Size of the 5-element 1st unpacked dim)
-   `unpacked_2d, 2`: 10 (Size of the 10-element 2nd unpacked dim)
-   `unpacked_2d`: 50 (Total elements in unpacked dims: 5 * 10)
-   `mixed_array, 1`: 3 (Size of the 1st unpacked dim)
-   `mixed_array, 2`: 2 (Size of the 2nd unpacked dim)
-   `mixed_array`: 6 (Total elements in unpacked dims: 3 * 2)
-   `mixed_array, 3`: 2 (Size of the packed dimension)

These functions are essential for writing generic code that operates on arrays of different sizes and dimensions without hardcoding the bounds.

## Math Functions
A comprehensive set of mathematical functions for use within SystemVerilog.
All trigonometric, hyperbolic, and inverse hyperbolic functions operate on and return `real` type values. Angles for trigonometric functions are specified in radians.

### Rounding Functions

These functions adjust a real number to the nearest integer value based on different rules.

-   `$ceil(real_expression)`: Returns the smallest integer value that is greater than or equal to `real_expression`.
-   `$floor(real_expression)`: Returns the largest integer value that is less than or equal to `real_expression`.

**Example:**

```SV
module rounding_example;

  real val1 = 3.14;
  real val2 = 3.99;
  real val3 = -2.1;
  real val4 = -2.9;

  initial begin
    $display("--- Rounding Examples ---");
    $display("$ceil(%f)  = %f", val1, $ceil(val1));
    $display("$ceil(%f)  = %f", val2, $ceil(val2));
    $display("$ceil(%f) = %f", val3, $ceil(val3));
    $display("$ceil(%f) = %f", val4, $ceil(val4));

    $display("\n$floor(%f) = %f", val1, $floor(val1));
    $display("$floor(%f) = %f", val2, $floor(val2));
    $display("$floor(%f) = %f", val3, $floor(val3));
    $display("$floor(%f) = %f", val4, $floor(val4));

    $finish;
  end

endmodule
```

**Explanation:**

-   `$ceil(3.14)` and `$ceil(3.99)` both round up to 4.0.
-   `$ceil(-2.1)` and `$ceil(-2.9)` both round up towards zero, resulting in -2.0.
-   `$floor(3.14)` and `$floor(3.99)` both round down to 3.0.
-   `$floor(-2.1)` and `$floor(-2.9)` both round down away from zero, resulting in -3.0.

### Exponent and Logarithmic Functions

These functions handle powers and logarithms.

-   `$pow(base, exponent)`: Returns `base` raised to the power of `exponent`. Both inputs and the output are `real`.
-   `$sqrt(real_expression)`: Returns the square root of `real_expression`. Input must be non-negative.
-   `$clog2(integer_expression)`: Returns the ceiling of the base-2 logarithm of the positive `integer_expression`. This is commonly used to determine the minimum number of bits required to represent `integer_expression` unique values. The input is an integer type, the output is an integer type.
-   `$log10(real_expression)`: Returns the base-10 logarithm of `real_expression`. Input must be positive.
-   `$exp(real_expression)`: Returns the base of the natural logarithm, *e*, raised to the power of `real_expression` ($e^{real\_expression}$).
-   `$ln(real_expression)`: Returns the natural logarithm (base *e*) of `real_expression`. Input must be positive.

**Example:**

```SV
module exp_log_example;

  real base_val = 2.0;
  real exp_val = 3.0;
  real sqrt_val = 16.0;
  integer clog2_val = 10;
  real log10_val = 100.0;
  real exp_input = 1.0; // For e^1
  real ln_input = 2.71828; // Approximately e

  initial begin
    $display("--- Exponent and Logarithmic Examples ---");
    $display("$pow(%f, %f) = %f", base_val, exp_val, $pow(base_val, exp_val)); // 2^3
    $display("$sqrt(%f)     = %f", sqrt_val, $sqrt(sqrt_val)); // sqrt(16)
    $display("$clog2(%0d)    = %0d", clog2_val, $clog2(clog2_val)); // ceil(log2(10))

    $display("\n$log10(%f)   = %f", log10_val, $log10(log10_val)); // log10(100)
    $display("$exp(%f)      = %f", exp_input, $exp(exp_input)); // e^1
    $display("$ln(%f)       = %f", ln_input, $ln(ln_input)); // ln(e)

    $finish;
  end

endmodule
```

**Explanation:**

-   `$pow(2.0, 3.0)` calculates $2^3 = 8.0$.
-   `$sqrt(16.0)` calculates $\sqrt{16.0} = 4.0$.
-   `$clog2(10)` calculates $\lceil\log_2(10)\rceil$. $\log_2(10)$ is approximately 3.32, so the ceiling is 4. This means you need 4 bits to represent values from 0 to 9 (10 unique values).
-   `$log10(100.0)` calculates $\log_{10}(100.0) = 2.0$.
-   `$exp(1.0)` calculates $e^1$, which is approximately 2.71828.
-   `$ln(2.71828)` calculates $\ln(2.71828)$, which is approximately 1.0.

### Trigonometric and Hyperbolic Functions

These functions perform standard trigonometric and hyperbolic calculations, along with their inverse operations. Angles for trigonometric functions are in radians.

-   `$sin(real_expression)`: Returns the sine of `real_expression` (in radians).
-   `$sinh(real_expression)`: Returns the hyperbolic sine of `real_expression`.
-   `$asin(real_expression)`: Returns the arc sine (inverse sine) of `real_expression`. Input must be between -1.0 and 1.0. Returns an angle in radians between $-\pi/2$ and $\pi/2$.
-   `$asinh(real_expression)`: Returns the inverse hyperbolic sine of `real_expression`.
-   `$cos(real_expression)`: Returns the cosine of `real_expression` (in radians).
-   `$cosh(real_expression)`: Returns the hyperbolic cosine of `real_expression`.
-   `$acos(real_expression)`: Returns the arc cosine (inverse cosine) of `real_expression`. Input must be between -1.0 and 1.0. Returns an angle in radians between 0 and $\pi$.
-   `$acosh(real_expression)`: Returns the inverse hyperbolic cosine of `real_expression`. Input must be greater than or equal to 1.0.
-   `$tan(real_expression)`: Returns the tangent of `real_expression` (in radians).
-   `$tanh(real_expression)`: Returns the hyperbolic tangent of `real_expression`.
-   `$atan(real_expression)`: Returns the arc tangent (inverse tangent) of `real_expression`. Returns an angle in radians between $-\pi/2$ and $\pi/2$.
-   `$atanh(real_expression)`: Returns the inverse hyperbolic tangent of `real_expression`. Input must be between -1.0 and 1.0 (exclusive).
-   `$atan2(y_expression, x_expression)`: Returns the arc tangent of y/x, using the signs of both arguments to determine the quadrant of the result. Returns an angle in radians between $-\pi$ and $\pi$. Useful for converting Cartesian coordinates (x, y) to polar coordinates (r, $\theta$).
-   `$hypot(x_expression, y_expression)`: Returns the length of the hypotenuse of a right triangle with sides x and y, calculated as $\sqrt{x^2 + y^2}$.

**Example:**

```SV
module trig_hyper_example;

  // Use pi for trigonometric examples (M_PI is a common constant in C/C++)
  // SystemVerilog doesn't have built-in math constants, often defined like this:
  parameter real PI = 3.1415926535;
  parameter real HALF_PI = PI / 2.0; // 90 degrees
  parameter real TWO_PI = PI * 2.0;   // 360 degrees

  real angle_rad = HALF_PI;
  real asin_input = 1.0; // sin(PI/2)
  real acos_input = 0.0; // cos(PI/2)
  real atan_input = 1.0; // tan(PI/4)

  real sinh_input = 1.0;
  real asinh_input = 1.1752; // sinh(1.0) approx

  real cosh_input = 1.0;
  real acosh_input = 1.5431; // cosh(1.0) approx

  real tanh_input = 1.0;
  real atanh_input = 0.7616; // tanh(1.0) approx

  real atan2_y = 1.0;
  real atan2_x = 1.0; // Corresponds to PI/4 (45 degrees)

  real hypot_x = 3.0;
  real hypot_y = 4.0;


  initial begin
    $display("--- Trigonometric Examples (Angles in Radians) ---");
    $display("$sin(%f rad)  = %f", angle_rad, $sin(angle_rad)); // sin(PI/2)
    $display("$cos(%f rad)  = %f", angle_rad, $cos(angle_rad)); // cos(PI/2)
    $display("$tan(%f rad)  = %f", PI / 4.0, $tan(PI / 4.0)); // tan(PI/4)

    $display("\n$asin(%f)     = %f rad", asin_input, $asin(asin_input)); // asin(1)
    $display("$acos(%f)     = %f rad", acos_input, $acos(acos_input)); // acos(0)
    $display("$atan(%f)     = %f rad", atan_input, $atan(atan_input)); // atan(1)
    $display("$atan2(%f, %f) = %f rad", atan2_y, atan2_x, $atan2(atan2_y, atan2_x)); // atan2(1, 1)

    $display("\n--- Hyperbolic Examples ---");
    $display("$sinh(%f) = %f", sinh_input, $sinh(sinh_input));
    $display("$cosh(%f) = %f", cosh_input, $cosh(cosh_input));
    $display("$tanh(%f) = %f", tanh_input, $tanh(tanh_input));

    $display("\n$asinh(%f) = %f", asinh_input, $asinh(asinh_input));
    $display("$acosh(%f) = %f", acosh_input, $acosh(acosh_input));
    $display("$atanh(%f) = %f", atanh_input, $atanh(atanh_input));

    $display("\n--- Other Examples ---");
    $display("$hypot(%f, %f) = %f", hypot_x, hypot_y, $hypot(hypot_x, hypot_y)); // sqrt(3^2 + 4^2)

    $finish;
  end

endmodule
```

**Explanation:**

-   The trigonometric functions calculate sin, cos, and tan for a given angle in radians. `$sin(PI/2)` is approximately 1.0, `$cos(PI/2)` is approximately 0.0, and `$tan(PI/4)` is approximately 1.0.
-   The inverse trigonometric functions (`$asin`, `$acos`, `$atan`, `$atan2`) return the angle in radians. `$asin(1.0)` returns approximately $\pi/2$, `$acos(0.0)` returns approximately $\pi/2$, `$atan(1.0)` returns approximately $\pi/4$, and `$atan2(1.0, 1.0)` returns approximately $\pi/4$. `$atan2` is useful as it considers the signs of both inputs to determine the correct quadrant.
-   The hyperbolic functions (`$sinh`, `$cosh`, `$tanh`) and their inverses (`$asinh`, `$acosh`, `$atanh`) perform calculations based on the hyperbolic functions related to the hyperbola $x^2 - y^2 = 1$.
-   `$hypot(3.0, 4.0)` calculates $\sqrt{3^2 + 4^2} = \sqrt{9 + 16} = \sqrt{25} = 5.0$.

These math functions provide the necessary tools for performing complex numerical calculations within your SystemVerilog simulation environment.
  
## Bit Vector System Functions
Functions for operating on bit vectors, such as counting bits or checking for one-hot encoding.
### `$countbits`

**Description:**

The `$countbits(expression, value, ...)` function counts the number of bits in `expression` that match the specified `value` or values. The `value` can be `0`, `1`, `x`, or `z`. You can provide multiple values to count occurrences of any of those values.

**Usage:**

`$countbits(expression, value1 [, value2, ...])`

### `$countones`

**Description:**

The `$countones(expression)` function is a shorthand for `$countbits(expression, 1)`. It returns the number of bits in `expression` that have the value '1'.

**Usage:**

`$countones(expression)`

### `$onehot`

**Description:**

The `$onehot(expression)` function checks if exactly one bit in the `expression` is a logic '1' and all other bits are either '0', 'x', or 'z'. It returns 1 (true) if this condition is met, and 0 (false) otherwise.

**Usage:**

`$onehot(expression)`

### `$onehot0`

**Description:**

The `$onehot0(expression)` function checks if at most one bit in the `expression` is a logic '1' and all other bits are either '0', 'x', or 'z'. This includes the case where all bits are '0' (or 'x'/'z'). It returns 1 (true) if this condition is met, and 0 (false) otherwise.

**Usage:**

`$onehot0(expression)`

### `$isunknown`

**Description:**

The `$isunknown(expression)` function checks if any bit in the `expression` has a value of 'x' or 'z'. It returns 1 (true) if at least one bit is 'x' or 'z', and 0 (false) if all bits are '0' or '1'.

**Usage:**

`$isunknown(expression)`

### Example Demonstrating Bit Vector Functions

```SV
module bit_vector_functions_example;

  logic [7:0] data1 = 8'b1011_0010; // 4 ones, 4 zeros
  logic [7:0] data2 = 8'b0000_0000; // 0 ones, 8 zeros
  logic [7:0] data3 = 8'b1000_0000; // 1 one, 7 zeros
  logic [7:0] data4 = 8'b1111_1111; // 8 ones, 0 zeros
  logic [7:0] data5 = 8'b10x1_z010; // Includes X and Z

  initial begin
    $display("--- Analysis of data1 (%b) ---", data1);
    $display("$countbits(data1, 1):     %0d", $countbits(data1, 1));
    $display("$countbits(data1, 0):     %0d", $countbits(data1, 0));
    $display("$countones(data1):        %0d", $countones(data1));
    $display("$onehot(data1):           %0d", $onehot(data1));
    $display("$onehot0(data1):          %0d", $onehot0(data1));
    $display("$isunknown(data1):        %0d", $isunknown(data1));

    $display("\n--- Analysis of data2 (%b) ---", data2);
    $display("$countones(data2):        %0d", $countones(data2));
    $display("$onehot(data2):           %0d", $onehot(data2));
    $display("$onehot0(data2):          %0d", $onehot0(data2));
    $display("$isunknown(data2):        %0d", $isunknown(data2));

    $display("\n--- Analysis of data3 (%b) ---", data3);
    $display("$countones(data3):        %0d", $countones(data3));
    $display("$onehot(data3):           %0d", $onehot(data3));
    $display("$onehot0(data3):          %0d", $onehot0(data3));
    $display("$isunknown(data3):        %0d", $isunknown(data3));

     $display("\n--- Analysis of data4 (%b) ---", data4);
    $display("$countones(data4):        %0d", $countones(data4));
    $display("$onehot(data4):           %0d", $onehot(data4));
    $display("$onehot0(data4):          %0d", $onehot0(data4));
    $display("$isunknown(data4):        %0d", $isunknown(data4));

    $display("\n--- Analysis of data5 (%b) ---", data5);
    $display("$countbits(data5, 1):     %0d", $countbits(data5, 1)); // Counts '1's
    $display("$countbits(data5, 0):     %0d", $countbits(data5, 0)); // Counts '0's
    $display("$countbits(data5, x):     %0d", $countbits(data5, x)); // Counts 'X's
    $display("$countbits(data5, z):     %0d", $countbits(data5, z)); // Counts 'Z's
    $display("$countbits(data5, 1, x, z): %0d", $countbits(data5, 1, x, z)); // Counts '1', 'X', or 'Z'
    $display("$countones(data5):        %0d", $countones(data5)); // Only counts '1's
    $display("$onehot(data5):           %0d", $onehot(data5)); // False because of X/Z/multiple 1s
    $display("$onehot0(data5):          %0d", $onehot0(data5)); // False because of multiple 1s (and X/Z)
    $display("$isunknown(data5):        %0d", $isunknown(data5)); // True because of X and Z

    $finish;
  end

endmodule
```

**Explanation:**

-   **`$countbits`**: Shows how to count specific bit values, including 'x' and 'z', and how to count multiple values at once. For `data5` (`10x1_z010`), it correctly identifies 3 ones, 2 zeros, 1 X, and 1 Z.
-   **`$countones`**: Directly counts the '1' bits. For `data1` (4 ones), `data2` (0 ones), `data3` (1 one), `data4` (8 ones), and `data5` (3 ones), it returns the correct counts.
-   **`$onehot`**: Checks for exactly one '1'. It returns 1 only for `data3` (`1000_0000`). For `data1`, `data2`, `data4`, and `data5`, it returns 0.
-   **`$onehot0`**: Checks for at most one '1'. It returns 1 for `data2` (zero ones) and `data3` (exactly one '1'). It returns 0 for `data1`, `data4`, and `data5`.
-   **`$isunknown`**: Checks for 'x' or 'z'. It returns 0 for `data1`, `data2`, `data3`, and `data4` (which contain only 0s and 1s). It returns 1 for `data5` because it contains 'x' and 'z'.

These functions are very useful for checking control signals, state encodings, or detecting the presence of unknown values in a design or testbench.

## Severity Tasks
Tasks used to report messages with different severity levels during simulation or elaboration.
Okay, let's describe the SystemVerilog severity tasks: `$fatal`, `$error`, `$warning`, and `$info`. These tasks are used to report messages during simulation or elaboration with standard severity levels, helping to categorize and manage simulation output.

They all use the same formatting syntax as the `$display` task, allowing you to include variables and format specifiers in the message string.

### `$fatal`

**Description:**

The `$fatal` task reports a severe error message and immediately terminates the simulation. It indicates a critical condition from which the simulation cannot recover or continue meaningfully. Using `$fatal` is similar to calling `$finish`, but it specifically flags the termination as a fatal error.

**Usage:**

`$fatal([severity_level,] message_string [, arguments]);`

* `severity_level`: An optional integer (usually 0) which is often ignored but part of the standard.
* `message_string`: The string to display, can contain format specifiers.
* `arguments`: Optional variables or expressions to be formatted into the string.

### `$error`

**Description:**

The `$error` task reports an error message. Unlike `$fatal`, `$error` does not necessarily stop the simulation, although most simulators track the number of errors and may offer options to halt after a certain error count. It indicates a condition that violates the design or testbench intent and likely invalidates the simulation results.

**Usage:**

`$error([severity_level,] message_string [, arguments]);`

### `$warning`

**Description:**

The `$warning` task reports a warning message. Warnings indicate potential issues or conditions that might be unexpected or undesirable but are not considered fatal errors. Simulation continues normally after a warning.

**Usage:**

`$warning([severity_level,] message_string [, arguments]);`

### `$info`

**Description:**

The `$info` task reports an informational message. This is the lowest severity level and is used for general status updates, progress reporting, or debugging information that doesn't indicate an error or warning. Simulation continues normally.

**Usage:**

`$info([severity_level,] message_string [, arguments]);`

### Example Demonstrating Severity Tasks

```SV
module severity_tasks_example;

  reg clock = 0;
  integer count = 0;

  initial begin
    $info("Simulation starting...");

    // Generate a clock
    forever #10 clock = ~clock;
  end

  always @(posedge clock) begin
    count++;

    if (count == 5) begin
      $warning("Count reached 5. This is a warning.");
    end

    if (count == 10) begin
      $error("Count reached 10. This is an error condition.");
    end

    if (count == 12) begin
      $info("Current count is 12.");
    end

    if (count == 15) begin
      $fatal(0, "Count reached 15. Simulation terminating due to fatal error.");
      // Lines below this will not be reached
      $display("This message will not be printed.");
    end
  end

endmodule
```

**Explanation:**

This example sets up a simple clocked process that increments a counter.

-   At the beginning of the simulation, an `$info` message is printed.
-   When the counter reaches 5, a `$warning` is issued.
-   When the counter reaches 10, an `$error` is issued.
-   When the counter reaches 12, another `$info` message is printed.
-   When the counter reaches 15, a `$fatal` error is reported, and the simulation immediately stops at that point. The final `$display` after the `$fatal` call will not be executed.

When you run this code in a simulator, you will see the messages printed with prefixes or highlighting that indicate their severity (e.g., "INFO:", "WARNING:", "ERROR:", "FATAL:"). The simulation will stop after the `$fatal` message is displayed. This provides a structured way to report events during simulation and helps quickly identify the nature of issues.

*Note: The specific output format and whether the simulator stops on `$error` by default can vary between simulation tools.*

## Assertion Control Tasks
Tasks to enable, disable, or control the behavior of assertions.
Consider a simple SystemVerilog module with a basic assertion to demonstrate these tasks:

```systemverilog
module assertion_control_example;

  logic clk = 0;
  logic req = 0;
  logic ack = 0;
  integer sim_time;

  // Clock generator
  initial begin
    forever #10 clk = ~clk;
  end

  // Stimulus
  initial begin
    $display("Time %0t: Simulation starts. Assertions are typically ON by default.", $time);
    sim_time = $time; // Initialize for display in assertion messages

    #25; // @25
    req = 1;
    $display("Time %0t: req = 1", $time);

    #20; // @45
    ack = 1;
    $display("Time %0t: ack = 1", $time);

    #30; // @75
    req = 0;
    ack = 0;
    $display("Time %0t: req = 0, ack = 0", $time);

    #30; // @105
    req = 1;
    $display("Time %0t: req = 1", $time);

    #50; // @155
    $display("Time %0t: Ending simulation.", $time);
    $finish;
  end

  // A simple assertion property
  property req_ack_p;
    @(posedge clk) req |=> ##[1:2] ack;
  endproperty

  // Assert the property
  assert property (req_ack_p) begin
    $info({$sformatf("Assertion PASSED at time %0t", $time)});
  end else begin
    $error({$sformatf("Assertion FAILED at time %0t", $time)});
  end

  // Control sequence
  initial begin
    #50; // @50
    $display("Time %0t: Calling $assertoff", $time);
    $assertoff(); // Disable all assertions

    #50; // @100
    $display("Time %0t: Calling $asserton", $time);
    $asserton(); // Re-enable all assertions

    #20; // @120
    $display("Time %0t: Calling $assertpassoff", $time);
    $assertpassoff(); // Disable reporting for passes

    #20; // @140
    $display("Time %0t: Calling $assertpasson", $time);
    $assertpasson(); // Re-enable reporting for passes

    #10; // @150
    // $assertkill() could be called here to remove assertions from evaluation
    // $assertfailoff() / $assertfailon() could control fail reporting
    // $assertnonvacuouson() / $assertvacuousoff() control reporting for different assertion outcomes
    $display("Time %0t: Control sequence finished.", $time);
  end

endmodule
```

Let's describe the tasks and their effects in the context of this example:

### `$asserton`

**Description:** Globally enables evaluation and reporting for all assertions that were previously disabled by `$assertoff`. Assertions are typically enabled by default at the start of simulation.

**Example Usage (in the code):** Called at time 100 to re-enable assertions disabled at time 50.

### `$assertoff`

**Description:** Globally disables evaluation and reporting for all assertions. Assertions will not be checked, and no pass or fail messages will be generated while assertions are off.

**Example Usage (in the code):** Called at time 50 to disable all assertions.

### `$assertkill`

**Description:** Disables assertions similar to `$assertoff`, but also removes pending assertion attempts from the simulation queue. This is a more aggressive way to stop assertion monitoring. If an assertion property was in the middle of a sequence match when `$assertkill` is called, that specific attempt is terminated and will not result in a future pass or fail.

**Usage:**

`$assertkill([0]);` (The argument is typically 0 and often omitted).

**Example Usage (not explicitly in the code, but could be added):** If called at time 150, any assertion attempts that started but haven't finished evaluation by time 150 would be abandoned.

### `$assertcontrol`

**Description:** This task provides more granular control over assertions than the global `on`/`off`. It allows control over specific assertion instances or properties and finer control over which outcomes (pass, fail, vacuous, non-vacuous) are reported. The exact syntax and level of support can vary between simulators. A common form allows controlling based on the type of outcome.

**Usage (Standard form, may vary by simulator):**

`$assertcontrol(control_type, assertion_instance/property, mode);`

* `control_type`: Specifies what to control (e.g., pass reporting, fail reporting, evaluation).
* `assertion_instance/property`: The specific assertion or property to control (can be hierarchical name).
* `mode`: Enable (1) or Disable (0).

**Example Usage (Conceptual, not in simplified example):**
`$assertcontrol(SV_ASSERT_PASS_ENABLE, top.my_module.my_assertion_label, 0);` // Disable pass reporting for a specific assertion

### `$assertpasson`

**Description:** Globally enables reporting of passing assertions. When assertions are enabled, this allows the "pass" branch of the `assert property` statement (or a default pass message) to execute.

**Example Usage (in the code):** Called at time 140 to re-enable pass reporting after it was disabled.

### `$assertpassoff`

**Description:** Globally disables reporting of passing assertions. While assertions may still be evaluated, the "pass" branch of the statement will not be executed, and no pass message will be generated. Fail reporting is unaffected.

**Example Usage (in the code):** Called at time 120 to disable pass reporting.

### `$assertfailon`

**Description:** Globally enables reporting of failing assertions. When assertions are enabled, this allows the "fail" branch of the `assert property` statement (or a default fail message) to execute. Fail reporting is typically enabled by default.

**Usage:**

`$assertfailon([0]);`

**Example Usage:** Not explicitly called `on` in the example as it's usually the default, but could be used to re-enable after `$assertfailoff`.

### `$assertfailoff`

**Description:** Globally disables reporting of failing assertions. While assertions may still be evaluated, the "fail" branch of the statement will not be executed, and no fail message will be generated. Pass reporting is unaffected.

**Usage:**

`$assertfailoff([0]);`

**Example Usage:** Not used in the example, but if called, would suppress the `$error` message from assertion failures.

### `$assertnonvacuouson`

**Description:** Globally enables reporting for non-vacuous assertion outcomes. A non-vacuous outcome occurs when the assertion's antecedent (the part before `|=>` or `|->`) evaluates to true, leading to the consequent being checked. Reporting for these cases is typically enabled by default.

**Usage:**

`$assertnonvacuouson([0]);`

### `$assertvacuousoff`

**Description:** Globally disables reporting for vacuous assertion outcomes. A vacuous outcome occurs when the assertion's antecedent evaluates to false, meaning the consequent is not checked, and the assertion is considered to have "vacuously" passed. Reporting for these cases is often disabled by default.

**Usage:**

`$assertvacuousoff([0]);`

### Expected Behavior in the Example:

1.  **Start - Time 50:** Assertions are ON. The `req` signal goes high at 25. The assertion starts evaluating at the next posedge clk after 25 (e.g., at 30 or 40 depending on clock phase). It is looking for `ack` within 1 or 2 cycles. Since `ack` goes high at 45 (which is within the 1-2 cycle window from a posedge clk around 30/40), the assertion attempt will likely pass. The `$info` message for the pass will be printed.
2.  **Time 50:** `$assertoff()` is called. Assertions are now OFF. Any subsequent triggers of the antecedent (`req` going high) will not cause assertion evaluation to start.
3.  **Time 100:** `$asserton()` is called. Assertions are ON again. `req` was set high at 105. The assertion will start evaluating at the next posedge clk after 105 (e.g., at 110). It looks for `ack` within 1-2 cycles. Since `ack` remains low, this assertion attempt will fail around time 120 or 130. The `$error` message for the failure will be printed (because fail reporting is still on). Pass reporting is also on, but there's no pass for this specific attempt.
4.  **Time 120:** `$assertpassoff()` is called. Pass reporting is now OFF globally.
5.  **Time 140:** `$assertpasson()` is called. Pass reporting is now ON globally again.
6.  **Time 155:** Simulation finishes.

Using these tasks, you can selectively enable or disable assertion checking and control the verbosity of your simulation logs based on assertion outcomes. This is very useful for focusing debugging efforts or speeding up simulations where assertion checks are not currently relevant.

## Sampled Value System Functions
Functions used within assertion properties to refer to sampled values at different points in time or with respect to a global clock.
Assertions evaluate expressions at specific clock events (the sampling clock, defined by `@(posedge clk)` or `@(negedge clk)` in the property or sequence). The sampled value functions allow you to access the value of a signal or expression *at* these clock ticks.

Some functions have `_gclk` suffixes. These variants operate relative to a separate, explicitly defined *global clock*, allowing you to sample signals based on a clock different from the one driving the assertion property.

Consider the following example module with a clock and a data signal to demonstrate these functions within properties:

```systemverilog
module sampled_value_example;

  logic clk = 0;
  logic data = 0;
  logic global_clk = 0; // Example global clock
  integer sim_time;

  // Clock generators
  initial begin
    forever #10 clk = ~clk; // Period 20
  end

  initial begin
    #5; // Offset global clock
    forever #15 global_clk = ~global_clk; // Period 30
  end

  // Stimulus
  initial begin
    $display("Time %0t: Simulation starts.", $time);
    sim_time = $time; // Initialize for display in assertion messages

    #25; data = 1; $display("Time %0t: data = 1", $time); // data changes between posedge clk
    #30; data = 0; $display("Time %0t: data = 0", $time); // data changes at posedge clk + 10
    #30; data = 1; $display("Time %0t: data = 1", $time); // data changes at posedge clk + 10
    #30; data = 0; $display("Time %0t: data = 0", $time); // data changes at posedge clk + 10
    #30; data = 1; $display("Time %0t: data = 1", $time); // data changes at posedge clk + 10
    #30; data = 0; $display("Time %0t: data = 0", $time); // data changes at posedge clk + 10


    #100;
    $display("Time %0t: Ending simulation.", $time);
    $finish;
  end

  // --- Properties demonstrating sampled value functions ---

  // Property 1: Demonstrate $sampled and $past
  // Checks if data is 1 at the current clock edge, AND was 0 at the previous clock edge
  property check_rose_using_sampled_past;
    @(posedge clk) $sampled(data) == 1 && $past(data) == 0;
  endproperty
  assert property (check_rose_using_sampled_past) $info({$sformatf("P1 Passed: data rose at time %0t", $time)});

  // Property 2: Demonstrate $rose
  // Checks if data had a 0->1 transition exactly at the current clock edge sample point
  property check_rose_direct;
    @(posedge clk) $rose(data);
  endproperty
  assert property (check_rose_direct) $info({$sformatf("P2 Passed: $rose(data) is true at time %0t", $time)});

  // Property 3: Demonstrate $fell
  // Checks if data had a 1->0 transition exactly at the current clock edge sample point
  property check_fell_direct;
    @(posedge clk) $fell(data);
  endproperty
  assert property (check_fell_direct) $info({$sformatf("P3 Passed: $fell(data) is true at time %0t", $time)});

  // Property 4: Demonstrate $stable
  // Checks if data did NOT change value between the previous and current clock edge sample points
  property check_stable;
    @(posedge clk) $stable(data);
  endproperty
  assert property (check_stable) $info({$sformatf("P4 Passed: $stable(data) is true at time %0t", $time)});

  // Property 5: Demonstrate $changed
  // Checks if data DID change value between the previous and current clock edge sample points
  property check_changed;
    @(posedge clk) $changed(data);
  endproperty
  assert property (check_changed) $info({$sformatf("P5 Passed: $changed(data) is true at time %0t", $time)});


  // --- Properties demonstrating _gclk functions ---
  // Define the global clock for _gclk functions
  bind :* cover property (@(global_clk) 1); // Use a dummy cover to associate global_clk

  // Property 6: Demonstrate $past_gclk
  // Check data's value 2 ticks ago on global_clk, relative to the current posedge clk
  property check_past_gclk;
      @(posedge clk) data == $past_gclk(data, 2, @(posedge global_clk));
  endproperty
  // This property checks if the current value of 'data' at 'posedge clk'
  // is equal to the value 'data' had 2 'posedge global_clk' ticks ago.
  assert property (check_past_gclk) $info({$sformatf("P6 Passed: data at posedge clk matches data 2 posedge global_clk ago at time %0t", $time)});


  // Property 7: Demonstrate $rose_gclk, $fell_gclk relative to posedge clk
  // Check if data rose on a posedge global_clk tick occurring 1 tick ago relative to posedge clk
   property check_rose_gclk;
       @(posedge clk) $rose_gclk(data, 1, @(posedge global_clk));
   end property
   assert property(check_rose_gclk) $info({$sformatf("P7 Passed: data rose on posedge global_clk 1 tick ago at time %0t", $time)});

  // Property 8: Demonstrate $rising_gclk (checks for a rising edge on signal relative to global_clk)
  property check_rising_gclk;
      @(posedge clk) $rising_gclk(data, @(posedge global_clk));
  endproperty
  // This property checks if a rising edge on 'data' occurred *at the same time* as the
  // most recent 'posedge global_clk' that happened *before or at* the current 'posedge clk'.
  // This function is a bit nuanced in its exact sample point compared to $rose_gclk.
   assert property(check_rising_gclk) $info({$sformatf("P8 Passed: $rising_gclk(data) true relative to global_clk at time %0t", $time)});


  // Property 9: Demonstrate $future_gclk (conceptual - exact sample point can be tricky)
  // Check what data will be 1 tick from now on global_clk, relative to posedge clk
  property check_future_gclk;
       @(posedge clk) $future_gclk(data, 1, @(posedge global_clk)) == 1; // Example check
  endproperty
  // This property is tricky to predict precisely without simulator specifics,
  // as it depends on the ordering of clock edges.
  // It attempts to sample 'data' at the 1st 'posedge global_clk' after the current 'posedge clk'.
   assert property(check_future_gclk) $info({$sformatf("P9 Passed: data is 1 one posedge global_clk in the future at time %0t", $time)});


  // Note: $stable_gclk, $changing_gclk, $falling_gclk, $steady_gclk
  // These function similarly to their non-_gclk counterparts but reference the global clock.
  // $stable_gclk(expr, start_offset, end_offset, @(gclk)) checks if expr is stable
  // between 'start_offset' and 'end_offset' ticks of 'gclk' relative to the current point.
  // $changing_gclk is the opposite of $steady_gclk.
  // $falling_gclk checks for a falling edge on expr relative to gclk.
  // $steady_gclk checks if the signal was constant for an interval of global clock cycles.

endmodule
```

Let's explain the functions based on the example and general usage:

### `$sampled(expression)`

**Description:** Returns the value of `expression` at the current clock tick of the property or sequence being evaluated. This is the default behavior for expressions within assertions, so explicitly using `$sampled` is often optional but improves clarity.

**Example Usage (P1):** Used to get the value of `data` at the current `posedge clk`.

### `$rose(expression)`

**Description:** Returns 1 (true) if the value of `expression` transitioned from a logical 0 to a logical 1 at the current clock tick's sampling point. Otherwise, returns 0 (false). Handles 4-state logic appropriately (e.g., x/z to 1 might qualify as a rise depending on context/simulator).

**Example Usage (P2):** Checks for a rising edge on `data` precisely when `posedge clk` occurs.

### `$fell(expression)`

**Description:** Returns 1 (true) if the value of `expression` transitioned from a logical 1 to a logical 0 at the current clock tick's sampling point. Otherwise, returns 0 (false).

**Example Usage (P3):** Checks for a falling edge on `data` precisely when `posedge clk` occurs.

### `$stable(expression)`

**Description:** Returns 1 (true) if the value of `expression` is the same at the current clock tick's sampling point as it was at the previous clock tick's sampling point. Otherwise, returns 0 (false).

**Example Usage (P4):** Checks if `data` held its value from the previous `posedge clk` to the current one.

### `$changed(expression)`

**Description:** Returns 1 (true) if the value of `expression` is different at the current clock tick's sampling point compared to the previous clock tick's sampling point. Otherwise, returns 0 (false). Equivalent to `!$stable(expression)`.

**Example Usage (P5):** Checks if `data` changed value between the previous `posedge clk` and the current one.

### `$past(expression [, number_of_ticks [, clocking_event [, enabling_condition]]])`

**Description:** Returns the value of `expression` from a previous clock tick.
-   `number_of_ticks`: How many clock ticks ago to look (default is 1).
-   `clocking_event`: The clocking event for counting ticks (default is the property's clock).
-   `enabling_condition`: An optional expression that must be true at each intermediate clock tick for the tick count to advance.

**Example Usage (P1):** Used as `$past(data)` to get the value of `data` at the immediately preceding `posedge clk`.

### `_gclk` Functions (`$past_gclk`, `$rose_gclk`, `$fell_gclk`, `$stable_gclk`, `$changed_gclk`)

**Description:** These functions are similar to their non-`_gclk` counterparts (`$past`, `$rose`, etc.) but sample the expression relative to an explicitly specified *global clocking event*, independent of the property's sampling clock. They take the expression, optionally the number of ticks ago, and the global clocking event as arguments.

**Usage:**

-   `$past_gclk(expression, number_of_ticks, @(global_clock_event))`
-   `$rose_gclk(expression, number_of_ticks_ago, @(global_clock_event))`
-   `$fell_gclk(expression, number_of_ticks_ago, @(global_clock_event))`
-   `$stable_gclk(expression, number_of_ticks_ago, @(global_clock_event))`
-   `$changed_gclk(expression, number_of_ticks_ago, @(global_clock_event))`

**Example Usage (P6, P7):** P6 uses `$past_gclk(data, 2, @(posedge global_clk))` to get the value of `data` from two `posedge global_clk` ticks ago, evaluated relative to the current `posedge clk`. P7 uses `$rose_gclk(data, 1, @(posedge global_clk))` to check if `data` rose on the `posedge global_clk` that occurred one global clock tick prior to the current `posedge clk`.

### `$future_gclk(expression, number_of_ticks, @(global_clock_event))`

**Description:** Returns the value of `expression` from a future clock tick relative to the specified global clocking event. This requires the simulator to look ahead in time.

**Usage:**

`$future_gclk(expression, number_of_ticks, @(global_clock_event))`

**Example Usage (P9):** Attempts to sample `data` one `posedge global_clk` tick in the future relative to the current `posedge clk`.

### `$rising_gclk(expression, @(global_clock_event))`

**Description:** Checks if there was a rising edge on `expression` exactly at the latest occurrence of the `global_clock_event` that is less than or equal to the current sampling clock time.

**Usage:**

`$rising_gclk(expression, @(global_clock_event))`

**Example Usage (P8):** Checks for a rising edge on `data` synchronized with the most recent `posedge global_clk` that occurred at or before the current `posedge clk`.

### `$falling_gclk(expression, @(global_clock_event))`

**Description:** Checks if there was a falling edge on `expression` exactly at the latest occurrence of the `global_clock_event` that is less than or equal to the current sampling clock time.

**Usage:**

`$falling_gclk(expression, @(global_clock_event))`

### `$steady_gclk(expression, start_offset, end_offset, @(global_clock_event))`

**Description:** Checks if `expression` held a constant value over an interval defined by offsets from the current time relative to the `global_clock_event`. The interval is from `start_offset` ticks to `end_offset` ticks *after* the current time.

**Usage:**

`$steady_gclk(expression, start_offset, end_offset, @(global_clock_event))`

### `$changing_gclk(expression, start_offset, end_offset, @(global_clock_event))`

**Description:** Checks if `expression` changed its value at least once over an interval defined by offsets from the current time relative to the `global_clock_event`. The interval is from `start_offset` ticks to `end_offset` ticks *after* the current time. Equivalent to `!$steady_gclk(...)`.

**Usage:**

`$changing_gclk(expression, start_offset, end_offset, @(global_clock_event))`

These sampled value functions, especially the `_gclk` variants, provide powerful capabilities for writing complex assertions that relate signal behavior across different clock domains or examine historical and future values relative to a clock edge.

## Coverage Control Functions
Functions for controlling and querying coverage information.
These tasks and functions allow you to:
* Control when coverage is collected.
* Query the state of coverage points.
* Save and load coverage data.
* Merge coverage results from different simulation runs.

Consider the following example module with a simple `covergroup` to illustrate some of these functions:

```systemverilog
module coverage_control_example;

  logic [1:0] state;
  integer sim_time;

  // Define a simple covergroup
  covergroup state_cg @(posedge clk);
    option.per_instance = 1; // Track coverage per instance
    state_cp : coverpoint state {
      bins s0 = (0);
      bins s1 = (1);
      bins s2 = (2);
      bins s3 = (3);
    }
  endgroup

  state_cg cg_inst; // Instance of the covergroup

  logic clk = 0; // Clock for covergroup sampling

  // Clock generator
  initial begin
    forever #10 clk = ~clk;
  end

  // Stimulus and Coverage Control
  initial begin
    $display("Time %0t: Simulation starts.", $time);
    sim_time = $time;

    // Set the name for the coverage database file (optional, often done via simulator command)
    // $set_coverage_db_name("my_coverage.ucdb");

    // Instantiate the covergroup
    cg_inst = new();
    $display("Time %0t: Covergroup instantiated.", $time);

    // Coverage is usually ON by default, but we can explicitly control it
    $display("Time %0t: Calling $coverage_control(1) - Ensure coverage is ON.", $time);
    $coverage_control(1); // 1 means ENABLE

    #20; state = 0; // @20 (posedge clk) - sample state=0
    #20; state = 1; // @40 (posedge clk) - sample state=1
    #20; state = 2; // @60 (posedge clk) - sample state=2

    #15; // Between clock edges
    $display("Time %0t: Calling $coverage_control(0) - Disable coverage.", $time);
    $coverage_control(0); // 0 means DISABLE

    #20; state = 3; // @80 (posedge clk) - will NOT be sampled because coverage is off
    #20; state = 0; // @100 (posedge clk) - will NOT be sampled because coverage is off

    #15; // Between clock edges
    $display("Time %0t: Calling $coverage_control(1) - Enable coverage again.", $time);
    $coverage_control(1); // ENABLE

    #20; state = 1; // @120 (posedge clk) - sample state=1 again
    #20; state = 3; // @140 (posedge clk) - sample state=3

    $display("\nTime %0t: Querying coverage...", $time);

    // Query maximum possible hits and current hits for a bin
    $display("Time %0t: Max hits for bin s0: %0d", $time, $coverage_get_max(cg_inst.state_cp.s0));
    $display("Time %0t: Current hits for bin s0: %0d", $time, $coverage_get(cg_inst.state_cp.s0));

    $display("Time %0t: Max hits for bin s3: %0d", $time, $coverage_get_max(cg_inst.state_cp.s3));
    $display("Time %0t: Current hits for bin s3: %0d", $time, $coverage_get(cg_inst.state_cp.s3));

    // Query overall coverage percentage for the covergroup instance
    $display("Time %0t: Overall coverage percentage: %f %%", $time, $get_coverage(cg_inst));

    // Save the collected coverage data to the database file
    $display("\nTime %0t: Calling $coverage_save()", $time);
    $coverage_save();
    // The actual file name is determined by $set_coverage_db_name or simulator options

    #20;
    $display("Time %0t: Simulation ends.", $time);
    $finish;
  end

  // Example of how you might load/merge (conceptual - requires setup)
  /*
  initial begin
      #1000; // Do this at the end or in a separate run
      $display("Loading and merging coverage...");
      // Assuming 'run1.ucdb' exists from a previous simulation run
      // $load_coverage_db("run1.ucdb");
      // $coverage_merge("cg_inst", "cg_inst", "run1.ucdb", "cg_inst"); // Merge cg_inst from run1 into current cg_inst
      $display("Merge potentially done, save again if needed.");
      // $coverage_save("merged_coverage.ucdb");
  end
  */

endmodule
```

Let's describe the functions based on the example and general usage:

### `$coverage_control`

**Description:** Controls whether coverage collection is active.
* `$coverage_control(1);`: Enables coverage collection.
* `$coverage_control(0);`: Disables coverage collection.
* You can optionally specify a specific covergroup instance or scope to control collection more granularly.

**Example Usage (in the code):** Used to turn coverage off between time 75 and 115, demonstrating that samples occurring during this period (`state=3` at @80, `state=0` at @100) are not recorded.

### `$coverage_get_max`

**Description:** Returns the maximum possible hit count for a specific coverage point (like a bin or a cross product bin). This is typically 1 for simple bins unless specified otherwise (`option.at_least`).

**Usage:**

`$coverage_get_max(covergroup_instance.coverage_point_name)`

**Example Usage (in the code):** Used to query the maximum hits for `s0` and `s3` bins. For simple bins, this is 1.

### `$coverage_get`

**Description:** Returns the current actual hit count for a specific coverage point.

**Usage:**

`$coverage_get(covergroup_instance.coverage_point_name)`

**Example Usage (in the code):** Used to query the current hits for `s0` and `s3` bins. `s0` is hit once (@20), `s3` is hit once (@140), as coverage was off at @80.

### `$get_coverage`

**Description:** Returns the coverage percentage (0.0 to 100.0) for a specified covergroup instance, a specific coverage point, or an entire hierarchical scope.

**Usage:**

`$get_coverage(covergroup_instance_or_scope_name)`

**Example Usage (in the code):** Used to query the overall coverage percentage for the `cg_inst` covergroup instance. It will calculate the percentage based on how many bins have been hit at least once (3 out of 4 bins are hit in this example).

### `$set_coverage_db_name`

**Description:** Sets the file name for the coverage database that will be generated when `$coverage_save` is called. This is often controlled by simulator command-line options instead, but this task provides an in-simulation method.

**Usage:**

`$set_coverage_db_name(string_file_name)`

**Example Usage (commented out in the code):** Shows how you would specify a custom name like "my\_coverage.ucdb".

### `$coverage_save`

**Description:** Writes the currently collected coverage data to a database file. The file name is determined by the most recent `$set_coverage_db_name` call or simulator options. This task is crucial for generating the files used by coverage analysis tools.

**Usage:**

`$coverage_save([string_message])` - An optional message can be added to the saved data.

**Example Usage (in the code):** Called towards the end of the simulation to save the accumulated coverage results.

### `$load_coverage_db`

**Description:** Loads coverage data from an existing coverage database file into the current simulation environment. This is typically the first step before merging coverage data from multiple runs.

**Usage:**

`$load_coverage_db(string_file_name)`

**Example Usage (conceptual, commented out):** Shows how you would load a previously saved file, e.g., from a different simulation run.

### `$coverage_merge`

**Description:** Merges coverage data from a source covergroup instance or scope (potentially from a loaded database) into a target covergroup instance or scope in the current simulation. This is used to combine coverage results from different simulations to get a cumulative coverage view.

**Usage:**

`$coverage_merge(target_scope, source_scope [, source_file_name, source_scope_in_file])`

**Example Usage (conceptual, commented out):** Illustrates the complexity of merging, requiring specification of both source and target scopes, potentially across different files.

These coverage tasks and functions provide powerful capabilities for managing the complex process of functional coverage sign-off in verification.

## Probabilistic Distribution Functions
Functions for generating random numbers based on various statistical distributions.
These functions are often seeded using the `$random` function's seed argument to ensure repeatable random sequences for debugging.

### `$random`

**Description:**

The `$random` function is the basic built-in random number generator. When called without arguments, it returns a new 32-bit signed integer value each time. If called with an integer argument (a seed), it reseeds the generator and returns a new value. Passing the same seed in different simulation runs will produce the same sequence of random numbers.

**Usage:**

-   `$random`: Returns a new 32-bit signed random integer.
-   `$random(seed)`: Reseeds the generator with the given `seed` and returns a new 32-bit signed random integer.

**Return Type:** `integer` (32-bit signed)

### `$dist_uniform`

**Description:**

The `$dist_uniform(seed, high, low)` function generates a random integer uniformly distributed between `low` and `high`, inclusive. Each integer within the range has an equal probability of being generated.

**Parameters:**

-   `seed`: An integer used to seed the random sequence for this distribution.
-   `high`: The upper bound of the uniform range (integer).
-   `low`: The lower bound of the uniform range (integer). `low` must be less than or equal to `high`.

**Return Type:** `integer`

### `$dist_normal`

**Description:**

The `$dist_normal(seed, mean, standard_deviation)` function generates a random real number following a normal (Gaussian) distribution with the specified `mean` and `standard_deviation`. Values near the mean are more likely, and the probability decreases as you move further away from the mean.

**Parameters:**

-   `seed`: An integer seed.
-   `mean`: The mean (average) of the distribution (`real`).
-   `standard_deviation`: A measure of the spread of the distribution (`real`, must be non-negative).

**Return Type:** `real`

### `$dist_exponential`

**Description:**

The `$dist_exponential(seed, mean)` function generates a random real number following an exponential distribution with the specified `mean`. This distribution is often used to model the time between events in a Poisson process. The mean is also the reciprocal of the rate parameter ($\lambda$).

**Parameters:**

-   `seed`: An integer seed.
-   `mean`: The mean of the distribution (`real`, must be positive).

**Return Type:** `real`

### `$dist_poisson`

**Description:**

The `$dist_poisson(seed, mean)` function generates a random integer following a Poisson distribution with the specified `mean` ($\lambda$). This distribution models the number of events occurring in a fixed interval of time or space if these events occur with a known constant mean rate and independently of the time since the last event.

**Parameters:**

-   `seed`: An integer seed.
-   `mean`: The mean number of events (`real`, must be positive).

**Return Type:** `integer`

### `$dist_chi_square`

**Description:**

The `$dist_chi_square(seed, degrees_of_freedom)` function generates a random real number following a chi-square distribution with the specified `degrees_of_freedom`. This distribution is often used in statistics, particularly in hypothesis testing and confidence interval construction.

**Parameters:**

-   `seed`: An integer seed.
-   `degrees_of_freedom`: The number of degrees of freedom (`integer`, must be positive).

**Return Type:** `real`

### `$dist_erlang`

**Description:**

The `$dist_erlang(seed, k, mean)` function generates a random real number following an Erlang distribution. The Erlang distribution is related to the exponential distribution; it describes the time until *k* events occur in a Poisson process with a certain mean time between events.

**Parameters:**

-   `seed`: An integer seed.
-   `k`: The shape parameter (number of events) (`integer`, must be positive).
-   `mean`: The mean of the related exponential distribution (`real`, must be positive). Note that the mean of the Erlang distribution itself is $k \times mean$.

**Return Type:** `real`

### `$dist_t`

**Description:**

The `$dist_t(seed, degrees_of_freedom)` function generates a random real number following a Student's t-distribution with the specified `degrees_of_freedom`. The t-distribution is symmetric and bell-shaped, similar to the normal distribution, but has heavier tails. As the degrees of freedom increase, the t-distribution approaches the normal distribution.

**Parameters:**

-   `seed`: An integer seed.
-   `degrees_of_freedom`: The number of degrees of freedom (`integer`, must be positive).

**Return Type:** `real`

### Example Demonstrating Distribution Functions

```systemverilog
module distribution_functions_example;

  // Use a fixed seed for repeatable results, or $random without seed for different results each run
  integer my_seed = 123;

  initial begin
    $display("--- Probabilistic Distribution Examples ---");

    $display("\nBasic $random (32-bit signed integer):");
    $display("$random: %0d", $random(my_seed)); // Seed and get first value
    $display("$random: %0d", $random());       // Get next value in sequence
    $display("$random: %0d", $random());       // Get next value
    $display("$random(123): %0d", $random(123)); // Reseed and get first value for seed 123
    $display("$random(): %0d", $random());       // Get next value from reseeded sequence

    $display("\n$dist_uniform (integer between 1 and 10):");
    $display("$dist_uniform: %0d", $dist_uniform(my_seed + 1, 10, 1)); // Seed and get value
    $display("$dist_uniform: %0d", $dist_uniform(my_seed + 1, 10, 1)); // Same seed -> same first value
    $display("$dist_uniform: %0d", $dist_uniform(my_seed + 2, 10, 1)); // Different seed

    $display("\n$dist_normal (mean=0.0, std_dev=1.0 - Standard Normal):");
    $display("$dist_normal: %f", $dist_normal(my_seed + 3, 0.0, 1.0));
    $display("$dist_normal: %f", $dist_normal(my_seed + 3, 0.0, 1.0)); // Same seed
    $display("$dist_normal: %f", $dist_normal(my_seed + 4, 5.0, 2.0)); // Different parameters

    $display("\n$dist_exponential (mean=5.0):");
    $display("$dist_exponential: %f", $dist_exponential(my_seed + 5, 5.0));
    $display("$dist_exponential: %f", $dist_exponential(my_seed + 5, 5.0));
    $display("$dist_exponential: %f", $dist_exponential(my_seed + 6, 1.0));

    $display("\n$dist_poisson (mean=3.0):");
    $display("$dist_poisson: %0d", $dist_poisson(my_seed + 7, 3.0));
    $display("$dist_poisson: %0d", $dist_poisson(my_seed + 7, 3.0));
    $display("$dist_poisson: %0d", $dist_poisson(my_seed + 8, 0.5));

    $display("\n$dist_chi_square (dof=5):");
    $display("$dist_chi_square: %f", $dist_chi_square(my_seed + 9, 5));
    $display("$dist_chi_square: %f", $dist_chi_square(my_seed + 9, 5));
    $display("$dist_chi_square: %f", $dist_chi_square(my_seed + 10, 1));

    $display("\n$dist_erlang (k=2, mean=4.0):");
    $display("$dist_erlang: %f", $dist_erlang(my_seed + 11, 2, 4.0)); // Erlang mean = k * mean_exp = 2 * 4 = 8
    $display("$dist_erlang: %f", $dist_erlang(my_seed + 11, 2, 4.0));
    $display("$dist_erlang: %f", $dist_erlang(my_seed + 12, 3, 1.0)); // Erlang mean = 3 * 1 = 3

    $display("\n$dist_t (dof=10):");
    $display("$dist_t: %f", $dist_t(my_seed + 13, 10));
    $display("$dist_t: %f", $dist_t(my_seed + 13, 10));
    $display("$dist_t: %f", $dist_t(my_seed + 14, 2)); // Lower DOF -> heavier tails

    $finish;
  end

endmodule
```

**Explanation:**

The example demonstrates how to call each distribution function.

-   For `$random`, it shows how subsequent calls without a seed continue the sequence, while a call with a seed reseeds the generator.
-   For all `$dist_` functions, the first argument is a seed specific to that distribution generator instance. Using the same seed for a given distribution function will produce the same sequence of random numbers from that distribution, allowing for repeatability in simulations. Using different seeds or incrementing the seed (as shown with `my_seed + N`) generates different sequences.
-   The subsequent arguments are the parameters specific to the distribution (e.g., high/low for uniform, mean/std\_dev for normal, etc.).
-   Notice that `$dist_uniform` and `$dist_poisson` return integers, while the others return `real` values.

By using these distribution functions, you can generate stimulus that mimics real-world conditions or stress test specific scenarios based on statistical models, which is a key part of effective testbench development.

## Stochastic Analysis Tasks and Functions
Tasks and functions related to modeling queues for performance analysis.
These functions model a first-in, first-out (FIFO) queue and allow you to track its size, fullness, and get statistical data without needing to build a detailed RTL model of the queue itself.

### `$q_initialize`

**Description:**

Initializes a queue model for stochastic analysis. You provide a queue identifier (an integer or bit vector) to refer to this specific queue in subsequent calls. You can optionally specify a maximum capacity for the queue.

**Usage:**

`$q_initialize(queue_id [, capacity]);`

-   `queue_id`: An integer or bit vector identifier for the queue.
-   `capacity`: An optional integer specifying the maximum number of items the queue can hold. If omitted, the queue has unlimited capacity.

### `$q_add`

**Description:**

Adds an item to the specified queue. If the queue has a finite capacity and is full, the item is not added.

**Usage:**

`$q_add(queue_id);`

-   `queue_id`: The identifier of the queue to add an item to.

### `$q_remove`

**Description:**

Removes an item from the specified queue. If the queue is empty, no item is removed.

**Usage:**

`$q_remove(queue_id);`

-   `queue_id`: The identifier of the queue to remove an item from.

### `$q_full`

**Description:**

A function that returns a boolean value (1 for true, 0 for false) indicating whether the specified queue is currently full. This is only relevant for queues initialized with a finite capacity.

**Usage:**

`$q_full(queue_id)`

-   `queue_id`: The identifier of the queue to check.

**Return Type:** `integer` (1 or 0)

### `$q_exam`

**Description:**

Retrieves statistical data about the specified queue. You provide the queue identifier and a code indicating which statistic to retrieve.

**Usage:**

`$q_exam(queue_id, code)`

-   `queue_id`: The identifier of the queue to examine.
-   `code`: An integer specifying the statistic to return:
    -   `1`: Returns the current number of items in the queue.
    -   `2`: Returns the maximum number of items that have been in the queue simultaneously since initialization.
    -   `3`: Returns the average number of items in the queue over time.
    -   `4`: Returns the total number of items that have been added to the queue.
    -   `5`: Returns the total number of items that have been removed from the queue.
    -   `6`: Returns the total time that the queue has been empty.
    -   `7`: Returns the total time that the queue has been full (only for finite capacity queues).
    -   `8`: Returns the total time the queue has existed since initialization.

**Return Type:** `real` (for average time, total time statistics) or `integer` (for counts, max size).

### Example Demonstrating Queue Functions

```systemverilog
module queue_analysis_example;

  parameter QUEUE_ID = 1;
  parameter QUEUE_CAPACITY = 3; // Finite capacity for this example

  logic clk = 0;
  integer sim_time;

  // Clock generator
  initial begin
    forever #10 clk = ~clk;
  end

  initial begin
    $display("Time %0t: Simulation starts.", $time);
    sim_time = $time;

    // Initialize the queue with a capacity
    $q_initialize(QUEUE_ID, QUEUE_CAPACITY);
    $display("Time %0t: Queue %0d initialized with capacity %0d.", $time, QUEUE_ID, QUEUE_CAPACITY);

    // Add some items
    #15; // @15
    $display("Time %0t: Adding item to queue %0d. Full? %0d", $time, QUEUE_ID, $q_full(QUEUE_ID));
    $q_add(QUEUE_ID);
    $display("Time %0t: Current items: %0d", $time, $q_exam(QUEUE_ID, 1));

    #10; // @25
    $display("Time %0t: Adding item to queue %0d. Full? %0d", $time, QUEUE_ID, $q_full(QUEUE_ID));
    $q_add(QUEUE_ID);
    $display("Time %0t: Current items: %0d", $time, $q_exam(QUEUE_ID, 1));

    #10; // @35
     $display("Time %0t: Adding item to queue %0d. Full? %0d", $time, QUEUE_ID, $q_full(QUEUE_ID));
    $q_add(QUEUE_ID); // Queue is now full
    $display("Time %0t: Current items: %0d", $time, $q_exam(QUEUE_ID, 1));
    $display("Time %0t: Queue %0d Full? %0d", $time, QUEUE_ID, $q_full(QUEUE_ID));


    #10; // @45
    $display("Time %0t: Adding item to queue %0d (should fail, queue is full). Full? %0d", $time, QUEUE_ID, $q_full(QUEUE_ID));
    $q_add(QUEUE_ID); // This item is NOT added
    $display("Time %0t: Current items: %0d", $time, $q_exam(QUEUE_ID, 1));

    // Remove some items
    #15; // @60
    $display("Time %0t: Removing item from queue %0d. Full? %0d", $time, QUEUE_ID, $q_full(QUEUE_ID));
    $q_remove(QUEUE_ID);
    $display("Time %0t: Current items: %0d", $time, $q_exam(QUEUE_ID, 1));
    $display("Time %0t: Queue %0d Full? %0d", $time, QUEUE_ID, $q_full(QUEUE_ID));


    #10; // @70
    $display("Time %0t: Removing item from queue %0d. Full? %0d", $time, QUEUE_ID, $q_full(QUEUE_ID));
    $q_remove(QUEUE_ID);
    $display("Time %0t: Current items: %0d", $time, $q_exam(QUEUE_ID, 1));

    #20; // @90
    $display("Time %0t: Examining final queue statistics:", $time);
    $display("  Total items added: %0d", $q_exam(QUEUE_ID, 4));
    $display("  Total items removed: %0d", $q_exam(QUEUE_ID, 5));
    $display("  Maximum items in queue: %0d", $q_exam(QUEUE_ID, 2));
    $display("  Current items in queue: %0d", $q_exam(QUEUE_ID, 1));
    $display("  Total queue existence time: %f", $q_exam(QUEUE_ID, 8));
    $display("  Total time queue was empty: %f", $q_exam(QUEUE_ID, 6));
    $display("  Total time queue was full: %f", $q_exam(QUEUE_ID, 7));
    $display("  Average items in queue: %f", $q_exam(QUEUE_ID, 3));


    $finish;
  end

endmodule
```

**Explanation:**

The example simulates a queue with a capacity of 3.

1.  **Initialization:** `$q_initialize(1, 3)` creates a queue model with ID 1 and capacity 3.
2.  **Adding Items:** Items are added at @15, @25, and @35 using `$q_add`. The `$q_full` function is checked before each addition, showing it becomes true after the third item is added.
3.  **Adding to Full Queue:** An attempt to add an item at @45 fails because `$q_full(1)` returns 1. The item count remains at 3.
4.  **Removing Items:** Items are removed at @60 and @70 using `$q_remove`, reducing the item count.
5.  **Examining Statistics:** At the end of the simulation (@90), `$q_exam` is used with different codes to print various statistics:
    * Code 1: Current items (1 at @90).
    * Code 4: Total added (3 successful additions).
    * Code 5: Total removed (2 removals).
    * Code 2: Maximum items (reached 3).
    * Code 8: Total time the queue existed (@90).
    * Code 6: Total time the queue was empty (from time 0 to @15, and from @70 to @90).
    * Code 7: Total time the queue was full (from @35 to @60).
    * Code 3: Average items in the queue over the simulation time.

These queue modeling functions provide a high-level way to analyze the performance characteristics of queuing systems within your SystemVerilog simulation.

## PLA Modeling Tasks
Tasks for modeling Programmable Logic Arrays (PLAs).
The names of these tasks follow a pattern:
`$async/sync $logic_type $output_type ( outputs, inputs, [control_signals] );`

-   **`async` vs `sync`**: Determines if the outputs are combinatorial (`async`) or registered on a clock edge (`sync`). Synchronous tasks require clock and potentially set/reset inputs.
-   **`logic_type`**: Specifies the type of logic performed by the **second stage**.
    * `and`/`nand`: The second stage gates perform AND or NAND on the product terms from the AND plane.
    * `or`/`nor`: The second stage gates perform OR or NOR on the product terms from the AND plane (this is the most common PLA structure - Sum of Products).
-   **`output_type`**: Specifies what outputs are being modeled.
    * `plane`: The outputs represent the individual product terms *from the AND plane*.
    * `array`: The outputs represent the results *from the second stage logic* (the combined "sum of products" or equivalent).

The inputs to these tasks typically define the connectivity of the AND plane (which inputs form which product terms) and the second stage (which product terms connect to which output gates). The exact syntax for defining these connections can be complex and varies slightly between simulators and SystemVerilog versions, often involving concatenated vectors or arrays representing the AND/OR matrices. For simplicity in the examples below, we'll represent the AND/OR plane logic conceptually in comments and focus on the task calls and resulting behavior.

### Example Demonstrating PLA Tasks

Let's model a simple PLA that takes two inputs (`a`, `b`) and generates:
1.  The individual product terms (`a&b`, `a&~b`, `~a&b`, `~a&~b`).
2.  A sum-of-products output (`a OR b`).

```systemverilog
module pla_modeling_example;

  logic a, b; // Inputs
  logic clk = 0; // Clock for synchronous tasks
  logic reset = 0; // Reset for synchronous tasks

  // Outputs
  logic [3:0] async_and_plane_out; // Outputs from the AND plane (4 product terms)
  logic async_or_array_out;       // Output from the OR plane (a OR b)
  logic sync_or_array_out;        // Synchronous output from the OR plane (a OR b)

  // Clock generator
  initial begin
    forever #10 clk = ~clk;
  end

  // Stimulus
  initial begin
    $display("Time %0t: Simulation starts.", $time);

    // Initial inputs
    a = 0; b = 0; #20; // @20 - posedge clk
    a = 0; b = 1; #20; // @40 - posedge clk
    a = 1; b = 0; #20; // @60 - posedge clk
    a = 1; b = 1; #20; // @80 - posedge clk

    reset = 1; #10; reset = 0; // @90 - Apply and release reset

    a = 0; b = 0; #20; // @110 - posedge clk (after reset)
    a = 0; b = 1; #20; // @130 - posedge clk
    a = 1; b = 0; #20; // @150 - posedge clk
    a = 1; b = 1; #20; // @170 - posedge clk


    #30;
    $display("Time %0t: Simulation ends.", $time);
    $finish;
  end

  // --- PLA Modeling Tasks ---

  // Modeling the AND plane outputs asynchronously
  // Product terms: P0 = a&b, P1 = a&~b, P2 = ~a&b, P3 = ~a&~b
  // Inputs: {a, b} (2 inputs)
  // Connections implicitly define which inputs form which product term
  // (This is where the task arguments get complex in real usage,
  // but we'll assume the task call correctly models these 4 terms)
  initial begin
    $async$and$plane(async_and_plane_out, {a, b});
  end

  // Modeling the OR plane output asynchronously (Sum of Products)
  // Output: async_or_array_out = P0 OR P1 OR P2 OR P3
  // Or, more directly: async_or_array_out = (a&b) | (a&~b) | (~a&b) | (~a&~b)  -- This simplifies to a | b
  // Inputs: {a, b} (2 inputs)
  // Connections implicitly define which product terms are ORed for this output
   initial begin
     $async$or$array(async_or_array_out, {a, b});
   end


  // Modeling the OR plane output synchronously (Registered Sum of Products)
  // Output: sync_or_array_out = register((a&b) | (a&~b) | (~a&b) | (~a&~b))
  // Inputs: {a, b} (2 inputs)
  // Connections implicitly define AND and OR logic
  // Control: posedge clk, async reset (active high)
  initial begin
    $sync$or$array(sync_or_array_out, {a, b}, posedge clk, reset);
  end


  // Monitor outputs
  initial begin
    $monitor("Time %0t: a=%b, b=%b, async_and_plane_out=%b, async_or_array_out=%b, sync_or_array_out=%b, reset=%b",
             $time, a, b, async_and_plane_out, async_or_array_out, sync_or_array_out, reset);
  end

endmodule
```

Let's describe the tasks used in the example:

### `$async$and$plane`

**Description:** Models the asynchronous outputs directly from the AND plane. Each bit of the `async_and_plane_out` vector corresponds to a product term result. If the inputs matching a product term are all high (and correctly configured in the task call), the corresponding output bit is high.

**Example Usage (in the code):** Used to model the 4 product terms (`a&b`, `a&~b`, `~a&b`, `~a&~b`) based on the inputs `a` and `b`. The `async_and_plane_out` will show the results of these AND operations.

### `$async$or$array`

**Description:** Models the asynchronous outputs from the OR plane (the second stage), which performs an OR operation on selected product terms from the AND plane. The output is a single vector representing the combined results.

**Usage:**

`$async$or$array(output_vector, inputs, [connection_parameters]);`
* `output_vector`: The output representing the ORed product terms.
* `inputs`: The inputs to the AND plane.
* `connection_parameters`: Defines the AND and OR plane connections (complex, often implicit or via arguments).

**Example Usage (in the code):** Used to model the `a OR b` logic, which is a sum-of-products using the four product terms from the AND plane. The `async_or_array_out` will reflect `a | b` combinatorially.

### `$sync$or$array`

**Description:** Models the synchronous (clocked) outputs from the OR plane. The output is registered on the specified clock edge and potentially affected by reset.

**Usage:**

`$sync$or$array(output_vector, inputs, clock, [reset, ...], [connection_parameters]);`
* `output_vector`: The registered output.
* `inputs`: Inputs to the AND plane.
* `clock`: The clocking event (e.g., `posedge clk`).
* `reset`: Optional reset signal(s).
* `connection_parameters`: Defines AND/OR plane connections.

**Example Usage (in the code):** Used to model the `a OR b` logic, but the output `sync_or_array_out` only updates on the `posedge clk` and is affected by the `reset` signal (which is active high in this example).

### Other Tasks:

-   **`$async/sync$and/nand$plane`**: Model AND/NAND plane outputs (individual product terms), asynchronous or synchronous.
-   **`$async/sync$and/nand$array`**: Model AND/NAND second stage logic (AND or NAND of product terms), asynchronous or synchronous.
-   **`$async/sync$nor$array`**: Model NOR second stage logic (NOR of product terms), asynchronous or synchronous.
-   **`$async/sync$or/nor$plane`**: Model OR/NOR plane outputs. *Note: This type of task is less common or may have specific interpretations, as the primary 'plane' output usually refers to the AND plane product terms.* The documentation for these might refer to modeling the outputs *before* the OR/NOR gates, which effectively means the AND plane outputs.

**Expected Behavior in the Example:**

-   `async_and_plane_out`: Will immediately reflect the results of the four AND product terms based on the current values of `a` and `b`.
-   `async_or_array_out`: Will immediately reflect the result of `a | b` based on the current values of `a` and `b`.
-   `sync_or_array_out`: Will reflect the result of `a | b` from the *previous* `posedge clk`. When `reset` is high, it will likely go to a default reset value (often 0).

These PLA modeling tasks are specialized and less frequently used in modern SystemVerilog verification compared to higher-level abstraction like classes or SystemVerilog assertions. They are primarily for modeling legacy or specific hardware structures at a behavioral level. The complexity lies primarily in correctly specifying the AND and second-stage logic connections within the task arguments, which is heavily dependent on the simulator's interpretation of the standard.

## Miscellaneous Tasks and Functions
Other general-purpose system tasks and functions.
### `$system`

**Description:**

The `$system` task allows you to execute an operating system command directly from within your SystemVerilog simulation. When `$system` is called, the simulation's execution is suspended, the specified command is executed by the operating system, and once the command finishes, the simulation resumes from where it left off.

This task is useful for performing tasks like:
* Running external scripts or tools during simulation.
* Manipulating files (copying, deleting, moving) that are needed by the simulation or testbench.
* Printing information about the simulation environment or files.

**Important Considerations:**

* **Security:** Executing arbitrary system commands can be a security risk. Be cautious when using `$system`, especially if the command string is derived from external inputs.
* **Portability:** The behavior and availability of specific operating system commands vary depending on the OS where the simulator is running (Windows, Linux, macOS, etc.). Use commands that are likely to be available and behave consistently across your target environments if portability is important.
* **Simulator Dependence:** While `$system` is part of the SystemVerilog standard, specific simulator implementations might have nuances or limitations.

**Usage:**

`$system(command_string);`

-   `command_string`: A string containing the operating system command to execute.

**Example:**

```systemverilog
module system_task_example;

  integer sim_time;

  initial begin
    $display("Time %0t: Simulation starts.", $time);
    sim_time = $time;

    #20;
    $display("Time %0t: Calling $system to list directory contents...", $time);

    // Execute an OS command to list files in the current directory
    // 'ls' for Linux/macOS, 'dir' for Windows
    `ifdef verilog_on_windows
      $system("dir");
    `else
      $system("ls -l");
    `endif

    $display("Time %0t: $system call finished. Simulation resumes.", $time);

    #30;
    $display("Time %0t: Simulation ends.", $time);
    $finish;
  end

endmodule
```

**Explanation:**

This example demonstrates using the `$system` task to execute an operating system command.

1.  The simulation starts and prints a message.
2.  After a delay of 20 time units, another message indicates that the `$system` task is about to be called.
3.  The code uses `ifdef` directives (`verilog_on_windows` is a common, though not standard, macro used to detect the OS) to choose the appropriate command for listing directory contents:
    * `"dir"` for Windows.
    * `"ls -l"` for Linux/macOS (lists in long format).
4.  The simulator pauses, executes the specified command in a sub-process, and waits for it to complete. The output of the OS command will typically appear in the simulator's console.
5.  Once the OS command finishes, the `$system` task returns, and the simulation resumes. A message confirming the return from the `$system` call is printed.
6.  The simulation continues for another 30 time units and then finishes.

This illustrates how `$system` allows you to integrate external command execution into your simulation flow.

## Display Tasks
Tasks for outputting text to the console or logs in various formats.
All of these tasks use format specifiers similar to the C `printf` function (e.g., `%d` for decimal, `%h` for hexadecimal, `%b` for binary, `%s` for string, `%f` for real, `%0t` for time) within a format string.

### `$display` and `$write` (Immediate Output)

**Descriptions:**

-   `$display(message_string [, arguments]);`: Evaluates the arguments and prints the formatted `message_string` immediately when the task is executed. Appends a newline character to the output.
-   `$write(message_string [, arguments]);`: Similar to `$display`, but does **not** append a newline character. Useful for printing parts of a line.

The variants (`$displayb`, `$displayo`, `$displayh`, `$writeb`, `$writeo`, `$writeh`) behave identically to `$display` and `$write` respectively, but they set the *default* format for integer and logic values (`%v`, `%V`) to binary (`b`), octal (`o`), or hexadecimal (`h`) for that specific task call. Explicit format specifiers (like `%d`, `%h`) override the default.

**Example:**

```systemverilog
module display_write_example;

  logic [7:0] my_byte = 8'hA5;
  integer count = 25;
  real pi_val = 3.14159;

  initial begin
    $display("--- $display and $write examples ---");

    // Using $display
    $display("Current time: %0t", $time);
    $display("my_byte in decimal: %0d", my_byte);

    // Using $write - notice no newline after the first $write
    $write("my_byte in hex: %h, ", my_byte);
    $display("count in decimal: %0d", count); // This completes the line

    // Using variants for default formatting
    $display("my_byte with default hex ($displayh): %v", my_byte); // %v uses default
    $displayb("my_byte with default binary ($displayb): %v", my_byte);
    $displayo("my_byte with default octal ($displayo): %v", my_byte);

    // Displaying real numbers
    $display("Value of Pi: %f", pi_val);

    $display("--- End of $display and $write examples ---");
    $finish;
  end

endmodule
```

**Explanation:**

This example shows:
-   `$display` printing time and a decimal value, each on a new line.
-   `$write` printing a hexadecimal value without a newline, followed by `$display` completing the line with a decimal value.
-   `$displayh`, `$displayb`, and `$displayo` setting the default format for `%v` within that task call, showing the same byte in hex, binary, and octal.
-   Displaying a `real` number using `%f`.

### `$monitor` (Change-Triggered Output)

**Description:**

The `$monitor` task registers a list of variables or expressions to be monitored. A message is printed *only* when the value of any item in the monitored list changes. There can only be one active `$monitor` list globally at any given time. A new `$monitor` call replaces the previous active list.

-   `$monitoron`: Enables the active `$monitor` list if it was previously disabled by `$monitoroff`. `$monitor` is typically on by default after the first call.
-   `$monitoroff`: Disables the active `$monitor` list. Messages will not be printed until `$monitoron` is called again.

The variants (`$monitorb`, `$monitoro`, `$monitorh`) set the default format for `%v`, `%V` in the monitored message string.

**Example:**

```systemverilog
module monitor_example;

  reg a = 0;
  wire b = a; // b changes when a changes
  integer count = 0;

  initial begin
    $display("--- $monitor example ---");

    // Start monitoring a and b
    $monitor("Time %0t: a=%b, b=%b, count=%0d", $time, a, b, count);

    #10; a = 1; // a changes, b changes
    #5;  count = 1; // count changes
    #10; a = 0; // a changes, b changes
    #5;  count = 2; // count changes

    $monitoroff(); // Stop monitoring

    #10; a = 1; // Changes occur, but no monitor output
    #5;  count = 3;

    $monitoron(); // Resume monitoring

    #10; a = 0; // a changes, b changes - output resumes
    #5;  count = 4; // count changes

    $display("--- End of $monitor example ---");
    $finish;
  end

endmodule
```

**Explanation:**

-   `$monitor` is called once to set up the message and the variables (`$time`, `a`, `b`, `count`) to watch.
-   A message is printed initially when the `$monitor` is set up.
-   Subsequently, a message is printed *only* when `a`, `b`, or `count` changes value. Notice that when `a` changes, `b` also changes simultaneously, triggering a single monitor event.
-   `$monitoroff` stops the output. Changes to `a` and `count` between time 30 and 45 do not produce output.
-   `$monitoron` resumes output, and changes after time 45 trigger messages again.

### `$strobe` (End-of-Time-Step Output)

**Description:**

The `$strobe` task also prints a formatted message, but it does so at a specific point in the simulation cycle: at the very end of the current time step, after all other procedural activity and events scheduled for that time step have been processed. This ensures that the values of variables printed by `$strobe` are stable and final for that time step.

The variants (`$strobeb`, `$strobeo`, `$strobeh`) set the default format for `%v`, `%V`.

**Example:**

```systemverilog
module strobe_example;

  logic data = 0;

  initial begin
    $display("--- $strobe example ---");

    // Initial display and strobe at time 0
    $display("Time %0t: $display - data = %b", $time, data);
    $strobe("Time %0t: $strobe  - data = %b", $time, data);

    #10 data = 1; // Change data at time 10

    // Display and strobe at time 10
    $display("Time %0t: $display - data = %b", $time, data); // Data is already 1
    $strobe("Time %0t: $strobe  - data = %b", $time, data); // Data will be 1 (final value at time 10)

    #10; // Move to time 20

    // Display and strobe at time 20
    $display("Time %0t: $display - data = %b", $time, data);
    $strobe("Time %0t: $strobe  - data = %b", $time, data);


    $display("--- End of $strobe example ---");
    $finish;
  end

endmodule
```

**Explanation:**

-   At time 0, both `$display` and `$strobe` are called. `$display` prints immediately. `$strobe` schedules its print for the very end of the time 0 step, but since nothing else happens at time 0 after the initial block, it prints shortly after the display. Both see `data` as 0.
-   At time 10, `data` is changed to 1.
-   The `$display` at time 10 executes immediately *after* `data` changes but *before* the end of the time 10 step. It prints `data` as 1.
-   The `$strobe` at time 10 is scheduled for the end of the time 10 step. By the time it executes, all activity for time 10 is complete, and the final value of `data` (which is 1) is printed.
-   At time 20, no changes occur, so both `$display` and `$strobe` print the stable value of `data` (which is still 1) at the end of the time step.

The key difference is timing: `$display` and `$write` print when executed, while `$strobe` waits until the end of the current simulation time step, ensuring it reports the final values for that time step. `$monitor` is unique as it triggers based on value changes across time steps.

## File I/O Tasks and Functions
Tasks and functions for interacting with files, including opening, closing, reading, and writing.
### File Handling

These tasks manage the connection between your simulation and external files.

-   `$fopen(string_file_name [, string_mode])`: Opens a file specified by `string_file_name`.
    * `string_mode`: Specifies the file access mode. Common modes include:
        * `"r"`: Read mode. File must exist.
        * `"w"`: Write mode. Creates the file if it doesn't exist, overwrites if it does.
        * `"a"`: Append mode. Creates the file if it doesn't exist, writes to the end if it does.
        * `"r+"`, `"w+"`, `"a+"`: Read and update modes.
    * Returns a multi-channel descriptor (an integer). A value of 0 indicates failure. This descriptor is used by subsequent file I/O tasks. SystemVerilog allows writing to multiple files simultaneously using bit flags in the descriptor. Standard output is represented by descriptor 1, standard error by 2.
-   `$fclose(multi_channel_descriptor)`: Closes the file(s) associated with the given descriptor. Returns 0 on success, EOF on failure.

**Example:**

```systemverilog
module file_handling_example;

  integer file_desc;
  integer status;

  initial begin
    $display("--- File Handling Example ---");

    // Open a file for writing
    file_desc = $fopen("output.txt", "w");

    if (file_desc) begin
      $display("Time %0t: Successfully opened output.txt for writing (descriptor %0d).", $time, file_desc);

      // Write some data (details in file writing section below)
      $fwrite(file_desc, "This is the first line.\n");
      $fwrite(file_desc, "This is the second line.\n");

      // Close the file
      status = $fclose(file_desc);
      if (status == 0) begin
        $display("Time %0t: Successfully closed output.txt.", $time);
      end else begin
        $error("Time %0t: Error closing output.txt.", $time);
      end
    end else begin
      $error("Time %0t: Failed to open output.txt.", $time);
    end

    $display("--- End of File Handling Example ---");
    $finish;
  end

endmodule
```

**Explanation:**

This example attempts to open a file named "output.txt" in write mode. If successful, it prints a message, writes two lines using `$fwrite` (described later), then closes the file using `$fclose` and checks the return status.

### File Status

These functions check the state of a file connection.

-   `$feof(file_descriptor)`: Returns 1 (true) if the end-of-file (EOF) has been reached for the file associated with the descriptor during a read operation, otherwise returns 0 (false).
-   `$ferror(file_descriptor)`: Returns a non-zero integer if an error has occurred during a previous file operation on the descriptor, otherwise returns 0.

**Example:**

```systemverilog
module file_status_example;

  integer file_desc;

  initial begin
    $display("--- File Status Example ---");

    // Create a dummy file first
    file_desc = $fopen("temp.txt", "w");
    if (file_desc) begin
        $fwrite(file_desc, "Hello\nWorld\n");
        $fclose(file_desc);
    end

    // Now open for reading
    file_desc = $fopen("temp.txt", "r");

    if (file_desc) begin
      $display("Time %0t: Opened temp.txt for reading (descriptor %0d).", $time, file_desc);

      // Read character by character until EOF
      while (!$feof(file_desc)) begin
        integer char = $fgetc(file_desc); // Use fgetc, described below
        if (char != EOF) begin
           // Process character (or just move the file pointer)
        end
        // Check for error after each operation (optional but good practice)
        if ($ferror(file_desc)) begin
            $error("Time %0t: File error detected while reading.", $time);
            break;
        end
      end
      $display("Time %0t: Reached end of file (EOF = %0d).", $time, $feof(file_desc));

      $fclose(file_desc);
    end else begin
      $error("Time %0t: Failed to open temp.txt.", $time);
    end

    $display("--- End of File Status Example ---");
    $finish;
  end

endmodule
```

**Explanation:**

This example first creates and writes to a temporary file. Then it opens the same file for reading. It uses a `while` loop with `$feof` as the condition to read character by character until the end of the file is reached. Inside the loop, it also demonstrates checking for errors using `$ferror` after each read operation.

### File Reading

These functions read data from an opened file.

-   `$fgetc(file_descriptor)`: Reads a single character from the file specified by the descriptor and returns its ASCII value as an integer. Returns EOF (typically -1) if the end of the file is reached or if an error occurs.
-   `$fgets(string_variable, file_descriptor)`: Reads a line of text from the file into `string_variable`. Reading stops at the first newline character, EOF, or when the string variable is full. The newline character is included in the returned string. Returns the `string_variable` on success, `""` on EOF or error.
-   `$fread(data_variable, file_descriptor [, string_format_string])`: Reads data from the file and interprets it according to the optional `string_format_string` or the type of `data_variable`. Similar to `$fscanf`, but designed for binary reads or reads with specific formats.
-   `$fscanf(file_descriptor, format_string, argument1 [, argument2, ...])`: Reads data from the file, parses it according to the `format_string`, and assigns the results to the specified arguments. Similar to the C `fscanf`. Returns the number of input items successfully matched and assigned, or EOF if the end-of-file is reached before any items are matched.

**Example:**

```systemverilog
module file_reading_example;

  integer file_desc;
  integer char;
  string line;
  integer val1, val2;
  real real_val;

  initial begin
    $display("--- File Reading Example ---");

    // Create a dummy file with different data types
    file_desc = $fopen("read_test.txt", "w");
    if (file_desc) begin
      $fdisplay(file_desc, "Character: A");
      $fdisplay(file_desc, "Line one");
      $fdisplay(file_desc, "Line two");
      $fdisplay(file_desc, "Integers: 123 456");
      $fdisplay(file_desc, "Real: 7.89");
      $fclose(file_desc);
    end

    // Now open for reading
    file_desc = $fopen("read_test.txt", "r");

    if (file_desc) begin
      $display("Time %0t: Opened read_test.txt for reading.", $time);

      // Read a single character
      char = $fgetc(file_desc);
      if (char != EOF) $display("Time %0t: Read character: %c (%0d)", $time, char, char);

      // Read lines using $fgets
      line = $fgets(line, file_desc);
      if (line != "") $display("Time %0t: Read line 1: %s", $time, line);
      line = $fgets(line, file_desc);
      if (line != "") $display("Time %0t: Read line 2: %s", $time, line);

      // Read formatted data using $fscanf
      if ($fscanf(file_desc, "Integers: %0d %0d", val1, val2) == 2) begin
        $display("Time %0t: Read integers: %0d, %0d", $time, val1, val2);
      end else begin
         $error("Time %0t: Failed to read integers.", $time);
      end

       // Read formatted real using $fscanf
      if ($fscanf(file_desc, "Real: %f", real_val) == 1) begin
         $display("Time %0t: Read real: %f", $time, real_val);
      end else begin
          $error("Time %0t: Failed to read real.", $time);
      end


      // $fread example (conceptual - often used for binary, less common for text)
      // For text, $fscanf or manual parsing is more typical.
      // integer byte_val;
      // if ($fread(byte_val, file_desc, "%c") == 1) // Read one character as an integer
      //    $display("Time %0t: Read byte with $fread: %0d", $time, byte_val);


      $fclose(file_desc);
    end else begin
      $error("Time %0t: Failed to open read_test.txt.", $time);
    end

    $display("--- End of File Reading Example ---");
    $finish;
  end

endmodule
```

**Explanation:**

This example demonstrates reading different data types from a file:
-   `$fgetc` reads the first character.
-   `$fgets` reads two full lines (including the newline characters).
-   `$fscanf` is used with format strings to parse integers and a real number from lines that follow specific patterns. It checks the return value to confirm the expected number of items were successfully read.

### String Formatting (to Memory)

These tasks format data into a string variable in memory.

-   `$swrite(string_variable, format_string [, arguments])`: Formats the arguments according to `format_string` and writes the result into `string_variable`. Does **not** append a newline.
-   `$swriteb`, `$swriteo`, `$swriteh`: Variants of `$swrite` that set the default format for `%v`, `%V` to binary, octal, or hexadecimal.
-   `$sformat(string_variable, format_string [, arguments])`: Similar to `$swrite`, but intended for use within expression contexts (e.g., for arguments to other tasks). It returns an integer indicating success.
-   `$sformatf(format_string [, arguments])`: Formats the arguments according to `format_string` and returns the result as a `string`. This is very useful for creating strings dynamically.

**Example:**

```systemverilog
module string_formatting_example;

  integer count = 42;
  real value = 1.23;
  string message_str;
  string formatted_str;

  initial begin
    $display("--- String Formatting Example ---");

    // Using $swrite
    $swrite(message_str, "Count: %0d, Value: %f", count, value);
    $display("Formatted string via $swrite: %s", message_str);

     // Using $swriteb (default binary)
    $swriteb(message_str, "Count binary: %v", count);
    $display("Formatted string via $swriteb: %s", message_str);

    // Using $sformatf (returns string)
    formatted_str = $sformatf("Dynamic message: Time is %0t, Count is %0d", $time, count);
    $display("Formatted string via $sformatf: %s", formatted_str);

    // Using $sformat (often in expressions, here shown for value assignment)
    integer success = $sformat(message_str, "Another format: %h", count);
    if (success) $display("Formatted string via $sformat: %s", message_str);


    $display("--- End of String Formatting Example ---");
    $finish;
  end

endmodule
```

**Explanation:**

-   `$swrite` formats data into `message_str`.
-   `$swriteb` demonstrates how the default format can be changed for a single call.
-   `$sformatf` formats data and directly returns a `string`, which is assigned to `formatted_str`. This is very convenient.
-   `$sformat` is shown assigning a value to `message_str` and returning an integer indicating success.

### File Writing (from Memory)

These tasks write formatted data from memory to an opened file.

-   `$fwrite(multi_channel_descriptor, format_string [, arguments])`: Formats data according to `format_string` and writes the result to the file(s) specified by the descriptor. Does **not** append a newline.
-   `$fwriteb`, `$fwriteo`, `$fwriteh`: Variants of `$fwrite` that set the default format for `%v`, `%V` to binary, octal, or hexadecimal for that task call.

**Example:** (See `file_handling_example` above for a basic `$fwrite` usage)

```systemverilog
module file_writing_example;

  integer file_desc;
  integer data1 = 10;
  logic [3:0] nibble = 4'b1101;

  initial begin
    $display("--- File Writing Example ---");

    file_desc = $fopen("fwrite_test.txt", "w");

    if (file_desc) begin
      $fwrite(file_desc, "Writing decimal: %0d\n", data1); // Explicit newline
      $fwrite(file_desc, "Writing hex: %h, ", data1);
      $fwrite(file_desc, "Writing binary: %b\n", nibble);

      // Using variants for default format
      $fwriteh(file_desc, "Nibble default hex: %v\n", nibble); // %v uses default hex
      $fwriteb(file_desc, "Nibble default binary: %v\n", nibble); // %v uses default binary

      $fclose(file_desc);
    end else begin
      $error("Time %0t: Failed to open fwrite_test.txt.", $time);
    end

    $display("--- End of File Writing Example ---");
    $finish;
  end

endmodule
```

**Explanation:**

This example opens a file and uses `$fwrite` and its variants to write formatted data. Note the use of `\n` within the format string to explicitly add newlines, as `$fwrite` itself does not. The variants demonstrate setting the default format for `%v` within the file output.

### File Display (with Newline)

These tasks write formatted data from memory to an opened file and append a newline.

-   `$fdisplay(multi_channel_descriptor, format_string [, arguments])`: Formats data and writes to the file(s), appending a newline.
-   `$fdisplayb`, `$fdisplayo`, `$fdisplayh`: Variants of `$fdisplay` that set the default format for `%v`, `%V` to binary, octal, or hexadecimal.

**Example:** (See `file_handling_example` above for a basic `$fdisplay` usage)

```systemverilog
module file_display_example;

  integer file_desc;
  string message = "Hello, File!";

  initial begin
    $display("--- File Display Example ---");

    file_desc = $fopen("fdisplay_test.txt", "w");

    if (file_desc) begin
      $fdisplay(file_desc, "This is the first line."); // Newline automatically added
      $fdisplay(file_desc, "Time: %0t, Message: %s", $time, message); // Newline automatically added

      $fclose(file_desc);
    end else begin
      $error("Time %0t: Failed to open fdisplay_test.txt.", $time);
    end

    $display("--- End of File Display Example ---");
    $finish;
  end

endmodule
```

**Explanation:**

This example opens a file and uses `$fdisplay` to write formatted messages. Each `$fdisplay` call automatically adds a newline character at the end of the written line.

### File Monitoring (Change-Triggered)

These tasks register variables to monitor and write to a file whenever any of the monitored variables change.

-   `$fmonitor(multi_channel_descriptor, format_string [, arguments])`: Registers a list of variables/expressions associated with a format string to be monitored. Whenever any of the registered items change value, the formatted message is written to the specified file(s). Like `$monitor`, only one `$fmonitor` list is active globally.
-   `$fmonitorb`, `$fmonitoro`, `$fmonitorh`: Variants of `$fmonitor` that set the default format for `%v`, `%V`.

**Example:**

```systemverilog
module file_monitor_example;

  logic sig1 = 0;
  integer counter = 0;
  integer file_desc;

  initial begin
    $display("--- File Monitor Example ---");

    file_desc = $fopen("fmonitor_test.txt", "w");

    if (file_desc) begin
      $display("Time %0t: Opened fmonitor_test.txt for monitoring.", $time);

      // Start monitoring sig1 and counter, writing to the file
      $fmonitor(file_desc, "Time %0t: sig1=%b, counter=%0d", $time, sig1, counter);

      #10 sig1 = 1; // Change sig1 - triggers fmonitor
      #5 counter = 1; // Change counter - triggers fmonitor
      #10 sig1 = 0; // Change sig1 - triggers fmonitor
      #5 counter = 2; // Change counter - triggers fmonitor

      // Note: There are no $fmonitoron / $fmonitoroff tasks.
      // The fmonitor is active as long as the file descriptor is valid and the monitor list is set.
      // A new $fmonitor call would replace the list.

      #100; // Allow time for changes to trigger monitors

      $fclose(file_desc); // Closing the file effectively stops fmonitoring to it
    end else begin
      $error("Time %0t: Failed to open fmonitor_test.txt.", $time);
    end


    $display("--- End of File Monitor Example ---");
    $finish;
  end

endmodule
```

**Explanation:**

This example opens a file and uses `$fmonitor` to set up monitoring for `sig1` and `counter`. Whenever either `sig1` or `counter` changes value during the simulation, a line is written to "fmonitor\_test.txt" showing the current time and the values of the monitored variables. Closing the file with `$fclose` disables monitoring to that specific file descriptor.

### File Strobing (End-of-Time-Step)

These tasks write formatted data to a file at the very end of the current simulation time step.

-   `$fstrobe(multi_channel_descriptor, format_string [, arguments])`: Schedules a formatted message to be written to the file(s) at the end of the current simulation time step, after all other activity at that time is complete. Appends a newline.
-   `$fstrobeb`, `$fstrobeo`, `$fstrobeh`: Variants of `$fstrobe` that set the default format for `%v`, `%V`.

**Example:** (Similar to `$strobe` example, but writing to file)

```systemverilog
module file_strobe_example;

  logic data = 0;
  integer file_desc;

  initial begin
    $display("--- File Strobe Example ---");

    file_desc = $fopen("fstrobe_test.txt", "w");

     if (file_desc) begin
        $display("Time %0t: Opened fstrobe_test.txt for strobing.", $time);

        // Initial fdisplay and fstrobe at time 0
        $fdisplay(file_desc, "Time %0t: $fdisplay - data = %b", $time, data);
        $fstrobe(file_desc, "Time %0t: $fstrobe  - data = %b", $time, data);

        #10 data = 1; // Change data at time 10

        // fdisplay and fstrobe at time 10
        $fdisplay(file_desc, "Time %0t: $fdisplay - data = %b", $time, data); // Data is already 1
        $fstrobe(file_desc, "Time %0t: $fstrobe  - data = %b", $time, data); // Data will be 1 (final value at time 10)

        #10; // Move to time 20

        // fdisplay and fstrobe at time 20
        $fdisplay(file_desc, "Time %0t: $fdisplay - data = %b", $time, data);
        $fstrobe(file_desc, "Time %0t: $fstrobe  - data = %b", $time, data);

        #20;
        $fclose(file_desc);
    end else begin
      $error("Time %0t: Failed to open fstrobe_test.txt.", $time);
    end

    $display("--- End of File Strobe Example ---");
    $finish;
  end

endmodule
```

**Explanation:**

Similar to the `$strobe` example, this shows that `$fdisplay` writes immediately to the file, while `$fstrobe` waits until the very end of the current time step to write the final values for that time step to the file.

### File Pointer Control and Buffer Control

These tasks allow you to move the read/write position within a file and manage file buffers.

-   `$fseek(file_descriptor, offset [, origin])`: Sets the file pointer to a specific position.
    * `offset`: The number of bytes to move.
    * `origin`: Optional integer specifying the starting point for the offset: 0 for beginning of file (SEEK_SET), 1 for current position (SEEK_CUR), 2 for end of file (SEEK_END). Default is 0. Returns 0 on success, non-zero on failure.
-   `$ftell(file_descriptor)`: Returns the current position of the file pointer as an integer (number of bytes from the beginning of the file). Returns -1 on failure.
-   `$rewind(file_descriptor)`: Sets the file pointer to the beginning of the file. Equivalent to `$fseek(file_descriptor, 0, 0)`.
-   `$ungetc(character, file_descriptor)`: Pushes a single character back onto the input stream for the file. The next read operation will read this character first. Useful for character-by-character parsing where you might read one character too many to determine a token. Returns the character on success, EOF on failure.
-   `$fflush(multi_channel_descriptor)`: Forces any buffered output data for the specified descriptor to be written to the file(s). Useful to ensure data is written immediately, even if the buffer isn't full. Returns 0 on success, EOF on failure.

**Example:**

```systemverilog
module file_pointer_buffer_example;

  integer file_desc;
  integer pos;
  integer char;

  initial begin
    $display("--- File Pointer and Buffer Example ---");

    // Create and write to a file
    file_desc = $fopen("seek_test.txt", "w+"); // Use w+ for read/write

    if (file_desc) begin
      $display("Time %0t: Opened seek_test.txt (w+).", $time);
      $fwrite(file_desc, "ABCDEFGHIJKLMNOP");

      // Get current position
      pos = $ftell(file_desc);
      $display("Time %0t: Current position after writing: %0d", $time, pos); // Should be 16

      // Move pointer to the beginning
      $rewind(file_desc);
      $display("Time %0t: After rewind, current position: %0d", $time, $ftell(file_desc)); // Should be 0

      // Read a character
      char = $fgetc(file_desc); // Reads 'A'
      $display("Time %0t: Read char: %c, new position: %0d", $time, char, $ftell(file_desc)); // Pos should be 1

      // Seek 5 bytes from the current position
      $fseek(file_desc, 5, 1); // 1 for SEEK_CUR
      $display("Time %0t: After seeking 5 bytes from current, position: %0d", $time, $ftell(file_desc)); // Pos should be 1 + 5 = 6

      // Read character at the new position (should be 'G')
      char = $fgetc(file_desc);
      $display("Time %0t: Read char: %c, new position: %0d", $time, char, $ftell(file_desc)); // Pos should be 7

      // Push the character back
      $ungetc(char, file_desc);
      $display("Time %0t: After ungetc, position: %0d", $time, $ftell(file_desc)); // Pos should be 6 again

      // Read again (should read 'G' again)
      char = $fgetc(file_desc);
      $display("Time %0t: Read char again: %c, new position: %0d", $time, char, $ftell(file_desc)); // Pos should be 7

      // Seek 3 bytes from the end of the file
      $fseek(file_desc, -3, 2); // 2 for SEEK_END, -3 for backward offset
      $display("Time %0t: After seeking 3 bytes from end, position: %0d", $time, $ftell(file_desc)); // Should be 16 - 3 = 13

      // Write at the new position (overwrites 'N', 'O', 'P')
      $fwrite(file_desc, "XYZ");
      $display("Time %0t: After writing 'XYZ', position: %0d", $time, $ftell(file_desc)); // Should be 13 + 3 = 16

      // Flush buffers to ensure data is written to disk
      $fflush(file_desc);
      $display("Time %0t: File buffers flushed.", $time);

      $fclose(file_desc);
    end else begin
      $error("Time %0t: Failed to open seek_test.txt.", $time);
    end

    $display("--- End of File Pointer and Buffer Example ---");
    $finish;
  end

endmodule
```

**Explanation:**

This example opens a file in read/write mode.
-   It writes data, then uses `$ftell` to get the position.
-   `$rewind` sets the position back to the start.
-   `$fgetc` reads a character, advancing the position.
-   `$fseek` is demonstrated with different origins (current position, end of file) to move the pointer.
-   `$ungetc` puts a character back, allowing it to be reread.
-   Writing after seeking demonstrates modifying the file content at a specific location.
-   `$fflush` ensures that any data waiting in the simulator's internal file buffer is written to the actual file.

### String Scanning (from Memory)

-   `$sscanf(string_variable, format_string, argument1 [, argument2, ...])`: Parses data from a `string_variable` according to the `format_string` and assigns the results to the specified arguments. Similar to the C `sscanf`. Returns the number of input items successfully matched and assigned.

**Example:**

```systemverilog
module string_scanning_example;

  string data_str = "Name: John Age: 30 ID: 12345";
  string format_str = "Name: %s Age: %0d ID: %0d";
  string name_str;
  integer age_val, id_val;
  integer items_matched;

  initial begin
    $display("--- String Scanning Example ---");

    $display("Scanning string: \"%s\"", data_str);
    $display("Using format: \"%s\"", format_str);

    // Use $sscanf to parse the string
    items_matched = $sscanf(data_str, format_str, name_str, age_val, id_val);

    $display("Items matched: %0d", items_matched);

    if (items_matched == 3) begin
      $display("Parsed values:");
      $display("  Name: %s", name_str);
      $display("  Age: %0d", age_val);
      $display("  ID: %0d", id_val);
    end else begin
      $error("Failed to parse all items from the string.");
    end


    $display("--- End of String Scanning Example ---");
    $finish;
  end

endmodule
```

**Explanation:**

This example demonstrates how `$sscanf` can be used to extract structured data from a string.
-   It defines a string `data_str` containing formatted data.
-   A `format_str` is defined to match the pattern in `data_str`.
-   `$sscanf` attempts to parse the string according to the format, assigning the matched parts to `name_str`, `age_val`, and `id_val`.
-   The return value (`items_matched`) indicates how many items were successfully matched and assigned. This allows you to check if the parsing was successful.

These file I/O and string functions provide a wide range of capabilities for integrating your SystemVerilog testbenches with the external environment and manipulating data in flexible ways.

## Memory Load Tasks
Tasks for loading memory contents from a file.
Both tasks read a text file containing data values. The difference lies in the expected format of the data values within the file.

### `$readmemb`

**Description:**

The `$readmemb` task reads binary data from a text file and loads it into a specified memory array. Each line in the file is expected to contain a binary number, optionally preceded by an address and potentially including comments.

**Usage:**

`$readmemb("file_name", memory_name [, start_address [, end_address]]);`

-   `file_name`: A string specifying the name of the text file to read.
-   `memory_name`: The name of the SystemVerilog memory array (declared as an array of `reg` or `logic`) to load the data into.
-   `start_address`: An optional integer specifying the starting address (index) in the `memory_name` array where loading should begin. If omitted, loading starts from the lowest index of the memory array.
-   `end_address`: An optional integer specifying the ending address (index) in the `memory_name` array where loading should end. If omitted, loading continues to the highest index of the memory array.

**File Format for `$readmemb`:**

The file should contain one data value per line. The values are binary numbers, using `0`, `1`, `x`, `z`. Whitespace and underscores within the binary number are ignored.

-   Lines starting with `//` are treated as comments.
-   Lines starting with `@` specify an address (in hexadecimal) for the data that follows. Subsequent data lines will be loaded sequentially starting from this address until another `@` line is encountered.
-   If the first line is not an `@` line, loading starts at the `start_address` (or the memory's lowest index if `start_address` is omitted).

### `$readmemh`

**Description:**

The `$readmemh` task reads hexadecimal data from a text file and loads it into a specified memory array. Each line in the file is expected to contain a hexadecimal number, optionally preceded by an address and potentially including comments.

**Usage:**

`$readmemh("file_name", memory_name [, start_address [, end_address]]);`

-   `file_name`: A string specifying the name of the text file to read.
-   `memory_name`: The name of the SystemVerilog memory array to load data into.
-   `start_address`: An optional integer specifying the starting address (index).
-   `end_address`: An optional integer specifying the ending address (index).

**File Format for `$readmemh`:**

The file should contain one data value per line. The values are hexadecimal numbers, using `0-9`, `a-f`, `A-F`, `x`, `z`. Whitespace and underscores within the hexadecimal number are ignored.

-   Lines starting with `//` are treated as comments.
-   Lines starting with `@` specify an address (in hexadecimal).
-   If the first line is not an `@` line, loading starts at the `start_address` (or the memory's lowest index).

### Example Demonstrating `$readmemb` and `$readmemh`

Let's create two memory initialization files and a SystemVerilog module to load them.

**File: `memory_data_b.txt` (for `$readmemb`)**

```
// This is a binary memory initialization file

// Data for addresses 0-3
@00
1010_1010
0101_0101
1111_0000
0000_1111

// Data for addresses 8-A
@08
1111_1111
0000_0000
1010_1010
```

**File: `memory_data_h.txt` (for `$readmemh`)**

```
// This is a hexadecimal memory initialization file

// Data starting at address 0
A5
3C
F0
0F

// Data starting at address 10 (hex) = 16 (decimal)
@10
FF
11
22
33
44
```

**SystemVerilog Module:**

```systemverilog
module memory_load_example;

  // Declare memory arrays
  logic [7:0] my_memory_b [0:15]; // 16 locations, 8 bits wide
  logic [7:0] my_memory_h [0:31]; // 32 locations, 8 bits wide

  initial begin
    $display("--- Memory Load Example ---");

    // Initialize memory_b from binary file
    $display("Time %0t: Loading my_memory_b from memory_data_b.txt", $time);
    $readmemb("memory_data_b.txt", my_memory_b);

    // Display contents of my_memory_b (addresses 0 to 10 for demonstration)
    $display("\nContents of my_memory_b (addresses 0-10):");
    for (int i = 0; i <= 10; i++) begin
      $display("  my_memory_b[%0d] = %b", i, my_memory_b[i]);
    end

    $display("Time %0t: Loading my_memory_h from memory_data_h.txt", $time);
    // Initialize memory_h from hexadecimal file, specifying a range
    $readmemh("memory_data_h.txt", my_memory_h, 16, 20); // Load into addresses 16 to 20 (decimal)

    // Display contents of my_memory_h (addresses 15 to 21 for demonstration)
    $display("\nContents of my_memory_h (addresses 15-21):");
     for (int i = 15; i <= 21; i++) begin
      $display("  my_memory_h[%0d] = %h", i, my_memory_h[i]);
    end


    $display("--- End of Memory Load Example ---");
    $finish;
  end

endmodule
```

**Explanation:**

1.  **Memory Declaration:** Two memory arrays, `my_memory_b` and `my_memory_h`, are declared as arrays of 8-bit `logic`.
2.  **`$readmemb` Usage:**
    * `$readmemb("memory_data_b.txt", my_memory_b);` reads the binary data from `memory_data_b.txt`.
    * The file starts with `@00`, so loading begins at address 0 of `my_memory_b`.
    * The first four data lines (10101010, 01010101, etc.) are loaded into `my_memory_b[0]` through `my_memory_b[3]`.
    * The `@08` line moves the loading address to 8.
    * The next three data lines (11111111, 00000000, 10101010) are loaded into `my_memory_b[8]` through `my_memory_b[10]`.
    * Addresses 4-7 and 11-15 in `my_memory_b` will retain their initial values (typically 'x' or whatever the reset value is, depending on simulator and declaration).
3.  **`$readmemh` Usage:**
    * `$readmemh("memory_data_h.txt", my_memory_h, 16, 20);` reads hexadecimal data from `memory_data_h.txt`.
    * The `start_address` is specified as 16 (decimal). The `end_address` is 20 (decimal). This means data will be loaded into `my_memory_h[16]` through `my_memory_h[20]`.
    * The file starts with data without an `@` address. Loading would normally start at address 16. The first four data values (A5, 3C, F0, 0F) are ignored because they fall outside the specified load range (16 to 20).
    * The `@10` line changes the *file's internal address pointer* to hexadecimal 10 (decimal 16).
    * The data lines following `@10` (FF, 11, 22, 33, 44) are then considered. Since the *memory* load range is 16 to 20, these values are loaded:
        * FF goes into `my_memory_h[16]` (file address 16)
        * 11 goes into `my_memory_h[17]` (file address 17)
        * 22 goes into `my_memory_h[18]` (file address 18)
        * 33 goes into `my_memory_h[19]` (file address 19)
        * 44 goes into `my_memory_h[20]` (file address 20)
    * Subsequent data in the file (if any) would be ignored as they are past the `end_address` 20. Addresses in `my_memory_h` outside the 16-20 range are unaffected.
4.  **Displaying Contents:** The `for` loops iterate through parts of the memories and display the loaded contents using `%b` for binary and `%h` for hexadecimal.

These tasks provide a simple and effective way to initialize memories based on data stored in external files, separating data from your SystemVerilog code.

## Memory Dump Tasks
Tasks for writing memory contents to a file.
Both tasks write the data in a format compatible with the `@` addressing used by `$readmemb` and `$readmemh`, making it easy to dump a memory state and then potentially load it back later.

### `$writememb`

**Description:**

The `$writememb$ task writes the contents of a specified memory array to a text file, with each memory location's value represented as a binary number on a new line.

**Usage:**

`$writememb("file_name", memory_name [, start_address [, end_address]]);`

-   `file_name`: A string specifying the name of the text file to create or overwrite.
-   `memory_name`: The name of the SystemVerilog memory array whose contents are to be written.
-   `start_address`: An optional integer specifying the starting address (index) in the `memory_name` array from where writing should begin. If omitted, writing starts from the lowest index.
-   `end_address`: An optional integer specifying the ending address (index) in the `memory_name` array where writing should end. If omitted, writing continues to the highest index.

**Output File Format for `$writememb`:**

The generated file will contain:
-   Lines starting with `@` followed by the address in hexadecimal. The address is written whenever there is a gap in the addresses being dumped or at the start of the dump.
-   Subsequent lines contain the binary values of the memory contents, one value per line, corresponding to sequential addresses starting from the last `@` address.
-   Binary values use `0`, `1`, `x`, `z`.

### `$writememh`

**Description:**

The `$writememh$ task writes the contents of a specified memory array to a text file, with each memory location's value represented as a hexadecimal number on a new line.

**Usage:**

`$writememh("file_name", memory_name [, start_address [, end_address]]);`

-   `file_name`: A string specifying the name of the text file to create or overwrite.
-   `memory_name`: The name of the memory array to dump.
-   `start_address`: An optional integer specifying the starting address (index).
-   `end_address`: An optional integer specifying the ending address (index).

**Output File Format for `$writememh`:**

The generated file is similar to `$writememb`, but the data values are in hexadecimal (`0-9`, `a-f`).

-   Lines starting with `@` followed by the address in hexadecimal.
-   Subsequent lines contain the hexadecimal values of the memory contents.
-   Hexadecimal values use `0-9`, `a-f`, `x`, `z`.

### Example Demonstrating `$writememb` and `$writememh`

Let's use a simple memory array, initialize some values, and then dump its contents to files.

```systemverilog
module memory_dump_example;

  // Declare and initialize a memory array
  logic [15:0] instruction_memory [0:63]; // 64 locations, 16 bits wide

  initial begin
    $display("--- Memory Dump Example ---");

    // Initialize some memory locations
    for (int i = 0; i < 10; i++) begin
      instruction_memory[i] = 16'(i * 2 + 1); // Simple initialization pattern
    end
    instruction_memory[15] = 16'hDEAD;
    instruction_memory[16] = 16'hBEEF;
    instruction_memory[30] = 16'hCAFE;
    instruction_memory[31] = 16'hF00D;

    $display("Time %0t: Memory initialized with some values.", $time);

    // Dump the entire memory to a binary file
    $display("Time %0t: Dumping instruction_memory (full range) to instruction_memory.bin", $time);
    $writememb("instruction_memory.bin", instruction_memory);

    // Dump a specific range of the memory to a hexadecimal file
    $display("Time %0t: Dumping instruction_memory (addresses 15-31) to instruction_memory_partial.hex", $time);
    $writememh("instruction_memory_partial.hex", instruction_memory, 15, 31);


    $display("--- End of Memory Dump Example ---");
    $finish;
  end

endmodule
```

**Expected Output File: `instruction_memory.bin`**

```
@00000000
0000000000000001 // Address 0
0000000000000011 // Address 1
0000000000000101 // Address 2
0000000000000111 // Address 3
0000000000001001 // Address 4
0000000000001011 // Address 5
0000000000001101 // Address 6
0000000000001111 // Address 7
000000010001 // Address 8 (value 17 = 16*1 + 1)
000000010011 // Address 9 (value 19 = 16*1 + 3)
@0000000f // Address 15 (hex F)
1101111010101101 // Value DEAD
@00000010 // Address 16 (hex 10)
1011111011101111 // Value BEEF
// ... Addresses 17 through 2f will show their values (likely X unless initialized) ...
@0000001e // Address 30 (hex 1e)
1100101011111110 // Value CAFE
@0000001f // Address 31 (hex 1f)
1111000000001101 // Value F00D
// ... Addresses 32 through 3f will show their values (likely X) ...
```

**Expected Output File: `instruction_memory_partial.hex`**

```
@0000000f // Starting at address 15 (hex F)
dead // Address 15
beef // Address 16
xxxx // Address 17 (assuming not initialized)
xxxx // Address 18
xxxx // Address 19
xxxx // Address 20
xxxx // Address 21
xxxx // Address 22
xxxx // Address 23
xxxx // Address 24
xxxx // Address 25
xxxx // Address 26
xxxx // Address 27
xxxx // Address 28
xxxx // Address 29
cafe // Address 30
f00d // Address 31
```

**Explanation:**

1.  **Memory Initialization:** A memory array `instruction_memory` is declared and partially initialized in the `initial` block. Locations 0-9 are initialized with a pattern, and locations 15, 16, 30, and 31 are initialized with specific hexadecimal values. Other locations will likely be initialized to 'x' by the simulator default.
2.  **`$writememb`:** The first call `$writememb("instruction_memory.bin", instruction_memory);` dumps the *entire* memory (addresses 0 to 63) to `instruction_memory.bin` in binary format. The output file will include `@` lines indicating address jumps and show the binary values of all 64 locations.
3.  **`$writememh`:** The second call `$writememh("instruction_memory_partial.hex", instruction_memory, 15, 31);` dumps only the contents of addresses 15 through 31 (decimal) to `instruction_memory_partial.hex` in hexadecimal format. The output file starts with an `@` line for address 15 (hex F) and then lists the hexadecimal values for addresses 15 through 31.

These tasks are valuable for examining the state of your memories during simulation and creating initialization files based on simulation results.

## Command Line Input
Functions for accessing values passed from the command line.
These tasks work with command-line arguments that start with a plus sign (`+`), often referred to as "plusargs".

### `$test$plusargs`

**Description:**

The `$test$plusargs$ task checks if a specific plusarg, or a plusarg matching a given format string, exists on the simulator's command line. It returns a boolean value (1 for true, 0 for false). This is useful for enabling or disabling certain testbench features based on command-line flags.

**Usage:**

`$test$plusargs(format_string)`

-   `format_string`: A string that specifies the plusarg to look for. This string can include format specifiers (`%s`, `%d`, etc.) to match patterns. A common simple usage is to just provide the name of the plusarg.

**Command Line Syntax:**

Typically `+plusarg_name` or `+plusarg_name=value`. `$test$plusargs` only checks for the existence of a match for the `format_string`.

### `$value$plusargs`

**Description:**

The `$value$plusargs$ task searches the command line for a plusarg that matches the given `format_string`, extracts the value associated with it, and converts that value into the specified SystemVerilog variable. It returns an integer indicating success (non-zero if a match was found and the value was successfully converted, 0 otherwise).

**Usage:**

`$value$plusargs(format_string, output_variable)`

-   `format_string`: A string specifying the plusarg name and a format specifier (`%s`, `%d`, `%h`, `%b`, `%f`) indicating the type of value to expect after the equals sign. The format should look like `"plusarg_name=%specifier"`.
-   `output_variable`: The SystemVerilog variable where the extracted and converted value will be stored. The type of the variable must be compatible with the format specifier.

**Command Line Syntax:**

Typically `+plusarg_name=value`. The `format_string` must match the `+plusarg_name=` part, and the simulator will extract and convert the part after `=`.

### Example Demonstrating `$test$plusargs` and `$value$plusargs`

```systemverilog
module plusargs_example;

  integer test_case_id;
  string test_name;
  logic [7:0] config_byte;
  real delay_value;
  integer matched_count;

  initial begin
    $display("--- $test$plusargs and $value$plusargs example ---");

    // --- Using $test$plusargs ---

    // Check if a simple flag exists
    if ($test$plusargs("ENABLE_FEATURE_X")) begin
      $display("Time %0t: +ENABLE_FEATURE_X plusarg is present. Enabling feature X...", $time);
      // Code to enable feature X
    end else begin
      $display("Time %0t: +ENABLE_FEATURE_X plusarg is NOT present.", $time);
    end

     // Check for a plusarg with a value (only checks existence of the pattern)
    if ($test$plusargs("TEST_CASE=%0d")) begin
        $display("Time %0t: Pattern 'TEST_CASE=%%0d' found.", $time);
    end else begin
         $display("Time %0t: Pattern 'TEST_CASE=%%0d' NOT found.", $time);
    end


    // --- Using $value$plusargs ---

    // Get an integer value
    matched_count = $value$plusargs("TEST_CASE=%0d", test_case_id);
    if (matched_count > 0) begin
      $display("Time %0t: Successfully read TEST_CASE=%0d. test_case_id = %0d", $time, test_case_id, test_case_id);
    end else begin
      $display("Time %0t: TEST_CASE plusarg not found or failed to parse as integer. test_case_id remains its initial value.", $time);
    end

    // Get a string value
    matched_count = $value$plusargs("TEST_NAME=%s", test_name);
    if (matched_count > 0) begin
      $display("Time %0t: Successfully read TEST_NAME=%s. test_name = \"%s\"", $time, test_name, test_name);
    end else begin
      $display("Time %0t: TEST_NAME plusarg not found or failed to parse as string. test_name remains its initial value.", $time);
    end

     // Get a hexadecimal value into a logic vector
    matched_count = $value$plusargs("CONFIG_BYTE=%h", config_byte);
    if (matched_count > 0) begin
      $display("Time %0t: Successfully read CONFIG_BYTE=%%h. config_byte = %h", $time, config_byte, config_byte);
    end else begin
      $display("Time %0t: CONFIG_BYTE plusarg not found or failed to parse as hex. config_byte remains its initial value.", $time);
    end

    // Get a real value
    matched_count = $value$plusargs("DELAY=%f", delay_value);
    if (matched_count > 0) begin
      $display("Time %0t: Successfully read DELAY=%%f. delay_value = %f", $time, delay_value, delay_value);
    end else begin
      $display("Time %0t: DELAY plusarg not found or failed to parse as real. delay_value remains its initial value.", $time);
    end


    $display("Time %0t: Example finished.", $time);
    $finish;
  end

endmodule
```

**Example Simulator Command Lines:**

To run this example using a simulator (replace `vsim` with your simulator's command):

**Command Line 1 (No plusargs):**
```bash
vsim plusargs_example.sv
```
* Expected Output: Shows messages indicating plusargs are NOT present and `$value$plusargs` calls fail. Variables retain their default/initial values.

**Command Line 2 (Some plusargs):**
```bash
vsim plusargs_example.sv +ENABLE_FEATURE_X +TEST_CASE=5 +CONFIG_BYTE=A3
```
* Expected Output: Shows messages indicating `+ENABLE_FEATURE_X` is present. `$value$plusargs` for `TEST_CASE` succeeds (test\_case\_id = 5), `CONFIG_BYTE` succeeds (config\_byte = A3), `TEST_NAME` and `DELAY` fail.

**Command Line 3 (All plusargs):**
```bash
vsim plusargs_example.sv +ENABLE_FEATURE_X +TEST_CASE=10 +TEST_NAME=SmokeTest +CONFIG_BYTE=FF +DELAY=15.7
```
* Expected Output: Shows messages indicating `+ENABLE_FEATURE_X` is present. All `$value$plusargs` calls succeed and variables are assigned the provided values.

**Explanation:**

The example demonstrates:

-   `$test$plusargs("ENABLE_FEATURE_X")` checks if a plusarg named `+ENABLE_FEATURE_X` exists.
-   `$test$plusargs("TEST_CASE=%0d")` checks if any plusarg matches the pattern `+TEST_CASE=` followed by a decimal number. Note that this only checks the pattern, not the value itself.
-   `$value$plusargs("TEST_CASE=%0d", test_case_id)` attempts to find a plusarg matching `+TEST_CASE=` and convert the value after `=` as a decimal integer into the `test_case_id` variable.
-   Other `$value$plusargs` calls show how to read different data types (`%s`, `%h`, `%f`) into compatible variables.
-   The return value of `$value$plusargs` is checked to see if the operation was successful.

These tasks are very powerful for creating reusable testbenches that can be configured easily from the command line without modifying the source code.

## VCD Tasks
Tasks for controlling the dumping of simulation activity to a Value Change Dump (VCD) file for waveform viewing.
SystemVerilog provides two main sets of tasks for generating VCD: the older `$dump` tasks and the newer `$dumpports` tasks.

### VCD Dump Tasks (Older Style)

These tasks provide basic control over generating a VCD file.

-   `$dumpfile(string_file_name)`: Specifies the name of the VCD file that will be created to store the simulation data. Only one VCD file can be specified at a time. If not called, simulators might use a default name.
-   `$dumpvars([levels], hierarchy_or_variable1 [, hierarchy_or_variable2, ...])`: Starts the process of dumping signal activity into the VCD file specified by `$dumpfile`.
    * `levels`: An optional integer specifying the number of hierarchical levels below the specified `hierarchy_or_variable` to dump. If omitted, only the specified level is dumped. If 0 or a negative number is specified, all levels below are dumped.
    * `hierarchy_or_variable`: Specifies a hierarchical scope (like a module instance) or a specific variable to dump. You can list multiple scopes/variables. If omitted, all variables in the top-level scope are dumped.
-   `$dumpoff()`: Temporarily suspends the dumping of signal activity. No new data is added to the VCD file while dumping is off.
-   `$dumpon()`: Resumes the dumping of signal activity after it has been suspended by `$dumpoff()`.
-   `$dumpall()`: Dumps the current values of all variables that are being monitored by `$dumpvars` or `$dumpports`, even if they haven't changed since the last value dump. This is useful for getting a snapshot of the system state.
-   `$dumplimit(real_limit)`: Specifies a maximum size (in bytes) for the VCD file. Dumping will automatically stop once the file reaches this size limit.
-   `$dumpflush()`: Forces any buffered VCD data to be written to the output file immediately. VCD data is often buffered for performance.

**Example (using `$dump` tasks):**

```systemverilog
module dump_example;

  logic clk = 0;
  integer count = 0;
  logic [3:0] state = 0;

  // Clock generator
  initial begin
    forever #10 clk = ~clk;
  end

  // Counter
  always @(posedge clk) begin
    count++;
    state = state + 1;
  end

  initial begin
    $display("Time %0t: Simulation starts.", $time);

    // Specify the VCD file name
    $dumpfile("dump_output.vcd");

    // Start dumping signals
    // Dump 'clk' and 'count' from the current scope, and all signals in 'state' (which is just state itself)
    $dumpvars(0, clk, count, state); // 0 levels means dump the specified items

    $display("Time %0t: Started dumping to dump_output.vcd.", $time);

    #50; // Run for 50 time units

    $display("Time %0t: Calling $dumpoff.", $time);
    $dumpoff(); // Stop dumping temporarily

    #50; // Run for another 50 time units (no dumping occurs)

    $display("Time %0t: Calling $dumpon.", $time);
    $dumpon(); // Resume dumping

    #50; // Run for another 50 time units

    $display("Time %0t: Calling $dumpall to dump current values.", $time);
    $dumpall(); // Force dumping current values

    #20; // Run a bit more

    // $dumplimit(1000000); // Example: limit file size to 1MB
    // $dumpflush(); // Example: force data to be written now


    $display("Time %0t: Simulation ends.", $time);
    $finish;
  end

endmodule
```

**Explanation:**

1.  `$dumpfile("dump_output.vcd");` sets the output file name to "dump\_output.vcd".
2.  `$dumpvars(0, clk, count, state);` starts dumping. It specifies to dump `clk`, `count`, and `state`. The `0` indicates to dump the items themselves but not descend into any hierarchy *within* them (relevant if `state` were a struct or array, though `0` levels usually dumps the whole item). If you wanted to dump *all* signals in the current module, you could use `$dumpvars(0, this);` or `$dumpvars(0);` if `this` refers to the current scope. `$dumpvars(1, top);` would dump `top` module signals and signals one level below it.
3.  As the simulation runs, changes in `clk`, `count`, and `state` are recorded in "dump\_output.vcd".
4.  `$dumpoff()` pauses the recording.
5.  `$dumpon()` resumes it.
6.  `$dumpall()` forces the current values of the monitored signals to be written, regardless of whether they changed at that exact time.

After running this simulation, you would find a file named "dump\_output.vcd" in your simulation directory, which you can open with a waveform viewer.

### VCD Dump Ports Tasks (Newer Style)

These tasks are intended to provide a more efficient way to specify what to dump, focusing on the ports of modules and optionally including internal signals. The syntax is slightly different and they are generally considered more performant for large designs.

-   `$dumpports([levels], hierarchy_or_variable1 [, hierarchy_or_variable2, ...])`: Similar to `$dumpvars`, but typically more optimized for dumping module ports. The parameters are the same.
-   `$dumpportsoff()`: Temporarily suspends dumping initiated by `$dumpports`.
-   `$dumpportson()`: Resumes dumping initiated by `$dumpports`.
-   `$dumpportsall([levels], hierarchy_or_variable1 [, hierarchy_or_variable2, ...])`: Dumps the current values of signals specified by a `$dumpports` list, similar to `$dumpall`. Can also be used to specify a new set of signals to dump all values for.
-   `$dumpportslimit(real_limit)`: Specifies a maximum size for the VCD file generated by `$dumpports`.
-   `$dumpportsflush()`: Forces buffered data from `$dumpports` to be written to the file.

**Conceptual Example (using `$dumpports`):**

Using `$dumpports` is very similar to using `$dumpvars` in the example above. You would replace the `$dumpvars` call with `$dumpports`. The effect might be slightly different depending on the simulator's implementation and what exactly qualifies as a "port" or how the hierarchy levels are interpreted compared to `$dumpvars`.

```systemverilog
module dumpports_example;
  // ... same clock, counter, state declarations as dump_example ...
  logic clk = 0;
  integer count = 0;
  logic [3:0] state = 0;

   // Clock generator
  initial begin
    forever #10 clk = ~clk;
  end

  // Counter
  always @(posedge clk) begin
    count++;
    state = state + 1;
  end


  initial begin
    $display("Time %0t: Simulation starts.", $time);

    // Specify the VCD file name (same as $dumpfile)
    $dumpfile("dumpports_output.vcd");

    // Start dumping signals using $dumpports
    // This might be more optimized for dumping ports if used on module instances
    $dumpports(0, clk, count, state); // Similar syntax to $dumpvars

    $display("Time %0t: Started dumping to dumpports_output.vcd.", $time);

    #50; // Run for 50 time units

    $display("Time %0t: Calling $dumpportsoff.", $time);
    $dumpportsoff(); // Stop dumping temporarily

    #50; // Run for another 50 time units (no dumping occurs)

    $display("Time %0t: Calling $dumpportson.", $time);
    $dumpportson(); // Resume dumping

    #50; // Run for another 50 time units

    $display("Time %0t: Calling $dumpportsall to dump current values.", $time);
    $dumpportsall(0, clk, count, state); // Force dumping current values for specified items

    #20; // Run a bit more

    // $dumpportslimit(1000000); // Example: limit file size
    // $dumpportsflush(); // Example: force data to be written now


    $display("Time %0t: Simulation ends.", $time);
    $finish();
  end

endmodule
```

**Explanation:**

This example is functionally very similar to the `$dump` example, but it uses the `$dumpports` family of tasks. The primary difference is in the intended use case and potential performance optimizations within the simulator when using `$dumpports`, especially when applied to large hierarchical designs where you mainly care about the signal activity at module boundaries (ports).

In practice, you would typically choose either the `$dump` tasks or the `$dumpports` tasks based on your simulator's recommendations and your specific needs for dumping granularity and performance.


##### Copyright (c) 2026 ChipVerge

