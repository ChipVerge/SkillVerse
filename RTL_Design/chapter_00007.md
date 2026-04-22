# Pipelining

This chapter introduces pipelining, a crucial technique in digital design for enhancing the throughput of digital systems, especially in high-performance applications. Pipelining allows for increased operational speed by overlapping the execution of multiple instructions or data sets. This chapter covers the fundamental concepts of pipelining, its benefits, challenges, and implementation considerations in RTL design.

*   **Pipelining Concepts and Motivation (Throughput Improvement):**
    *   **Definition of Pipelining:**
        - A design technique that breaks down a complex operation or task into a sequence of smaller, independent stages.
        - Each stage performs a part of the overall operation, and the stages are connected in a series, like an assembly line.
        - Registers are inserted between stages to hold intermediate results and allow stages to operate concurrently.
    *   **Motivation for Pipelining:**
        - **Throughput Improvement:** The primary goal of pipelining is to increase the *throughput* of a system, which is the rate at which operations are completed (e.g., operations per second, data processed per second).
        - **Parallelism:** Pipelining achieves parallelism by allowing multiple operations to be in different stages of execution simultaneously. While one operation is in stage 1, the next operation can be in stage 2, and so on.
        - **Increased Clock Frequency (Potentially):** By breaking down long combinational paths, pipelining can potentially allow for a higher clock frequency, further increasing throughput.  However, this is not always guaranteed and depends on the original design's critical path.
    *   **Analogy: Laundry Pipeline:**
        - **Non-pipelined (Sequential Laundry):** Wash -> Dry -> Fold for each load, one after another.  If each step takes 1 hour, completing 3 loads takes 9 hours.
        - **Pipelined Laundry:**  Start washing Load 1. After 1 hour, start drying Load 1 *and* start washing Load 2. After another hour, start folding Load 1, start drying Load 2, *and* start washing Load 3.  Now, in 3 hours, the first load is finished, and subsequent loads finish every hour. Throughput is increased (loads per hour).
    *   **Throughput vs. Latency (Introduced here, detailed later):** Pipelining primarily improves throughput, not necessarily the latency of a single operation. In the laundry analogy, the time for one load to go through all steps (latency) might be slightly longer in a pipelined system due to moving between machines, but the number of loads completed per hour (throughput) is much higher.

*   **Pipeline Stages and Registers:**
    *   **Pipeline Stages:**
        - A complex operation is divided into smaller, sequential sub-operations, each performed in a dedicated pipeline stage.
        - Stages should be designed to be roughly balanced in terms of delay to maximize pipeline efficiency. The stage with the longest delay determines the overall clock cycle time.
        - Example stages in an arithmetic pipeline (e.g., for floating-point addition): Instruction Fetch, Operand Fetch, Exponent Compare, Mantissa Align, Add Mantissas, Normalize, Result Writeback.
    *   **Pipeline Registers (Inter-stage Registers):**
        - Registers are placed between pipeline stages to store the intermediate results produced by each stage.
        - These registers act as boundaries between stages, allowing stages to operate independently and concurrently.
        - Registers are clocked, ensuring that data moves from one stage to the next at each clock cycle.
        - Pipeline registers introduce latency but enable throughput improvement.
    *   **Example: Pipelining a Combinational Adder:**
        - **Non-pipelined 32-bit adder:** A single combinational block that performs 32-bit addition. Critical path delay is the carry propagation delay through 32 bits.
        - **2-stage pipelined adder:**
            - Stage 1: Lower 16-bit adder (calculates sum and carry for lower 16 bits). Pipeline register after stage 1.
            - Stage 2: Upper 16-bit adder (calculates sum and carry for upper 16 bits, using carry from stage 1).
            - Pipeline register between stage 1 and stage 2 stores the carry-out from the lower 16-bit addition.
            - Clock cycle time is now limited by the delay of a 16-bit adder (roughly half of the 32-bit adder delay), potentially allowing for a higher clock frequency.

