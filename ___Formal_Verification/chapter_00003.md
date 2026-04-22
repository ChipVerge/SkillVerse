# Chapter 3: Master Assertion-Based Verification (ABV)

## SystemVerilog Assertions (SVA)
SVA is a language used to specify properties of digital designs. It allows designers to write assertions that can be checked during simulation or formal verification.

### Key Concepts:
- **Immediate Assertions**: Checked at a specific point in time.
  - **Example**: assert (a == b); // Checks if a is equal to b at the current time.
- **Concurrent Assertions**: Checked over a period of time.
  - **Example**: assert property (@(posedge clk) a |=> b); // Checks if b follows a on the next clock edge.
- **Sequences and Properties**: Building blocks of assertions.
  - **Sequence**: A series of events or conditions.
    - **Example**: sequence s1; a ##1 b; endsequence // Defines a sequence where b follows a after one clock cycle.
  - **Property**: A statement about the expected behavior of the design.
    - **Example**: property p1; @(posedge clk) s1 |=> c; endproperty // Defines a property that checks if c is true when sequence s1 occurs.

## Property Specification Language (PSL)
PSL is another language for specifying properties of digital designs. It is similar to SVA but can be used with multiple hardware description languages.

### Key Concepts:
- **Assertions**: Statements about the expected behavior of a design.
  - **Example**: assert always (req -> next (ack)); // Checks if ack follows req.
- **Temporal Expressions**: Used to describe sequences of events.
  - **Example**: always (a -> eventually b); // Checks if b eventually follows a.
- **Verification Directives**: Instructions for the verification tool.
  - **Example**: assume property (a); // Assumes a is always true during verification.

##### Copyright (c) 2026 ChipVerge

