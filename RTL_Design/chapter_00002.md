# Digital Design Fundamentals Review

This chapter revisits the essential building blocks of digital circuits, providing a solid foundation for understanding and creating RTL designs. It covers combinational and sequential logic, along with fundamental timing concepts that are crucial for synchronous digital design.

## Combinational Logic
  - **Gates:**
    - Review basic logic gates: AND, OR, NOT, NAND, NOR, XOR, XNOR.
    - Understand their truth tables, Boolean expressions, and symbols (both schematic and Verilog).
    - Universal gates (NAND and NOR) and their importance in implementation.
  - **Boolean Algebra:**
    - Laws and theorems of Boolean algebra: Commutative, Associative, Distributive, Identity, Complement, De Morgan's laws, etc.
    - Using Boolean algebra for logic expression manipulation and simplification.
  - **Logic Simplification:**
    - Simplification techniques: Algebraic manipulation using Boolean laws, Karnaugh Maps (K-maps) for 2, 3, and 4 variables.
    - Understanding sum-of-products (SOP) and product-of-sums (POS) forms.
    - Don't-care conditions and their use in simplification.
  - **Karnaugh Maps (K-maps):**
    - Graphical method for simplifying Boolean expressions.
    - Grouping adjacent minterms (1s) or maxterms (0s) to find minimal expressions.
    - Handling don't-care conditions in K-maps.
  - **Multiplexers (Muxes):**
    - Functionality: Selecting one of several data inputs and forwarding it to a single output based on select inputs.
    - Implementation using logic gates.
    - Applications: Data selection, routing, function generation.
  - **Decoders:**
    - Functionality: Converting a binary code into a unique output signal.
    - Implementation using logic gates.
    - Applications: Address decoding, enabling memory or peripherals.
  - **Encoders:**
    - Functionality: Converting an active input signal into a binary code.
    - Priority encoders: Handling multiple active inputs.
    - Applications: Interrupt handling, priority arbitration.
  - **Adders:**
    - Half adder and Full adder: Building blocks for binary addition.
    - Ripple carry adder: Simple adder implementation, but slow for larger bit widths.
    - Carry lookahead adder (brief introduction): Concept of faster addition using parallel carry calculation.
  - **Multipliers (brief introduction):**
    - Basic concept of binary multiplication.
    - Array multiplier (brief overview): A common combinational multiplier architecture.

## Sequential Logic
  - **Latches:**
    - SR Latch, D Latch: Basic memory elements.
    - Level-sensitive behavior: Output changes when the enable signal is active (high or low level).
    - Transparency issues and why latches are generally avoided in synchronous designs.
  - **Flip-flops (D, SR, JK, T):**
    - D Flip-flop: Most commonly used flip-flop, data is sampled at the clock edge.
    - SR Flip-flop, JK Flip-flop, T Flip-flop: Understand their characteristic tables and behavior.
    - Edge-triggered behavior: Output changes only at the rising or falling edge of the clock.
    - Master-slave configuration (brief concept): How edge-triggering is achieved.
  - **Registers:**
    - Arrays of flip-flops: Used to store multi-bit data.
    - Parallel load and shift registers.
    - Register files (conceptual overview): Arrays of registers used in processors.
  - **Counters:**
    - Asynchronous (ripple) counters and synchronous counters.
    - Binary counters, BCD counters, up/down counters.
    - Modulo-N counters: Counters that count up to a specific value and then reset.
  - **Shift Registers:**
    - Serial-in Serial-out (SISO), Serial-in Parallel-out (SIPO), Parallel-in Serial-out (PISO), Parallel-in Parallel-out (PIPO) shift registers.
    - Applications: Serial data communication, data delay, sequence generation.