*   **Latency vs. Throughput:**
    *   **Latency:**
        - Definition: The time it takes for a single operation to complete from input to output.  Measured in units of time (e.g., nanoseconds, clock cycles).
        - In a non-pipelined system, latency is the delay of the entire combinational logic.
        - In a pipelined system with *N* stages, the latency for a single operation is approximately *N* clock cycles (assuming each stage takes one clock cycle). Pipelining generally *increases* latency for a single operation.
    *   **Throughput:**
        - Definition: The rate at which operations are completed. Measured in operations per unit time (e.g., operations per second, data items processed per second).
        - In a non-pipelined system, throughput is limited by the latency of the entire operation.  Throughput ≈ 1 / (Latency).
        - In an ideal *N*-stage pipelined system, after the pipeline is filled (pipeline startup), one operation completes every clock cycle.  Throughput ≈ Clock Frequency.  Pipelining significantly *increases* throughput.
    *   **Trade-off:** Pipelining trades off increased latency for individual operations for significantly improved throughput of the system as a whole.
    *   **Example (Adder):**
        - Non-pipelined 32-bit adder: Latency = 10ns, Throughput = 1 operation / 10ns = 100 million operations/second (100 MHz equivalent throughput).
        - 2-stage pipelined adder: Stage delay = 6ns (approx.), Clock cycle = 6ns (Frequency ~ 166 MHz), Latency = 2 clock cycles = 12ns, Throughput = 1 operation / 6ns = 166 million operations/second (166 MHz).
        - Latency increased from 10ns to 12ns, but throughput increased from 100 MHz to 166 MHz.

*   **Pipeline Hazards (Data Hazards, Control Hazards, Structural Hazards) and How to Avoid/Resolve Them:**
    *   **Hazards:** Situations that prevent the next instruction in the pipeline from executing during its designated clock cycle. Hazards reduce the ideal performance gain from pipelining.
    *   **Data Hazards (Dependencies):**
        - Occur when an instruction depends on the result of a previous instruction that is still in the pipeline and not yet available.
        - Example:
            ```
            Instruction 1: R1 = R2 + R3  (Result in R1 is produced in stage 3)
            Instruction 2: R4 = R1 * R5  (Instruction 2 needs R1 as input)
            ```
            Instruction 2 cannot proceed until Instruction 1 has completed stage 3 and written the result to R1.
        - **Resolutions:**
            - **Forwarding (Bypassing):** Provide the result of Instruction 1 directly from the output of stage 3 to the input of stage 2 for Instruction 2, without waiting for it to be written back to the register file.  Requires additional forwarding paths in hardware.
            - **Stalling (Pipeline Bubbles):**  Insert "bubble" or "stall" cycles in the pipeline. Instruction 2 is stalled for one or more cycles until the result from Instruction 1 is available. Reduces throughput but is simpler to implement than forwarding.
    *   **Control Hazards (Branch Hazards):**
        - Occur in instruction pipelines when a branch instruction is encountered. The pipeline may not know which instruction to fetch next until the branch condition is evaluated (which happens in a later stage).
        - Example:
            ```
            Instruction 1: Branch if R6 == 0 to Label X
            Instruction 2 (if branch not taken): ... (Instruction to fetch next)
            Instruction at Label X (if branch taken): ... (Instruction to fetch if branch taken)
            ```
        - **Resolutions:**
            - **Stalling:** Stall the pipeline until the branch outcome is known and the correct instruction can be fetched.
            - **Branch Prediction:** Predict whether the branch will be taken or not taken. Fetch instructions based on the prediction. If the prediction is correct, no penalty. If incorrect, pipeline needs to be flushed and restarted from the correct branch target (branch misprediction penalty).
            - **Delayed Branching:**  Rearrange instructions so that instructions immediately following the branch are always executed, regardless of the branch outcome.  Less common in modern architectures.
    *   **Structural Hazards (Resource Conflicts):**
        - Occur when multiple instructions in the pipeline need to use the same hardware resource in the same clock cycle.
        - Example: If instruction fetch and data memory access both use the same memory port in the same cycle.
        - **Resolutions:**
            - **Stalling:** Stall one of the instructions that needs the resource.
            - **Resource Duplication:**  Duplicate the hardware resource so that multiple instructions can access it simultaneously (e.g., separate instruction and data memories - Harvard architecture, or dual-ported memory).
            - **Pipeline Stage Scheduling:**  Carefully design the pipeline stages to avoid resource conflicts in the same clock cycle.

