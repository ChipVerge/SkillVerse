# Assertion-Based Verification (ABV) with SystemVerilog Assertions (SVA)

This chapter introduces Assertion-Based Verification (ABV), a powerful verification methodology that uses assertions to formally specify and verify design behavior. We will explore the benefits of ABV, delve into SystemVerilog Assertions (SVA) syntax and semantics, learn how to use assertions for design specification and verification, integrate assertions into the verification flow, measure assertion coverage, and get a glimpse into formal verification with assertions. This chapter will equip you with the skills to use assertions effectively for early bug detection, improved design understanding, and enhanced verification confidence.

*   **Introduction to Assertion-Based Verification (ABV): Benefits of ABV, Types of Assertions:**
    *   **What is Assertion-Based Verification (ABV)?**
        - **Formal Specification of Design Intent:** ABV is a verification methodology that uses *assertions* to formally express the intended behavior and properties of a design. Assertions are statements that specify conditions that must always be true at specific points in the design's operation.
        - **Early Bug Detection:** Assertions act as runtime monitors that actively check for violations of design specifications during simulation. When an assertion fails, it immediately flags a potential design bug, often closer to the source of the error than traditional simulation-based debugging.
        - **Complementary to Simulation and Formal Verification:** ABV bridges the gap between simulation and formal verification. It enhances simulation by adding formal specification and can be a stepping stone towards formal property checking.
    *   **Benefits of ABV:**
        - **Early Bug Detection:** Assertions catch bugs earlier in the verification cycle, reducing debugging effort and time-to-market.
        - **Improved Debugging:** Assertion failures provide precise information about the location and nature of design violations, making debugging more efficient.
        - **Enhanced Design Understanding:** Writing assertions forces a deeper understanding of design specifications and intended behavior. Assertions serve as executable documentation of design intent.
        - **Increased Verification Confidence:** A comprehensive set of assertions increases confidence in the correctness of the design by actively monitoring key properties.
        - **Code Coverage Enhancement:** Assertions can improve functional coverage by highlighting design scenarios that are not being adequately tested.
        - **Formal Verification Readiness:** Assertions written for simulation can often be reused or adapted for formal verification, enabling a smooth transition to formal property checking.
    *   **Types of Assertions in SystemVerilog Assertions (SVA):**
        - **Immediate Assertions:**
            - **Procedural Assertions:**  Similar to conditional checks in procedural code (like `if` statements). They are evaluated *immediately* when the simulation execution reaches the assertion statement.
            - **Used for Combinational and Simple Sequential Checks:**  Suitable for checking conditions that can be evaluated in a single simulation cycle or within a procedural block.
            - **Syntax:** `assert (expression) else <optional_action_block>`
            - **Actions on Failure:**  On assertion failure, immediate assertions can trigger:
                - **Error Reporting:** Display an error message.
                - **Simulation Termination:** Stop the simulation.
                - **Breakpoints:**  Halt simulation for debugging.
            - **Example (Immediate Assertion):**
                ```SV
                always @(posedge clk) begin
                    if (enable_flag) begin
                        assert (data_valid) else
                            $error("Error: Data not valid when enable is asserted at time %0t", $time);
                        // ... design logic ...
                    end
                end
                ```
        - **Concurrent Assertions:**
            - **Temporal Assertions:**  Evaluate properties over *time*, spanning multiple clock cycles. They are evaluated concurrently with the design's behavior, triggered by clock edges.
            - **Used for Sequential Behavior and Protocol Verification:**  Essential for verifying temporal relationships, sequences of events, and protocol compliance in sequential designs.
            - **Syntax:** `property <property_name>; <property_expression>; endproperty assertion property (<property_name>) <optional_action_block>` or `assert property (<property_expression>) <optional_action_block>`
            - **Property Specification Language (PSL) Sub-set:** Concurrent assertions use a subset of Property Specification Language (PSL) for defining temporal properties using operators like:
                - **Sequence Operators:** `##`, `[*n]`, `[+n]`, `[*]`
                - **Temporal Operators:** `always`, `eventually`, `nexttime`, `s_nexttime`, `until`, `s_until`
            - **Actions on Failure:** On assertion failure, concurrent assertions typically trigger:
                - **Error Reporting:** Display an error message.
                - **Logging to Waveforms:**  Mark assertion failure in waveforms for post-simulation analysis.
                - **Coverage Collection:**  Assertion coverage metrics can be collected.
            - **Example (Concurrent Assertion):**
                ```SV
                property data_request_ack;
                    @(posedge clk)
                    request |-> ##1 acknowledge; // If 'request' is high, then 'acknowledge' should be high in the next cycle
                endproperty
                assert property (data_request_ack) else
                    $error("Error: Acknowledge not received after request at time %0t", $time);
                ```

