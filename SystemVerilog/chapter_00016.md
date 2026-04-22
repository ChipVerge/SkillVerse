# SystemVerilog Packages: Organizing and Reusing Verification Code

## Introduction: Namespaces for Modular and Reusable Code

SystemVerilog packages are fundamental building blocks for creating well-organized, modular, and reusable verification environments.  They act as **namespaces**, providing a dedicated container to group related SystemVerilog declarations. This encapsulation mechanism is crucial for managing the complexity of large-scale verification projects, promoting code reuse, and fostering collaboration among verification teams.

**Key Advantages of Using Packages in SystemVerilog Verification:**

-   **Namespace Management and Pollution Prevention**: Packages prevent the pollution of the global namespace. Without packages, all declarations would reside in a single global scope, leading to potential naming conflicts, especially in large projects with contributions from multiple engineers or reuse of IP from different sources. Packages create isolated namespaces, ensuring that identifiers (names) declared within a package do not clash with identifiers declared elsewhere, enhancing code clarity and reducing errors.
-   **Code Reusability Across Verification Components**: Packages facilitate code reuse by providing a central repository for commonly used data types, constants, functions, tasks, and classes. Once defined in a package, these elements can be easily imported and reused across various design modules, testbench components, and verification utilities. This significantly reduces code duplication, promotes consistency, and speeds up development.
-   **Modular Code Organization and Improved Readability**: Packages encourage a modular approach to verification code organization. By grouping related items into logical packages based on functionality or domain (e.g., a package for bus protocol definitions, a package for common utility functions), you create a more structured and understandable codebase. This improves readability, simplifies navigation, and makes it easier for engineers to locate and understand specific parts of the verification environment.
-   **Enhanced Team Collaboration and Standardized Interfaces**: Packages promote team collaboration by establishing standardized interfaces for verification components. When teams agree on packages for common data structures, utility functions, or communication protocols, it becomes easier for different engineers to work on different parts of the verification environment and integrate their work seamlessly. Packages act as contracts, defining clear boundaries and interfaces between modules and components, fostering efficient teamwork.

## Defining Packages: Creating Namespaces for Declarations

Packages are defined using the `package` keyword, followed by the package name and the package body enclosed within `endpackage`.  Packages can encapsulate a wide range of SystemVerilog declarations, making them versatile containers for verification code.

**Elements that can be declared within a SystemVerilog Package:**

-   **`typedef` Definitions**: User-defined data types, such as custom structs, enums, and arrays, created using the `typedef` keyword. Packages are ideal for defining and sharing common data types used across the verification environment.
-   **`function` and `task` Declarations**:  Reusable functions and tasks that perform specific operations or actions. Packages are excellent for grouping utility functions, protocol handlers, or common verification routines that can be called from various parts of the testbench.
-   **`class` Definitions**: Class definitions for object-oriented verification components like transaction objects, drivers, monitors, and agents. Packages are used to organize and distribute class definitions, promoting modularity and reuse of verification building blocks.
-   **`parameter` and `const` Constants**:  Named constants and parameters that define configuration values, thresholds, or fixed data values used throughout the verification environment. Packages provide a central location to define and manage these constants, making it easier to update and maintain them consistently.
-   **`import` Statements from Other Packages**: Packages can import items from other packages, allowing you to build hierarchical package structures and reuse code from existing libraries or components. This supports modular design and avoids code duplication across packages.

### Example: Structure of a Basic Utility Package

```SV
package math_utils_pkg; // Package name with '_pkg' suffix for convention

  // 1. Type Definition: Custom data type for words
  typedef logic [31:0] word_t; // Defines 'word_t' as a 32-bit logic type

  // 2. Constant: Definition of Pi constant
  const real PI = 3.1415926535; // Defines a constant 'PI' of type 'real'

  // 3. Function Declaration: Function to add two words
  function automatic word_t add_words(input word_t a, input word_t b); // 'automatic' for re-entrant function
    return a + b; // Returns the sum of the two input words
  endfunction : add_words // Named function end for clarity

  // 4. Task Declaration: Task to print a labeled result
  task print_labeled_result(input string label, input word_t value);
    $display("%s: 0x%h", label, value); // Displays a label and the hexadecimal value
  endtask : print_labeled_result // Named task end for clarity

endpackage : math_utils_pkg // Named package end for clarity
```

In this `math_utils_pkg` example:

-   `package math_utils_pkg; ... endpackage : math_utils_pkg` defines the package named `math_utils_pkg`.  Using `_pkg` as a suffix is a common SystemVerilog convention to clearly identify packages.
-   `typedef logic [31:0] word_t;` defines a reusable data type `word_t` as a 32-bit logic vector.
-   `const real PI = 3.1415926535;` declares a constant `PI` of type `real` (floating-point).
-   `function automatic word_t add_words(...) ... endfunction : add_words` defines a function `add_words` that takes two `word_t` inputs and returns their sum as a `word_t`. The `automatic` keyword ensures the function is re-entrant, safe for concurrent calls.
-   `task print_labeled_result(...) ... endtask : print_labeled_result` defines a task `print_labeled_result` that takes a string label and a `word_t` value and displays them with `$display`.

## Importing Packages: Controlling Namespace Visibility

To use the declarations defined within a package, you need to *import* the package into the scope where you want to use them (e.g., within a module, interface, or another package). SystemVerilog offers different import styles, providing flexibility in controlling namespace visibility.

| Import Style                   | Description                                                                                                                                                             | When to Use                                                                                                                                                              | Considerations                                                                                                                               |
| ------------------------------ | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------ |
| **`import pkg::*;`**           | **Wildcard Import (Import All)**: Imports all *visible* items (types, constants, functions, tasks, classes) declared directly within the package `pkg` into the current scope.                                  | - For smaller packages with a limited number of declarations where naming conflicts are unlikely. <br> - In testbench modules or utility files where you need to use many items from a package conveniently.                  | - **Use with caution**: Can lead to namespace pollution and naming conflicts if multiple packages with wildcard imports declare items with the same names. <br> - Reduces code explicitness, making it less clear where identifiers are coming from. |
| **`import pkg::item;`**        | **Specific Item Import**: Imports only the explicitly named `item` (e.g., a specific type, function, or class) from the package `pkg` into the current scope. You can list multiple specific items separated by commas. | - **Recommended for most cases**: Provides fine-grained control over namespace visibility. <br> - When you only need to use a few specific items from a package. <br> - In larger projects to minimize namespace pollution and avoid naming collisions. | - More verbose than wildcard import, especially if you need to import many items from the same package.                                                              |
| **No `import` (Explicit Scope Resolution)** | **No Import**:  Does not import anything. You access package members using explicit scope resolution with the `package_name::item_name` syntax every time you use them.                                                               | - When you only use a few items from a package very infrequently. <br> - To maximize namespace isolation and avoid any potential import-related naming conflicts. <br> - For very large projects with strict naming conventions.               | - Can make code more verbose and less readable if you frequently use items from the package.                                                                       |

### Example: Selective and Wildcard Package Imports

```SV
package type_pkg;
  typedef logic [7:0] byte_t;
endpackage : type_pkg

package function_pkg;
  import type_pkg::byte_t; // Import 'byte_t' type specifically from 'type_pkg'

  function automatic byte_t increment_byte(input byte_t b);
    return b + 1;
  endfunction : increment_byte
endpackage : function_pkg

module import_example_module;
  // 1. Specific Item Imports: Import 'byte_t' type and 'increment_byte' function
  import type_pkg::byte_t;
  import function_pkg::increment_byte;

  // Uncomment to see wildcard import example:
  // import function_pkg::*; // Wildcard import from 'function_pkg' - also imports 'byte_t' indirectly because 'function_pkg' imports it

  initial begin
    byte_t my_byte = 8'h0F; // Use 'byte_t' type directly (imported)
    byte_t incremented_byte;

    incremented_byte = increment_byte(my_byte); // Call 'increment_byte' function directly (imported)
    $display("Original byte: %h, Incremented byte: %h", my_byte, incremented_byte);

    // If using wildcard import for 'function_pkg', you can still use 'byte_t' because 'function_pkg' imports it.
    // If NOT using wildcard import for 'function_pkg', and 'import type_pkg::byte_t;' is commented out,
    // then 'byte_t' would be unresolved unless you use explicit scope resolution (type_pkg::byte_t).
  end
endmodule : import_example_module
```

In this import example:

-   `package type_pkg` defines a type `byte_t`.
-   `package function_pkg` imports `type_pkg::byte_t` specifically and defines a function `increment_byte` that uses `byte_t`.
-   `module import_example_module` demonstrates:
    -   **Specific imports**: `import type_pkg::byte_t;` and `import function_pkg::increment_byte;` import only the `byte_t` type and the `increment_byte` function directly into the `import_example_module` scope. You can then use them directly without package qualification.
    -   **(Commented out) Wildcard import**: `import function_pkg::*` shows how a wildcard import from `function_pkg` would bring all *visible* items from `function_pkg` (including `increment_byte` and indirectly `byte_t` because `function_pkg` itself imports `byte_t`) into the current scope.

## Package Scope Resolution: Explicitly Accessing Package Members

Even without using `import` statements, you can always access members of a package using the **scope resolution operator `::`**. This operator allows you to explicitly specify the package name followed by `::` and then the name of the item you want to access (e.g., `package_name::item_name`). This is known as **explicit scope resolution**.

### Example: Accessing Package Members with Explicit Scope Resolution

```SV
package config_pkg;
  parameter int DATA_WIDTH = 32; // Parameter for data width
  const string VERSION_STRING = "1.0"; // Constant version string
endpackage : config_pkg

package task_utils_pkg;
  task display_config();
    $display("Data Width: %0d bits", config_pkg::DATA_WIDTH); // Explicit scope resolution to access 'DATA_WIDTH'
    $display("Version: %s", config_pkg::VERSION_STRING);     // Explicit scope resolution to access 'VERSION_STRING'
  endtask : display_config
endpackage : task_utils_pkg

module scope_resolution_module;
  initial begin
    task_utils_pkg::display_config(); // Explicit scope resolution to call 'display_config' task

    $display("Data Width (again, using explicit scope): %0d", config_pkg::DATA_WIDTH); // Access 'DATA_WIDTH' directly using scope resolution
  end
endmodule : scope_resolution_module
```

In this scope resolution example:

-   `package config_pkg` defines a `parameter` `DATA_WIDTH` and a `const` `VERSION_STRING`.
-   `package task_utils_pkg` defines a task `display_config()`. Inside `display_config()`, it accesses `config_pkg::DATA_WIDTH` and `config_pkg::VERSION_STRING` using explicit scope resolution.
-   `module scope_resolution_module` calls `task_utils_pkg::display_config()` using scope resolution. It also directly accesses `config_pkg::DATA_WIDTH` in the `$display` statement using scope resolution.
-   No `import` statements are used in `scope_resolution_module`. All package member accesses are done using the `package_name::item_name` syntax.

Explicit scope resolution is useful when:

-   You only need to use a few items from a package and prefer not to import the entire package or specific items.
-   You want to be absolutely clear about the origin of an identifier, especially in large projects where naming conflicts might be a concern.
-   You are working with multiple packages that might have items with the same names, and you need to disambiguate them by explicitly specifying the package name.

## Package Export System: Creating Abstraction Layers and Hierarchical Packages

The `export` mechanism in SystemVerilog packages allows you to re-export items that have been imported into a package. This is a powerful feature for creating hierarchical package organizations and abstraction layers.  When a package re-exports items from other packages, modules or other packages that import the re-exporting package will also have access to the re-exported items as if they were directly declared in the re-exporting package.

### Example: Building Hierarchical Packages with Export