## Synchronous Design Mindset
  - **Registers Define Time Boundaries:** In synchronous RTL, registers divide the design into clock-to-clock stages, with combinational logic between them.
  - **Inputs are Sampled at Clock Edges:** For most synchronous systems, values become architecturally meaningful when captured by flip-flops on the active clock edge.
  - **Combinational Logic Must Settle in Time:** The logic between two registers must produce a stable value early enough for reliable capture by the destination register.
  - **Good RTL Matches This Model:** This is why `always_ff` is used for sequential behavior and `always_comb` or `assign` is used for combinational behavior.
  - **Glitches Matter:** A circuit may settle to the right final value and still be unsafe if transient glitches feed asynchronous controls or cross into other clock domains.

## Timing Diagrams and Basic Timing Concepts
  - **Timing Diagrams:**
    - Graphical representation of signal values as a function of time.
    - Understanding how to read and interpret timing diagrams for combinational and sequential circuits.
    - Using timing diagrams to analyze circuit behavior and identify potential timing issues.
  - **Setup Time:**
    - Definition: The minimum time data must be stable *before* the active clock edge for reliable data capture by a flip-flop.
    - Importance: A setup violation can cause incorrect capture and, in some cases, metastability.
  - **Hold Time:**
    - Definition: The minimum time data must be stable *after* the active clock edge to ensure reliable data capture.
    - Importance: A hold violation can corrupt the sampled value and may also lead to metastability.
  - **Clock-to-Q Delay (t<sub>cq</sub> or clk-Q):**
    - Definition: The time delay from the active clock edge to when the output of a flip-flop (Q) becomes valid.
    - Impact on circuit speed: Clock-to-Q delay contributes to the overall propagation delay in sequential circuits.
  - **Propagation Delay (for combinational logic):**
    - Definition: The time delay for a signal to propagate through a combinational logic path from input to output.
    - Impact on circuit speed: Propagation delay limits the maximum clock frequency.
  - **Clock Period and Frequency:**
    - Relationship between clock period and frequency (Frequency = 1/Period).
    - Determining the minimum clock period based on timing parameters (setup time, clock-to-Q delay, propagation delay).

## Register-to-Register Timing Intuition
  - **Setup Check:** A common timing model is `Tclk >= tcq + tcomb + tsetup + margin`. This expresses that launched data must traverse the combinational path and still arrive in time for capture.
  - **Hold Check:** A simplified hold condition is `tcq(min) + tcomb(min) >= thold + skew`. This ensures data does not change too quickly after the receiving edge.
  - **Critical Path:** The longest register-to-register combinational path usually limits the maximum clock frequency.
  - **Short Paths Matter Too:** Designers often focus on setup timing, but very short paths can cause hold problems, especially after place-and-route.
  - **Timing Closure Starts in RTL:** Balanced pipelines, sensible partitioning, and clean clock/reset strategies make downstream timing closure much easier.

## Learning Resources

### Review chapters on combinational and sequential logic from any standard digital design textbook
  - **Search Query Suggestion:** Use search engines to find "digital logic design textbook," "fundamentals of digital design book," "computer organization textbook." Look for textbooks commonly used in undergraduate computer engineering or electrical engineering courses.
  - **Textbook Examples:** Some popular textbooks include:
    - "Digital Design and Computer Architecture" by David Money Harris and Sarah L. Harris
    - "Digital Logic and Computer Design" by M. Morris Mano
    - "Fundamentals of Digital Logic with Verilog HDL Design" by Stephen Brown and Zvonko Vranesic
  - **Chapter Focus:**  Specifically review chapters covering:
    - Number systems and Boolean algebra
    - Logic gates and logic simplification
    - Combinational logic circuits (multiplexers, decoders, adders, etc.)
    - Flip-flops and sequential logic circuits (registers, counters, shift registers)
    - Timing concepts in digital circuits

