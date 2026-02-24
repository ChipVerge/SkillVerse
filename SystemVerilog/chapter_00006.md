# SystemVerilog Array Manipulation: Boost Your Design Capabilities

## Introduction

SystemVerilog elevates array manipulation beyond basic indexing, offering powerful built-in methods for dynamic arrays, queues, and associative arrays. While these methods are primarily for dynamic and associative types, a solid grasp of array indexing is fundamental across all array types in SystemVerilog. This guide explores both essential indexing techniques and advanced manipulation methods, optimized for efficient verification and robust RTL design.

## Array Indexing: Precision Access to Multidimensional Data

SystemVerilog excels in handling complex, multidimensional arrays, incorporating both packed and unpacked dimensions. Mastering indexing is key to effectively model hardware and process data.

### Example: Dissecting a Multidimensional Array

Let's consider a complex array structure as an example to illustrate indexing:

```SV
logic [127:0][7:0] my_array [8][64][32];
```

#### Understanding Dimensions:

1.  **Unpacked Dimensions (Array Structure)**: These dimensions define the number of elements and the array's organization in memory:
    -   `[8][64][32]`: This creates a 3-dimensional unpacked array with a total of 8 \* 64 \* 32 = 16,384 elements. Think of it as 8 banks, each with 64 rows, and each row containing 32 columns.

2.  **Packed Dimensions (Element Bit Structure)**: These dimensions define the bit-level structure of each element within the unpacked array:
    -   `[127:0][7:0]`: Each element is itself a 2-dimensional packed array, representing a 128x8 bit matrix, totaling 1,024 bits (128 bytes) per element.

### Indexing Techniques: Navigating the Array

| Access Level         | Example                             | Description                                                                    |
| -------------------- | ----------------------------------- | ------------------------------------------------------------------------------ |
| **Full Element**     | `my_array[2][5][17]`               | Retrieves the entire 128-byte element located at unpacked indices [2][5][17]. |
| **Single Byte**      | `my_array[1][3][20][byte_index]`  | Accesses a specific byte within an element. `byte_index` (0-127) selects a byte. |
| **Single Bit**       | `my_array[0][10][5][byte_index][bit_index]` | Accesses a specific bit. `byte_index` (0-127) and `bit_index` (0-7) are used. |
| **Byte Range (Slice)** | `my_array[4][25][10][15:0]`        | Extracts a contiguous slice of bytes (bytes 0 through 15) from an element.  |
| **Bit Slice (Nibble)** | `my_array[7][63][31][127][3:0]`     | Extracts a bit slice (lower nibble, bits 3 down to 0) from a specific byte.  |

### Efficient Iteration with `foreach`

SystemVerilog's `foreach` loop is ideal for iterating through multidimensional arrays:

```SV
foreach (my_array[i,j,k]) begin // Iterating over unpacked dimensions (banks, rows, cols)
  foreach (my_array[i][j][k][byte_index]) begin // Iterating over packed byte dimensions
    $display("Bank %0d, Row %0d, Col %0d, Byte %0d: %h",
             i, j, k, byte_index, my_array[i][j][k][byte_index]);
  end
end
```

### Key Indexing Considerations

1.  **Packed Dimension Order**: In packed dimensions (e.g., `[7:0]`), the **rightmost dimension is the least significant and changes fastest** during linear memory traversal.
2.  **Memory Footprint**: Packed arrays offer memory efficiency due to contiguous bit storage. Unpacked arrays, using pointers, might have a larger memory footprint, especially for very large arrays.
3.  **Synthesis Implications**: Unpacked arrays often imply block RAM implementations in hardware, while packed arrays are typically synthesized into registers or register files.

## Array Manipulation Methods: Beyond Basic Indexing

SystemVerilog provides a suite of powerful built-in methods to manipulate array data efficiently.  These methods are primarily applicable to dynamic arrays, queues, and associative arrays, enabling complex data processing and verification tasks.

### Searching and Filtering