*   **Pipelining Considerations in RTL Design:**
    *   **Identify Pipeline Stages:** Analyze the operation to be pipelined and divide it into balanced stages. Consider data flow and dependencies.
    *   **Insert Pipeline Registers:** Add registers between stages in the RTL code to store intermediate values. Use `always_ff` blocks for these registers.
    *   **Data Forwarding Logic (if needed):** Implement forwarding paths in RTL to resolve data hazards. This involves adding multiplexers and control logic to bypass pipeline registers and provide data directly from stage outputs to stage inputs.
    *   **Stall Logic (if needed):** Implement stall control logic to insert pipeline bubbles when hazards occur. This requires adding control signals to disable register updates in certain cycles.
    *   **Control Logic for Pipelined Execution:** Design control logic to manage the flow of data through the pipeline stages, handle control signals, and manage hazards. FSMs are often used to control pipelined execution.
    *   **Verification of Pipelined Designs:** Thoroughly verify pipelined designs through simulation to ensure correct functionality and hazard resolution. Test cases should cover various data and control flow scenarios, including hazard conditions.
    *   **Timing Analysis:** Perform static timing analysis to ensure that each pipeline stage meets timing constraints for the target clock frequency, considering setup and hold times of pipeline registers and combinational delays within stages.

## Learning Resources