*   **SystemVerilog Assertions (SVA) Syntax and Semantics: Immediate and Concurrent Assertions, Property Specification Language Basics:**
    *   **Immediate Assertions (Syntax and Semantics - Deeper Dive):**
        - **Syntax (Review):** `assert (expression) <optional_action_block>`
        - **Evaluation:** Evaluated procedurally in the flow of simulation, like a conditional statement.
        - **Action Blocks:**  Optional `else` action block is executed if the assertion fails. Action blocks can contain SystemVerilog procedural statements (e.g., `$error`, `$fatal`, `$display`, `$stop`).
        - **Example (Immediate Assertion with Action Block):**
            ```SV
            always @(posedge clk) begin
                if (state == STATE_IDLE) begin
                    assert (req_rdy) else begin
                        $error("Error: Request not ready in IDLE state at time %0t", $time);
                        $stop; // Stop simulation on failure
                    end
                end
            end
            ```
    *   **Concurrent Assertions (Syntax and Semantics - Deeper Dive):**
        - **Syntax (Review):** `property <property_name>; <property_expression>; endproperty assertion property (<property_name>) <optional_action_block>` or `assert property (<property_expression>) <optional_action_block>`
        - **Concurrent Evaluation:**  Evaluated concurrently with the design, triggered by clock events (specified using `@(posedge clk)` or `@(posedge event)`).
        - **Property Blocks (`property ... endproperty`):** Properties are named, reusable temporal expressions defined within `property` blocks. This improves readability and allows for parameterization and composition of properties.
        - **Assertion Directives (`assert property`):**  Assertion directives instantiate and monitor properties. They specify which property to check and the optional action block to execute on failure.
        - **Property Specification Language (PSL) Basics:**
            - **Boolean Expressions:**  Basic building blocks of properties are boolean expressions (SystemVerilog expressions that evaluate to true or false).
            - **Sequence Operators:**
                - **`##n` (Delay):**  Specifies a delay of *n* clock cycles. `a ##3 b` means "if *a* is true now, then *b* must be true 3 clock cycles later."
                - **`[*n]` (Repetition - Exactly n times):**  Specifies that a sequence must repeat exactly *n* times. `a [*3] b` means " *a* must be true for exactly 3 consecutive cycles, followed by *b* in the next cycle."
                - **`[+n]` (Repetition - At least n times):** Specifies that a sequence must repeat at least *n* times. `a [+3] b` means " *a* must be true for at least 3 consecutive cycles, followed by *b* in the next cycle."
                - **`[*]` (Repetition - Zero or more times):** Specifies that a sequence can repeat zero or more times. `a [*] b` means " *a* can be true for zero or more consecutive cycles, followed by *b* in the next cycle."
            - **Temporal Operators:**
                - **`|->` (Implication - Overlapping):**  If the *antecedent* (left side) sequence is true, then the *consequent* (right side) sequence must also be true, starting in the *same* clock cycle.
                - **`|=>` (Implication - Non-overlapping):** If the *antecedent* sequence is true, then the *consequent* sequence must also be true, starting in the *next* clock cycle.
                - **`always`:** Specifies that a property must be true in *all* clock cycles throughout the simulation.
                - **`eventually`:** Specifies that a property must become true at some point in the *future*.
                - **`nexttime`:** Specifies that a property must be true in the *next* clock cycle.
                - **`s_nexttime` (Strong Nexttime):** Similar to `nexttime`, but also handles the case where the antecedent is false.
                - **`until`:** Specifies that a property must be true *until* another property becomes true.
                - **`s_until` (Strong Until):** Similar to `until`, but also handles the case where the second property never becomes true.
            - **Example (Concurrent Assertion with Property and Sequence Operators):**
                ```SV
                property request_grant_sequence;
                    @(posedge clk)
                    (req ##1 gnt) |-> ##1 data_valid; // If req then grant in next cycle, then data_valid in the cycle after grant
                endproperty
                assert property (request_grant_sequence) else
                    $error("Error: Request-Grant-Data sequence violation at time %0t", $time);
                ```