| Method             | Description                                                 | Example with Expression                  |
| ------------------ | ----------------------------------------------------------- | ---------------------------------------- |
| **`.find()`**       | Returns a queue containing all elements that satisfy a condition. | `array.find(x) with (x > threshold)`   |
| **`.find_index()`** | Returns a queue of indices for elements meeting a condition. | `array.find_index(x) with (x % 2 != 0)` |
| **`.find_first()`** | Returns the first element that matches a condition.         | `array.find_first(x) with (x < min_val)`|
| **`.find_last()`**  | Returns the last element that matches a condition.          | `array.find_last(x) with (x == target)`  |
| **`.unique()`**     | Returns a queue of unique values from the array.           | `array.unique()`                         |
| **`.unique_index()`**| Returns indices of the first occurrence of each unique value. | `array.unique_index()`                   |

### Sorting and Ordering

| Method             | Description                                                 | Example with Custom Sort Clause        |
| ------------------ | ----------------------------------------------------------- | -------------------------------------- |
| **`.sort()`**       | Sorts array elements in ascending order (in-place).          | `array.sort() with (x < y)`            |
| **`.rsort()`**      | Sorts array elements in descending order (in-place).         | `array.rsort() with (y < x)`           |
| **`.reverse()`**    | Reverses the order of elements within the array (in-place). | `array.reverse()`                      |
| **`.shuffle()`**    | Randomizes the order of elements within the array (in-place).| `array.shuffle()`                      |

### Mathematical Reduction Operations

| Method          | Description                                           | Important Notes                                    |
| ---------------- | ----------------------------------------------------- | -------------------------------------------------- |
| **`.sum()`**      | Calculates the sum of all elements.                   | Result type automatically matches array element type. |
| **`.product()`**  | Calculates the product of all elements.               | Consider `longint` to prevent potential overflow.   |
| **`.min()`**      | Finds and returns the minimum element value.            | Can be used with `with` clauses for complex logic. |
| **`.max()`**      | Finds and returns the maximum element value.            | Supports complex expressions within `with` clauses. |

### Bitwise Reduction Operations (Packed Arrays)

| Method          | Description                                                  | Typical Use Case                             |
| ---------------- | ------------------------------------------------------------ | ------------------------------------------ |
| **`.and()`**      | Performs bitwise AND reduction across all array elements.     | `array.and()` is equivalent to `&array[0] & array[1] & ...` |
| **`.or()`**       | Performs bitwise OR reduction across all array elements.      | Combining flag bits, checking if any flag is set. |
| **`.xor()`**      | Performs bitwise XOR reduction across all array elements.     | Parity bit calculation across a data array.     |

## Illustrative Examples with Expected Outputs

### 1. Filtering with `find()` for Temperature Data

```SV
int temperatures[] = {-5, 12, 23, -3, 42, 18};
int below_freezing[] = temperatures.find(x) with (x < 0);
$display("Temperatures below freezing: %p", below_freezing);
// Output: Temperatures below freezing: '{-5, -3}
```

### 2. Sorting Strings by Length using `sort()` with `with` Clause

```SV
string names[] = {"Alice", "Bob", "Charlie"};
names.sort() with (x.len()); // Sort names based on string length
$display("Sorted by length: %p", names);
// Output: Sorted by length: '{"Bob", "Alice", "Charlie"}
```

### 3. Bitwise AND Reduction on a Packed Array of Masks

```SV
bit [3:0] masks[] = {4'b1010, 4'b1100, 4'b1111};
bit [3:0] combined_mask = masks.and();
$display("Combined AND mask: %b", combined_mask);
// Output: Combined AND mask: 1000 (1010 & 1100 & 1111 = 1000)
```

### 4. Finding Unique Indices with `unique_index()`

```SV
int data_stream[] = {5, 2, 5, 7, 2, 9};
int unique_indices[] = data_stream.unique_index();
$display("Indices of first unique values: %p", unique_indices);
// Output: Indices of first unique values: '{0, 1, 3, 5} (indices of 5, 2, 7, 9)
```

### 5. Method Chaining for Concise Operations

```SV
int sample_values[] = {8, 3, 5, 8, 2, 5};
int unique_sum = sample_values.unique().sum(); // Chain unique() and sum()
$display("Sum of unique values: %0d", unique_sum);
// Output: Sum of unique values: 18 (unique values are {8, 3, 5, 2}, sum is 18)
```