### Online resources like Khan Academy and Coursera for digital logic design fundamentals
  - **Khan Academy ([Digital Information | Khan Academy](https://www.khanacademy.org/computing/computer-science/digital-information))**
    - Navigate to the "Digital Information" section under "Computer Science."
    - Explore chapters on "Logic gates," "Boolean algebra," "Combinational circuits," "Sequential circuits."
    - Khan Academy provides video lectures, articles, and practice exercises to reinforce understanding.
  - **Coursera ([Digital Design Courses | Coursera](https://www.coursera.org/courses?query=digital%20design))**
    - Search for courses using the query "digital design" or "digital logic."
    - Look for introductory courses like "Digital Systems: From Logic Gates to Processors" or similar titles offered by universities.
    - Coursera courses often provide structured video lectures, readings, assignments, and quizzes.

### YouTube tutorials on combinational and sequential circuits
  - **Search Query Suggestion:** Use Youtube terms like "combinational logic tutorial," "sequential logic tutorial," "digital logic gates explained," "flip-flops explained," "timing diagrams digital circuits."
  - **Channels to Explore:** Look for channels from universities or educational platforms that offer digital logic or electronics courses. Channels like "Neso Academy," "Tutorials Point," "Learn ইলেকট্রনিক্স" (Bangla channel, if language is preferred) can be helpful.
  - **Focus on Visual Explanations:** YouTube is excellent for visual learners. Look for videos that use animations and diagrams to explain the operation of logic gates, flip-flops, and circuits, and how timing diagrams represent signal behavior.

## Exercises

### Design simple combinational circuits using SystemVerilog (e.g., a 4-bit adder, a 2-to-1 multiplexer)
  - **4-bit Adder:**
    - Implement a 4-bit ripple carry adder in SystemVerilog.
    - Use `assign` statements for combinational logic.
    - Simulate to verify correct addition for various input combinations.
  - **2-to-1 Multiplexer:**
    - Implement a 2-to-1 multiplexer in SystemVerilog.
    - Use `assign` statement or `always_comb` block for combinational logic.
    - Verify functionality by simulating with different select and data inputs.
  - **Other Combinational Circuits (choose from):**
    - 4-bit magnitude comparator
    - 3-to-8 decoder
    - 8-to-3 priority encoder
  - **SystemVerilog Constructs:** Focus on using `assign` statements and `always_comb` blocks for describing combinational logic.

### Design simple sequential circuits using SystemVerilog (e.g., a D flip-flop, a 4-bit counter)
  - **D Flip-flop:**
    - Implement a D flip-flop in SystemVerilog.
    - Use `always_ff` block with `@(posedge clk)` or `@(negedge clk)` for sequential logic.
    - Simulate to verify D flip-flop behavior (data capture at clock edge).
  - **4-bit Counter:**
    - Implement a 4-bit synchronous counter (up counter).
    - Use `always_ff` block for sequential updates and `always_comb` for next-state logic.
    - Include reset functionality (synchronous or asynchronous).
    - Simulate to verify counting sequence and reset operation.
  - **Other Sequential Circuits (choose from):**
    - 4-bit shift register (SISO, PISO, etc.)
    - Modulo-10 counter (BCD counter)
    - Simple finite state machine (e.g., sequence detector - covered in more detail in later chapters, but a basic example here is helpful)
  - **SystemVerilog Constructs:** Focus on using `always_ff` blocks with appropriate clock edge triggering for sequential logic. Experiment with different types of flip-flops (D, JK, SR if desired for practice).

### Draw and explain a register-to-register timing path
  - **Choose a Path:** Use a source flip-flop, a block of combinational logic, and a destination flip-flop.
  - **Label Timing Terms:** Mark `t_cq`, combinational delay, setup time, and hold time on the diagram.
  - **Show a Passing Case:** Draw a waveform where data launches and arrives in time for correct capture.
  - **Show a Failing Case:** Draw either a setup violation or a hold violation and explain the failure mechanism.
  - **Relate it Back to RTL:** Explain which SystemVerilog blocks describe the source register, combinational logic, and destination register.

##### Copyright (c) 2026 squared-studio