*   **Using Assertions for Design Specification and Verification: Specifying Interfaces, Protocols, and Design Assumptions:**
    *   **Assertions as Executable Specifications:** Assertions serve as a precise and executable way to document and verify design specifications. They bridge the gap between informal specifications (text documents) and actual design implementation.
    *   **Specifying Interface Behavior:** Assertions are crucial for verifying interface protocols and ensuring correct communication between design modules or between the DUT and its environment.
        - **Protocol Sequencing:**  Use concurrent assertions with sequence operators to specify the correct sequence of signals in an interface protocol (e.g., request-grant protocols, bus protocols, memory interface protocols).
        - **Timing Constraints:** Use delay operators (`##n`) to specify timing relationships between signals on an interface (e.g., setup and hold times, response latencies).
        - **Data Validity:**  Use immediate or concurrent assertions to check data validity conditions on interfaces (e.g., data valid signals, data ranges, data formats).
    *   **Specifying Design Assumptions and Invariants:** Assertions can document and verify assumptions made during design and ensure that design invariants are maintained.
        - **Input Assumptions:**  Use assertions to check assumptions about the input stimuli or environment conditions that the design is expected to operate under.
        - **State Machine Invariants:**  Use assertions to verify properties that must always hold true for a state machine (e.g., mutually exclusive states, valid state transitions).
        - **Data Integrity Invariants:**  Use assertions to ensure data integrity throughout the design (e.g., data consistency across pipeline stages, data preservation during transformations).
    *   **Example (Interface Protocol Assertion - Request/Grant):**
        ```SV
        interface bus_if (input bit clk);
            logic req;
            logic gnt;
            logic [7:0] data;
            // ... interface signals ...
            property req_gnt_data_valid;
                @(posedge clk)
                req |-> ##1 gnt ##1 data_valid; // Request, then grant next cycle, then data_valid after grant
            endproperty : req_gnt_data_valid

            assertion interface_protocol_check;
                property (req_gnt_data_valid);
            endassertion : interface_protocol_check
        endinterface
        ```
    *   **Example (Design Assumption Assertion - FIFO Not Overflowing):**
        ```SV
        module fifo (input logic clk, rst, wr_en, rd_en, input logic [7:0] data_in, output logic [7:0] data_out, output logic full, empty);
            // ... FIFO implementation ...
            property fifo_not_overflowing;
                @(posedge clk)
                (!$past(full)) |-> !wr_en; // If FIFO was not full in the previous cycle, then write enable should not be asserted when FIFO is full
            endproperty : fifo_not_overflowing

            assert property (fifo_not_overflowing) else
                $error("Error: FIFO Overflow attempt detected at time %0t", $time);
        endmodule
        ```