## Important Considerations for Array Manipulation

1.  **In-Place Modification**: Be aware that methods like `.sort()`, `.rsort()`, `.reverse()`, and `.shuffle()` directly modify the original array. If you need to preserve the original array, create a copy before applying these methods.
2.  **Method Applicability**: Built-in array manipulation methods are primarily designed for dynamic arrays, queues, and associative arrays. They are not directly applicable to fixed-size arrays.
3.  **Flexibility of `with` Clause**: The `with` clause offers powerful customization for filtering and sorting. It can incorporate complex expressions and even access struct members for sophisticated data manipulation:

    ```SV
    typedef struct packed { int age; string name; } person_t;
    person_t people[] = ...;
    people.sort() with (x.age); // Sort an array of structs based on the 'age' field
    ```

4.  **Empty Result Handling**: Searching and filtering methods (e.g., `.find()`, `.find_index()`) return empty queues when no matching elements are found. Always check the size of the returned queue to handle cases with no matches gracefully.
5.  **Performance**: Methods for associative arrays, especially those involving searching or sorting, may have a time complexity of O(n log n) in the worst case, where n is the number of elements. Be mindful of performance implications when using these methods on very large associative arrays.

## Practical Exercises to Enhance Your Skills

1.  **Memory Byte Extraction**: Given the `my_array[8][64][32]` structure from the introduction, write code to extract bytes 64-127 from the first element `my_array[0][0][0]` and display them.
2.  **Financial Transaction Validation**: You have a queue of transaction objects, each with an amount. Use array methods to find all transactions with amounts exceeding $1000 and return a queue containing these transactions.
3.  **Packet Checksum Calculation**: For a dynamic array representing a data packet, calculate the bitwise XOR checksum of all bytes in the packet, excluding the first 4 bytes (header).
4.  **Unique Address Generation**: Create a dynamic array to store 100 unique 32-bit addresses. Use a combination of `.unique()` and `.shuffle()` to generate and ensure uniqueness and randomness in the address list.
5.  **Error Event Sorting**: You have an associative array where keys are error codes (strings) and values are timestamps (time type). Sort the error codes based on their timestamps in ascending order and display the sorted error codes.

## Pro-Level Tips for Array Mastery

1.  **Combined Indexing and Method Application**: SystemVerilog allows for powerful combinations of indexing and array methods. For example, to extract a slice of bytes from all elements of a multidimensional array concisely:

    ```SV
    // Extract bytes 64-127 (upper half) from all elements of 'my_array'
    foreach (my_array[i, j, k]) begin
        upper_bytes[i][j][k] = my_array[i][j][k][127:64];
    end
    ```

2.  **Efficient Condition-Based Searching**: Leverage the `with` clause for highly efficient searches within arrays, especially for complex conditions:

    ```SV
    // Find the first element in a 2D matrix that falls within the range [10:20]
    int matrix[10][20]; // Example 2D dynamic array
    int found_element = matrix.find_first() with (item inside {[10:20]});
    ```

3.  **Conditional Summation for Targeted Aggregation**: Use the `with` clause within `.sum()` to perform conditional summations, allowing you to aggregate only specific elements based on criteria:

    ```SV
    // Calculate the sum of only positive values in an array
    int all_values[] = ...;
    int positive_sum = all_values.sum() with (item > 0 ? item : 0);
    ```

4.  **RTL Design with Packed Arrays and Bitwise Methods**: For synthesis-friendly RTL code, utilize packed arrays and bitwise reduction methods for efficient hardware implementations:

    ```SV
    // Example: Register file parity calculation using packed array and .xor()
    logic [7:0][31:0] register_file; // Packed array representing a register file
    assign parity_bit = register_file[3].xor(); // Calculate parity of register 3
    ```

By deeply understanding and practicing these array manipulation techniques, you will significantly enhance your SystemVerilog proficiency, enabling you to tackle complex verification challenges and design sophisticated hardware architectures with greater efficiency and precision.

##### Copyright (c) 2026 squared-studio