*   **Computer architecture textbooks chapters on pipelining (e.g., "Computer Organization and Design" by Patterson and Hennessy):**
    *   **Textbook Example:** "Computer Organization and Design, RISC-V Edition" by David A. Patterson and John L. Hennessy ([Computer Organization and Design, RISC-V Edition - 2nd Edition](https://www.elsevier.com/books/computer-organization-and-design-risc-v-edition/patterson/978-0-12-820331-6)). Chapters on "Pipelining" or "Instruction-Level Parallelism."
    *   **Focus on Architectural Concepts:** Computer architecture textbooks provide a comprehensive understanding of pipelining concepts in the context of CPU design, including instruction pipelines, pipeline stages, hazards, and hazard resolution techniques (forwarding, stalling, branch prediction). These concepts are fundamental and applicable to pipelining in general digital designs.
    *   **Theoretical Foundation:**  These resources provide the theoretical foundation and motivation for pipelining, explaining why and how it works, and the trade-offs involved.

*   **Online articles and tutorials on pipelining in digital design:**
    *   **Search Query Suggestion:** Search for "pipelining digital design tutorial," "RTL pipelining techniques," "FPGA pipelining," "ASIC pipelining," "pipeline hazards explanation."
    *   **Focus on RTL Implementation:** Look for tutorials and articles that focus on the RTL implementation aspects of pipelining, showing code examples in SystemVerilog or VHDL for pipelined arithmetic units, data paths, or simple processors.
    *   **Practical Examples:** Search for examples of pipelined adders, multipliers, or simple ALUs in RTL to understand how pipelining is applied in practice.

*   **Examples of pipelined architectures (e.g., pipelined adder, pipelined multiplier):**
    *   **Search Query Suggestion:** Search for "pipelined adder RTL," "pipelined multiplier Verilog," "pipelined ALU SystemVerilog," "example of pipelined datapath."
    *   **Open-Source RTL Repositories (GitHub):** Explore GitHub for open-source RTL projects that implement pipelined arithmetic units or processors. Search for repositories using keywords like "pipelined adder," "pipelined multiplier," "RISC-V pipeline."
    *   **University Course Materials:**  Look for online course materials (lecture slides, lab assignments) from universities that offer courses on computer architecture or digital design. These materials often include examples of pipelined designs and exercises.

## Exercises

*   **Pipeline a combinational multiplier to improve its throughput:**
    *   **Start with a Combinational Multiplier:** Begin with the RTL code of a non-pipelined combinational multiplier (e.g., array multiplier).
    *   **Divide into Stages:** Analyze the multiplier's operation and divide it into 2 or 3 pipeline stages. For example, a 2-stage pipeline for an array multiplier could be:
        - Stage 1: Partial product generation.
        - Stage 2: Partial product summation.
    *   **Insert Pipeline Registers:** Insert registers between the stages in the RTL code. Register the outputs of Stage 1 and use these registered outputs as inputs to Stage 2.
    *   **Verify Functionality:** Write a testbench to verify the functionality of both the non-pipelined and pipelined multipliers. Ensure both produce the correct multiplication results.
    *   **Synthesize and Compare:** Synthesize both designs using a synthesis tool and compare the synthesis reports, focusing on:
        - Maximum achievable clock frequency (performance improvement due to pipelining).
        - Latency (increase in latency in clock cycles).
        - Area (increase in area due to pipeline registers).

*   **Analyze the latency and throughput of pipelined vs. non-pipelined designs:**
    *   **Use the Pipelined Multiplier from the previous exercise.**
    *   **Calculate Latency:**
        - Non-pipelined: Latency in clock cycles is 1 cycle (assuming it's a purely combinational block, though in reality, there will be some delay).  Latency in time is the critical path delay of the combinational multiplier.
        - Pipelined (2-stage): Latency is 2 clock cycles. Latency in time is approximately 2 * (delay of one pipeline stage).
    *   **Estimate Throughput:**
        - Non-pipelined: Throughput ≈ 1 / (Latency in time).  Maximum clock frequency is limited by the critical path delay of the combinational multiplier.
        - Pipelined: Throughput ≈ Clock Frequency. Maximum clock frequency is now limited by the delay of the *longest pipeline stage*, which is significantly reduced compared to the original combinational multiplier.
    *   **Simulation and Measurement:** In simulation, measure the time it takes to get the output for a single input for both designs (latency). Measure how many multiplications can be completed in a given time period for both designs (throughput). Compare the measured values with the calculated estimates.
    *   **Discuss Trade-offs:**  Discuss the trade-off between latency and throughput achieved by pipelining.

*   **Identify potential hazards in a given pipelined design and suggest solutions:**
    *   **Provide a Pipelined RTL Code Snippet:** The instructor provides a snippet of RTL code for a simple pipelined datapath (e.g., a simplified arithmetic pipeline or a sequence of operations with dependencies). The code snippet should contain potential data or control hazards.
    *   **Analyze for Hazards:** The trainee engineer should analyze the RTL code to:
        - Identify potential data hazards (read-after-write dependencies).
        - Identify potential control hazards (if branch instructions are included).
        - Identify potential structural hazards (if resource conflicts are apparent).
    *   **Suggest Solutions:** For each identified hazard, suggest possible solutions:
        - Data Hazards: Forwarding, Stalling. Explain how forwarding or stalling could be implemented in the given design.
        - Control Hazards: Stalling, Branch Prediction (if applicable to the example). Explain how these techniques could be applied.
        - Structural Hazards: Resource duplication, pipeline stage rescheduling.
    *   **Implement Hazard Resolution (Optional):**  As an extension, the trainee engineer can implement the suggested hazard resolution techniques (e.g., forwarding logic, stall control) in the RTL code and verify that the hazards are resolved through simulation.

##### Copyright (c) 2026 ChipVerge