*   **Integrating Assertions into the Verification Flow: Embedding Assertions in RTL and Testbenches, Assertion Coverage:**
    *   **Embedding Assertions in RTL (Design):**
        - **Assertions in Design Modules:** Assertions can and *should* be embedded directly into the RTL code of the design modules they are verifying.
        - **Design-Level Verification:**  Assertions in RTL provide *design-level verification*. They check properties of the design implementation itself, independent of the testbench.
        - **Portability and Reusability:** RTL assertions are portable and reusable across different testbenches and verification environments.
        - **Example (Assertions within FIFO RTL - as shown above):**  Assertions like `fifo_not_overflowing` are placed directly inside the `fifo` module RTL.
    *   **Integrating Assertions into Testbenches (Environment):**
        - **Assertions in UVM Monitors and Scoreboards:** Assertions can also be integrated into UVM testbench components, particularly monitors and scoreboards.
        - **Environment-Level Verification:** Testbench assertions provide *environment-level verification*. They check properties related to the interaction between the DUT and the testbench environment, or properties that are best checked at the transaction level after monitoring.
        - **Example (Assertion in UVM Monitor - Checking Transaction Properties):**
            ```SV
            class fifo_monitor extends uvm_monitor;
                // ... monitor code ...
                property valid_data_range;
                    @(posedge vif.clk)
                    fifo_transaction.data inside {[0:255]}; // Check if data is within valid range
                endproperty : valid_data_range

                assertion data_range_check;
                    property (valid_data_range);
                endassertion : data_range_check

                task run_phase(uvm_phase phase);
                    forever begin
                        transaction = collect_transaction();
                        `uvm_info("MON", $sformatf("Monitored transaction data: %0d", transaction.data), UVM_MEDIUM)
                    end
                endtask
            endclass
            ```
    *   **Assertion Coverage:**
        - **Measuring Assertion Effectiveness:** Assertion coverage measures how often assertions are *attempted* and how often they *pass*. It helps assess the effectiveness of the assertion set and identify gaps in assertion coverage.
        - **Assertion Coverage Metrics:**
            - **Assertion Attempt Count:** Number of times an assertion was evaluated during simulation.
            - **Assertion Success Count:** Number of times an assertion passed (condition was true).
            - **Assertion Failure Count:** Number of times an assertion failed (condition was false).
            - **Coverage Percentage:** (Assertion Success Count / Assertion Attempt Count) * 100%.  Ideally, assertions should be attempted many times and should mostly pass under normal operation. Failures indicate bugs. Low attempt counts might indicate that the assertion is not being exercised effectively.
        - **Assertion Coverage Reports:**  Verification tools generate assertion coverage reports that provide these metrics for each assertion in the design and testbench.
        - **Improving Assertion Coverage:**  Analyze assertion coverage reports to identify assertions with low attempt counts or unexpected failure patterns. Refine test cases or constraints to ensure assertions are adequately exercised and that all relevant design properties are being checked.

*   **Assertion Coverage: Measuring Assertion Effectiveness and Identifying Gaps:**
    *   **Assertion Coverage Goals:**  Similar to functional coverage goals, you should define assertion coverage goals for your verification project. Aim for high assertion attempt counts for critical assertions and a low number of unexpected assertion failures.
    *   **Analyzing Assertion Coverage Reports (Review):**
        - **Identify Low Attempt Counts:**  Focus on assertions with low attempt counts. This indicates that the test cases are not adequately exercising the scenarios covered by these assertions.
        - **Investigate Unexpected Failures:** Analyze assertion failures to understand the root cause of the design violations. Debug the design and fix bugs.
        - **Check Coverage Percentage:**  Monitor the assertion coverage percentage. While 100% coverage might not always be achievable or necessary, aim for high coverage for critical assertions.
    *   **Techniques to Improve Assertion Coverage:**
        - **Refine Test Cases:**  Develop new test cases or modify existing ones to specifically target assertions with low attempt counts. Create test scenarios that exercise the conditions checked by these assertions.
        - **Adjust Constraints:**  If using constrained-random verification, refine constraints to generate stimulus that is more likely to trigger assertions with low attempt counts.
        - **Review Assertion Placement:**  Ensure assertions are placed in appropriate locations in the RTL and testbench to effectively monitor the intended design properties.  Consider adding assertions to cover different aspects of the design or interface.
        - **Disable or Exclude Irrelevant Assertions (with Justification):** In some cases, certain assertions might be checking properties that are not relevant to the current verification goals or are intentionally not exercised in certain test scenarios.  You can disable or exclude these assertions from coverage analysis (but always with careful justification and documentation).
    *   **Assertion Coverage as a Verification Metric:** Assertion coverage, combined with code coverage and functional coverage, provides a more comprehensive picture of verification completeness. High assertion coverage, with a low number of failures, increases confidence in the design's correctness.

*   **Introduction to Formal Verification with Assertions (Optional): Using Assertions for Formal Property Checking:**
    *   **Formal Verification (Brief Overview):** Formal verification is a technique that uses mathematical methods to *prove* the correctness of a design with respect to its specification. Unlike simulation, formal verification aims to exhaustively analyze all possible behaviors of the design without running simulations.
    *   **Formal Property Checking:** A major application of formal verification is *property checking*.  Formal property checking uses assertions (properties) written in languages like SVA to formally verify if a design satisfies its intended properties.
    *   **Formal Verification Tools:**  Formal verification tools (property checkers, model checkers) take the design RTL and assertions as input and mathematically analyze whether the assertions hold true for *all* possible input stimuli and design states.
    *   **Benefits of Formal Verification with Assertions:**
        - **Exhaustive Verification:** Formal verification can provide exhaustive proof of correctness for specific properties, going beyond the coverage limitations of simulation.
        - **Early Bug Detection (Formal Proof):**  Formal verification can uncover subtle bugs that might be missed by simulation, and it provides a formal proof (or disproof) of property satisfaction.
        - **Complementary to Simulation:** Formal verification and simulation are complementary. Simulation is good for exploring complex scenarios and finding bugs in general functionality. Formal verification is powerful for proving specific properties and finding corner case bugs related to those properties.
    *   **Using SVA for Formal Verification:**  Assertions written in SVA for simulation can often be directly reused or adapted for formal verification tools.  This makes ABV a valuable stepping stone towards formal verification.
    *   **Limitations of Formal Verification:** Formal verification can be computationally intensive and may not scale well to very large and complex designs or for verifying all properties of a design. It is often used selectively to verify critical properties of key design blocks or interfaces.
    *   **Assertion-Based Formal Verification Workflow (Simplified):**
        1.  **Write SVA Assertions:** Develop SVA assertions to specify the properties you want to formally verify.
        2.  **Run Formal Verification Tool:** Use a formal verification tool (property checker) and provide the RTL design and SVA assertions as input.
        3.  **Analyze Formal Verification Results:** The formal tool will attempt to prove or disprove each assertion.
            - **Proof:** If an assertion is proven, it means the property holds true for all possible scenarios.
            - **Disproof (Counterexample):** If an assertion is disproven, the tool will generate a counterexample (a sequence of inputs and design states) that violates the assertion, indicating a bug.
            - **Inconclusive Result:** In some cases, formal tools may not be able to definitively prove or disprove an assertion (due to complexity or limitations of the tool).

## Learning Resources

*   **SystemVerilog LRM sections on Assertions:**
    *   **Search Query:** `SystemVerilog LRM assertions`.
    *   **IEEE 1800 Standard (Again):** Refer to the SystemVerilog LRM for the definitive language specification for SVA syntax, semantics, and operators.
    *   **Focus on Assertions Chapters:** Look for chapters specifically dedicated to immediate and concurrent assertions, property specification language, assertion directives, and assertion coverage.

*   **"SystemVerilog Assertions Handbook" by Ben Cohen et al.:**
    *   **Book Link:** [SystemVerilog Assertions Handbook: Cohen, Ben, Finkelshtein, Yatin, Beer, Eran, Gery, Cindy: 9789400700353: Amazon.com: Books](https://link.springer.com/book/10.1007/978-94-007-0035-3)
    *   **Comprehensive SVA Guide:** This book is a comprehensive and widely respected handbook on SystemVerilog Assertions. It provides in-depth explanations, numerous examples, and best practices for writing effective assertions.
    *   **Chapters on SVA Syntax, Semantics, and Applications:**  Focus on chapters covering immediate and concurrent assertions, property specification language, sequence operators, temporal operators, assertion methodology, and assertion coverage.
    *   **Accessibility:** Check library access.

*   **Online tutorials and examples of SVA:**
    *   **Search Query:** `SystemVerilog assertions tutorial`, `assertion based verification ABV examples`, `SVA examples`, `concurrent assertions SystemVerilog tutorial`, `immediate assertions SystemVerilog examples`.
    *   **Verification Academy, EDA Vendor Websites, Online Forums (Again):**  Search for SVA tutorials and examples on Verification Academy, EDA vendor websites (Cadence, Mentor, Synopsys), and verification forums. Many online resources provide practical examples and step-by-step guides to learning SVA.

## Exercises

*   **Write SVA assertions to formally specify the behavior of the FIFO design (e.g., FIFO full/empty conditions, data ordering):**
    *   **Identify FIFO Properties to Assert:**  Think about the key properties of your FIFO design that need to be formally specified and verified using assertions. Examples:
        - **FIFO Full Condition:**  When FIFO is full, writes should be blocked.
        - **FIFO Empty Condition:** When FIFO is empty, reads should be blocked.
        - **Data Ordering:**  Data should be read out in the same order it was written (FIFO property).
        - **No Overflow/Underflow (Already considered in examples):**
        - **Valid Data Range (If applicable):**
    *   **Write Concurrent Assertions (SVA):**  Write concurrent SVA assertions to formally express these FIFO properties. Use sequence and temporal operators as needed. Examples:
        - Assertion for FIFO full condition (as shown in example above).
        - Assertion for FIFO empty condition (similar to full, but for reads).
        - Assertion for data ordering (more complex, might require sequences to track write and read operations and data values).
    *   **Embed Assertions in FIFO RTL:**  Embed these SVA assertions directly into your FIFO RTL design module.

*   **Integrate assertions into the UVM testbench to monitor design properties during simulation:**
    *   **Choose Assertions for Testbench Integration:** Select some of the SVA assertions you wrote for the FIFO RTL (or create new ones) to integrate into your UVM testbench. Good candidates are assertions that check higher-level transaction properties or interface behavior.
    *   **Place Assertions in UVM Monitor or Scoreboard:**  Integrate these assertions into your `fifo_monitor` or `fifo_scoreboard` components. Monitors are often a good place for interface protocol assertions, while scoreboards can be used for checking transaction-level properties.
    *   **Run UVM Simulations with Assertions:**  Run your UVM testbench simulations with the integrated assertions enabled.

*   **Analyze assertion failures and debug potential design violations:**
    *   **Intentionally Introduce Bugs (for Exercise):**  To practice debugging with assertions, intentionally introduce some bugs into your FIFO RTL design. Examples:
        - Incorrect FIFO full/empty logic.
        - Data corruption during FIFO operations.
        - Protocol violations in FIFO interface signals.
    *   **Run Simulations and Observe Assertion Failures:** Run UVM simulations with the buggy FIFO design and the assertions enabled. Observe the assertion failures that are triggered.
    *   **Analyze Assertion Failure Reports and Waveforms:**  Examine the assertion failure reports generated by your simulator. Analyze waveforms around the time of assertion failures to understand the sequence of events leading to the failure and identify the root cause of the bug in your RTL design.
    *   **Debug and Fix Bugs:**  Use the information from assertion failures to debug your RTL code and fix the intentionally introduced bugs.
    *   **Re-run Simulations and Verify Fix:**  After fixing the bugs, re-run simulations to ensure that the assertions now pass and that the design behaves as expected.

*   **Explore assertion coverage reports and improve assertion coverage:**
    *   **Enable Assertion Coverage Collection:**  Enable assertion coverage collection in your simulation tool.
    *   **Generate Assertion Coverage Reports:** Run simulations and generate assertion coverage reports.
    *   **Analyze Assertion Coverage Reports (Review):** Examine the assertion coverage reports to:
        - Check assertion attempt counts and coverage percentages for your assertions.
        - Identify assertions with low attempt counts or unexpected failure patterns.
    *   **Refine Test Cases or Constraints (if using CRV):**  Based on coverage analysis, refine your test cases or constraints in your UVM testbench to improve assertion coverage. Target assertions with low attempt counts by creating scenarios that exercise the conditions they are checking.
    *   **Re-run Simulations and Re-analyze Coverage:** Re-run simulations with the refined testbench and generate new assertion coverage reports. Check if assertion coverage has improved.

##### Copyright (c) 2026 ChipVerge