```SV
// 1. Base Package: 'data_types_pkg' - Defines basic data types
package data_types_pkg;
  typedef logic [7:0] byte_t; // Basic byte type
  typedef logic [31:0] word_t; // Basic word type
endpackage : data_types_pkg

// 2. Utility Package: 'byte_utils_pkg' - Uses and re-exports 'data_types_pkg'
package byte_utils_pkg;
  import data_types_pkg::*; // Import all items from 'data_types_pkg'
  export data_types_pkg::*; // Re-export all imported items from 'data_types_pkg'

  // Utility function operating on 'byte_t' (from 'data_types_pkg')
  function automatic byte_t invert_byte(input byte_t b);
    return ~b; // Bitwise inversion of a byte
  endfunction : invert_byte
endpackage : byte_utils_pkg

// 3. Extended Utility Package: 'word_utils_pkg' - Extends 'byte_utils_pkg' and re-exports
package word_utils_pkg;
  import byte_utils_pkg::*; // Import all from 'byte_utils_pkg' (which already re-exports 'data_types_pkg')
  export byte_utils_pkg::*; // Re-export all imported items from 'byte_utils_pkg' (including re-exported items from 'data_types_pkg')

  // Utility function operating on 'word_t' (from 'data_types_pkg') and using 'invert_byte' (from 'byte_utils_pkg')
  function automatic word_t invert_word(input word_t w);
    word_t inverted_word = 0;
    for (int i = 0; i < 4; i++) begin // Invert each byte of the word
      inverted_word |= (byte_utils_pkg::invert_byte(w[8*i +: 8]) << (8*i)); // Explicit scope resolution to ensure correct 'invert_byte' if there was another one in scope
    end
    return inverted_word;
  endfunction : invert_word
endpackage : word_utils_pkg

// 4. Top Module: 'chip_module' - Uses 'word_utils_pkg' and gets access to all re-exported items
module chip_module;
  import word_utils_pkg::*; // Import all from 'word_utils_pkg' - implicitly gets access to 'byte_utils_pkg' and 'data_types_pkg' items as well due to 'export'

  initial begin
    byte_t data_byte = 8'b1010_1100; // Use 'byte_t' type (from 'data_types_pkg' - re-exported)
    word_t data_word = 32'h1234_5678; // Use 'word_t' type (from 'data_types_pkg' - re-exported)

    $display("Inverted byte: 0x%h", invert_byte(data_byte)); // Call 'invert_byte' (from 'byte_utils_pkg' - re-exported)
    $display("Inverted word: 0x%h", invert_word(data_word)); // Call 'invert_word' (from 'word_utils_pkg')
  end
endmodule : chip_module
```

In this hierarchical package example:

-   `data_types_pkg` is the base package defining fundamental data types (`byte_t`, `word_t`).
-   `byte_utils_pkg` imports `data_types_pkg::*` and then `export data_types_pkg::*`. This means `byte_utils_pkg` uses items from `data_types_pkg` internally and also makes them available to any module or package that imports `byte_utils_pkg`.
-   `word_utils_pkg` imports `byte_utils_pkg::*` and `export byte_utils_pkg::*`.  It builds upon `byte_utils_pkg` (and thus indirectly on `data_types_pkg`).  By re-exporting `byte_utils_pkg::*`, it makes all items from `byte_utils_pkg` (including re-exported items from `data_types_pkg`) accessible to its importers.
-   `chip_module` imports `word_utils_pkg::*`. Because of the export chain, `chip_module` gains access to items from all three packages (`word_utils_pkg`, `byte_utils_pkg`, and `data_types_pkg`) as if they were all declared directly in `word_utils_pkg`.

The `export` system is valuable for:

-   **Creating Abstraction Layers**:  Packages can re-export items from underlying packages, creating a higher-level interface that hides implementation details and simplifies usage for higher-level modules.
-   **Building Package Hierarchies**:  Organizing packages in a hierarchical manner, where higher-level packages build upon and extend functionality from lower-level packages, promoting modularity and maintainability.
-   **Library Development**:  When developing reusable verification libraries, `export` can be used to create well-defined public interfaces for the library packages, while keeping internal implementation details hidden.

## Best Practices for Effective Package Usage

To leverage the full benefits of SystemVerilog packages and maintain a clean and organized verification codebase, adhere to these best practices:

1.  **Prefer Explicit Imports Over Wildcard Imports**:

    -   **Problem with Wildcard (`import pkg::*`)**: While convenient for small packages, wildcard imports can lead to namespace pollution, making it harder to track the origin of identifiers and increasing the risk of accidental naming conflicts, especially in larger projects or when integrating code from different sources.
    -   **Benefit of Explicit Imports (`import pkg::item, pkg::item2, ...`)**: Explicit imports promote code clarity and maintainability by clearly stating which items from a package are being used in the current scope. This reduces ambiguity and makes it easier to understand dependencies.
    -   **Best Practice**:  Favor explicit imports (`import pkg::item;`) for better code organization, reduced namespace pollution, and improved long-term maintainability. Only use wildcard imports (`import pkg::*`) sparingly in small, well-contained packages where naming conflicts are highly unlikely and convenience is a significant factor (e.g., in small utility modules or test cases).

    ```SV
    // Example showing preference for explicit imports:

    // Instead of wildcard import (less preferred for larger projects):
    import math_utils_pkg::*; // May import more than you need and risk name clashes

    // Prefer explicit imports (more maintainable and clearer):
    import math_utils_pkg::word_t;   // Only import the 'word_t' type
    import math_utils_pkg::add_words; // Only import the 'add_words' function
    import math_utils_pkg::PI;        // Only import the 'PI' constant
    ```

