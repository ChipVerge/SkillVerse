# Chapter 5: Apply Formal Techniques to Simple Designs

## Start Small
Begin with simple designs to understand the basics of formal verification. This helps in grasping the concepts without being overwhelmed by complexity.

### Key Steps:
- **Identify Simple Designs**: Such as counters, simple state machines, or combinational logic.
  - **Example**: A 4-bit binary counter that increments on each clock cycle.
    - **Explanation**: A binary counter is a simple sequential circuit that goes through a predefined sequence of states. In this case, it counts from 0 to 15 and then wraps around to 0.
- **Write Basic Properties**: Assertions that describe the expected behavior.
  - **Example**: assert property (@(posedge clk) counter == counter + 1); // Checks if the counter increments correctly.
    - **Explanation**: This assertion checks that on every positive edge of the clock, the counter value is incremented by 1.

## Write Properties
Writing properties is a crucial part of formal verification. Properties describe the expected behavior of the design and are used to check its correctness.

### Key Concepts:
- **Functional Properties**: Describe what the design should do.
  - **Example**: assert property (a -> b); // Checks if b follows a.
    - **Explanation**: This property asserts that whenever 'a' is true, 'b' should also be true.
- **Safety Properties**: Ensure that something bad never happens.
  - **Example**: assert property (!error); // Checks that the error signal is never asserted.
    - **Explanation**: This property ensures that the 'error' signal is never asserted, indicating that the design operates correctly without errors.
- **Liveness Properties**: Ensure that something good eventually happens.
  - **Example**: assert property (eventually (done)); // Checks that the done signal is eventually asserted.
    - **Explanation**: This property ensures that the 'done' signal is eventually asserted, indicating that the design completes its intended operation.

##### Copyright (c) 2026 ChipVerge

