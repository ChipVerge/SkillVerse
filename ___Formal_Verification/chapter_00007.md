# Chapter 7: Learn Advanced Formal Concepts

## Bounded Model Checking (BMC)
BMC is a technique used to check the correctness of a design up to a certain depth. It is useful for finding bugs that occur within a limited number of steps.

### Key Concepts:
- **Bounded Depth**: The maximum number of steps to check.
  - **Example**: Checking the design for up to 10 clock cycles.
- **Unrolling**: Expanding the design over time to check properties.
  - **Example**: Unrolling a loop to check its behavior over multiple iterations.
- **SAT Solvers**: Tools used to solve the resulting Boolean formulas.
  - **Example**: Using a SAT solver to determine if a property holds within the bounded depth.

## Equivalence Checking
Equivalence checking is used to ensure that two versions of a design are functionally identical. This is important when making optimizations or changes to a design.

### Key Concepts:
- **Combinational Equivalence Checking**: Checking equivalence of combinational logic.
  - **Example**: Ensuring that two different implementations of an adder produce the same result.
- **Sequential Equivalence Checking**: Checking equivalence of sequential logic.
  - **Example**: Ensuring that two different implementations of a state machine produce the same sequence of states.
- **Formal Methods**: Techniques used to prove equivalence.
  - **Example**: Using formal proofs to show that two designs are equivalent under all possible inputs.

##### Copyright (c) 2026 ChipVerge