2.  **Use Unique and Descriptive Package Names**:

    -   **Naming Conventions**: Choose package names that are unique across your project and organization to avoid naming collisions, especially when reusing packages or integrating with external libraries.
    -   **Prefixing with Project/Organization Name**: A common and effective practice is to prefix package names with a project-specific or organization-specific identifier (e.g., `acme_`, `companyXYZ_`, `projectABC_`). This creates a clear namespace hierarchy and reduces the chance of name clashes.
    -   **Suffixing with `_pkg`**:  Using the `_pkg` suffix (e.g., `math_utils_pkg`, `memory_model_pkg`) is a widely adopted SystemVerilog convention to clearly distinguish package names from other identifiers (like modules, interfaces, or classes).

    ```SV
    // Good, unique package names:
    package acme_verification_utils_pkg; // Project-specific prefix and '_pkg' suffix
    package companyXYZ_bus_protocol_pkg; // Organization-specific prefix and '_pkg' suffix

    // Less ideal, potentially risky package names (more likely to clash):
    package math_utils; // Too generic, might clash with other 'math_utils' packages
    package common_types; // Too common, high risk of naming conflicts
    package verification; // Very generic, almost certain to clash in larger projects
    ```

3.  **Organize Packages by Functionality or Domain**:

    -   **Functional Grouping**:  Structure your packages based on logical functional areas or domains within your verification environment. This improves organization, modularity, and makes it easier to locate related code.
    -   **Example Package Categories**:
        -   `typedefs_pkg`:  For common user-defined data types (structs, enums, etc.) used across the project.
        -   `utils_pkg` or `common_utils_pkg`: For general-purpose utility functions and tasks (e.g., logging, data manipulation, common algorithms).
        -   `testbench_utils_pkg` or `tb_lib_pkg`: For testbench-specific utility functions, base classes for testbench components, and common verification infrastructure.
        -   `protocol_name_pkg` (e.g., `usb_pkg`, `ethernet_pkg`, `axi_pkg`): For protocol-specific definitions, classes, functions, and tasks related to a particular interface or protocol.
        -   `model_name_pkg` (e.g., `memory_model_pkg`, `cache_model_pkg`): For models of specific design components or sub-systems.

4.  **Combine Packages with `\`include` for Large Packages**:

    -   **Splitting Large Packages**: For very large packages that contain many declarations, consider splitting the package definition into multiple files using the `\`include` directive. This improves file organization, makes it easier to navigate and edit the package code, and can enhance compilation efficiency in some cases.
    -   **File Organization within a Package**:  Create separate `\`include` files for different categories of declarations within the package (e.g., types, functions, tasks, classes, constants).
    -   **Example Package File Structure**:

    ```SV
    // File: usb_pkg.sv
    package usb_pkg;
      `include "usb_types.svh"     // Contains typedefs and struct/enum definitions
      `include "usb_functions.svh" // Contains function declarations
      `include "usb_tasks.svh"     // Contains task declarations
      `include "usb_classes.svh"   // Contains class definitions
      `include "usb_constants.svh" // Contains parameter and const declarations
    endpackage : usb_pkg

    // Example content of usb_types.svh:
    // (Inside usb_types.svh)
    typedef enum logic [2:0] { USB_IDLE, USB_SOF, USB_DATA, USB_HANDSHAKE } usb_state_e;
    typedef struct packed {
      rand usb_state_e state;
      rand bit [7:0] data_payload;
    } usb_transaction_t;
    // ... more type definitions ...

    // Example content of usb_functions.svh:
    // (Inside usb_functions.svh)
    function automatic string usb_state_to_string(input usb_state_e state);
      // ... function implementation ...
    endfunction : usb_state_to_string
    // ... more function declarations ...

    // ... and so on for usb_tasks.svh, usb_classes.svh, usb_constants.svh ...
    ```

    -   **Benefits of Splitting**:
        -   Improved file organization and easier navigation within large packages.
        -   Potentially faster compilation as only modified `\`include` files might need recompilation in some flows.
        -   Better support for version control and parallel development when different engineers work on different parts of a large package.

## Exercises to Practice SystemVerilog Packages

1.  **Create a Basic `geometry_pkg`**:

    -   Create a SystemVerilog package named `geometry_pkg`.
    -   Inside `geometry_pkg`, define:
        -   A `typedef` named `point_t` that is a `struct` containing two `real` members: `x` and `y` (representing x and y coordinates of a point).
        -   A `function` named `distance` that takes two inputs of type `point_t` and returns a `real` value representing the Euclidean distance between the two points. (Use the distance formula: `sqrt((x2-x1)^2 + (y2-y1)^2)`)
        -   A `const real` named `AREA_CONST` and assign it a value of `10.5`.

2.  **Import and Use `geometry_pkg` (Wildcard Import)**:

    -   Create a SystemVerilog module.
    -   In this module, use a **wildcard import** to import all items from `geometry_pkg`.
    -   Declare two variables of type `point_t` (e.g., `p1`, `p2`).
    -   Initialize the `x` and `y` members of `p1` and `p2` with some `real` values.
    -   Call the `distance` function (from `geometry_pkg`) to calculate the distance between `p1` and `p2`.
    -   Display the calculated distance and the value of `AREA_CONST` (from `geometry_pkg`).

3.  **Use Explicit Scope Resolution (No Imports)**:

    -   Create a new SystemVerilog module (or modify the module from Exercise 2).
    -   **Remove the `import` statement** from the module.
    -   Rewrite the module to access all items from `geometry_pkg` (the `point_t` type, `distance` function, and `AREA_CONST` constant) using **explicit scope resolution** (e.g., `geometry_pkg::point_t`, `geometry_pkg::distance`, `geometry_pkg::AREA_CONST`).
    -   Verify that the module still works correctly and produces the same output as in Exercise 2.

4.  **Package Export: `base_pkg` and `graphics_pkg`**:

    -   Create a package named `base_pkg`. Inside `base_pkg`, define an `enum` type named `color_t` with members `RED`, `GREEN`, and `BLUE`.
    -   Create another package named `graphics_pkg`. Inside `graphics_pkg`:
        -   **Import all items** from `base_pkg` using `import base_pkg::*;`.
        -   **Re-export all items** from `base_pkg` using `export base_pkg::*;`.
        -   Define a `function` named `mix_colors` that takes two inputs of type `base_pkg::color_t` and returns a `string` describing the color mix (e.g., if inputs are `RED` and `BLUE`, return "Mixed color: PURPLE"). You can use a `case` statement or `if-else` logic to implement the color mixing logic.
    -   Create a top-level module. In this module:
        -   **Import all items** from `graphics_pkg` using `import graphics_pkg::*;`.
        -   Declare two variables of type `color_t` (you should be able to use `color_t` directly because it's re-exported by `graphics_pkg`).
        -   Call the `mix_colors` function (from `graphics_pkg`) with the two `color_t` variables as arguments.
        -   Display the string returned by `mix_colors`.
        -   Also, directly use a member of `color_t` (e.g., `RED`) in a `$display` statement to verify that `color_t` is accessible through `graphics_pkg` due to re-export.

5.  **Package Name Conflict Resolution**:

    -   Create two packages: `package_A_pkg` and `package_B_pkg`.
    -   In both `package_A_pkg` and `package_B_pkg`, define a function with the **same name**, for example, `function void print_message();`.  Make each `print_message()` function display a different message (e.g., "Message from Package A" vs. "Message from Package B").
    -   Create a top-level module. In this module:
        -   Attempt to **import all items** from **both** `package_A_pkg` and `package_B_pkg` using wildcard imports (`import package_A_pkg::*`, `import package_B_pkg::*`).  Try to call `print_message()` directly. Observe the naming conflict error during compilation or simulation.
        -   **Resolve the name conflict using explicit scope resolution**.  Modify the module to call `package_A_pkg::print_message()` and `package_B_pkg::print_message()` explicitly to differentiate between the two functions with the same name.
        -   **Resolve the name conflict using renaming imports (if supported by your SystemVerilog simulator)**.  If your simulator supports renaming imports (some older simulators might not fully support this feature), try to import the `print_message()` function from one of the packages with a different name (alias), for example: `import package_A_pkg::print_message as print_message_A;`. Then, call both `print_message_A()` and `package_B_pkg::print_message()` to demonstrate calling both functions without conflict.

These exercises will provide practical experience in defining, importing, using, and organizing SystemVerilog packages, as well as handling namespace management and conflict resolution, which are crucial skills for developing robust and maintainable verification environments.

##### Copyright (c) 2026 ChipVerge

