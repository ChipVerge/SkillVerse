# Memory Design

This chapter introduces the fundamental concepts of memory design in digital systems, focusing on different types of memories, their organization, interfaces, and implementation in RTL. Understanding memory is essential for designing systems that store and retrieve data, which is a core requirement for most digital hardware.

* **Types of Memories: SRAM, DRAM, ROM:**

    * **SRAM (Static Random-Access Memory):**
        * **Operation:**  Data is stored using flip-flops. Static means data is retained as long as power is supplied, without needing periodic refresh.
        * **Speed:**  Fast access times, suitable for cache memories and applications requiring high-speed data access.
        * **Complexity & Density:**  More complex cell structure (typically 4-6 transistors per bit), leading to lower density compared to DRAM.
        * **Power Consumption:** Generally higher power consumption than DRAM for the same density, but lower active power per access.
        * **Cost:** More expensive per bit than DRAM.
        * **Use Cases:** Cache memories in CPUs, on-chip memory in ASICs and FPGAs, small buffers, register files.
    * **DRAM (Dynamic Random-Access Memory):**
        * **Operation:** Data is stored as a charge in a capacitor. Dynamic means the charge leaks over time, requiring periodic refresh cycles to maintain data.
        * **Speed:** Slower access times compared to SRAM, but significantly faster than non-volatile memory.
        * **Complexity & Density:** Simpler cell structure (typically 1 transistor and 1 capacitor per bit), resulting in higher density.
        * **Power Consumption:** Lower standby power consumption than SRAM, but refresh cycles consume power.
        * **Cost:** Less expensive per bit than SRAM.
        * **Use Cases:** Main system memory in computers, large memory arrays in graphics cards and other applications requiring high density and lower cost per bit. Different DRAM types include DDR4, DDR5, LPDDR (Low Power DDR).
    * **ROM (Read-Only Memory):**
        * **Operation:** Data is permanently or semi-permanently stored during manufacturing or programming. Data is non-volatile (retained without power).
        * **Write Capability:** Primarily read-only. Some types (like EEPROM, Flash) can be electrically erased and reprogrammed, but write operations are typically slower and have limited endurance.
        * **Types of ROM:**
            * **Mask ROM:** Data programmed during manufacturing, cannot be changed after.
            * **PROM (Programmable ROM):** Programmable once by the user using special equipment.
            * **EPROM (Erasable PROM):** Erasable using UV light, reprogrammable.
            * **EEPROM (Electrically Erasable PROM) & Flash Memory:** Electrically erasable and reprogrammable, byte-erasable (EEPROM) or block-erasable (Flash). Flash memory is widely used for non-volatile storage (SSDs, USB drives).
        * **Use Cases:** Storing boot code, firmware, lookup tables, configuration data, character sets.

* **Memory Organization and Addressing:**

    * **Memory Array:** Memories are organized as arrays of storage locations. Each location has a unique address.
    * **Address Space:** The total range of addresses that can be accessed in a memory is its address space. For example, a memory with an address width of N bits has an address space of 2<sup>N</sup> locations.
    * **Word Size (Data Width):** The number of bits that can be read or written to a memory location in a single access. Common word sizes are 8-bit (byte), 16-bit (half-word), 32-bit (word), 64-bit (double-word).
    * **Memory Capacity:** The total amount of data a memory can store, calculated as (Number of locations) x (Word size).  Often expressed in bytes, kilobytes (KB), megabytes (MB), gigabytes (GB), terabytes (TB).
    * **Addressing Modes:**
        * **Linear Addressing:** Addresses are sequential and directly map to memory locations (e.g., addresses 0, 1, 2, 3...).
        * **Row and Column Addressing (in DRAM):** DRAMs use a matrix organization with rows and columns to reduce the number of address pins. Row Address Strobe (RAS) and Column Address Strobe (CAS) signals are used to latch row and column addresses separately during access.
    * **Memory Banks:** Large memories are often divided into banks to allow for parallel access and increase bandwidth.

* **Memory Interfaces and Protocols:**

    * **Basic Memory Interface Signals:**
        * **Address Lines (ADDR):**  Input signals to select the memory location to be accessed. The number of address lines determines the address space.
        * **Data Lines (DATA):** Bidirectional signals for transferring data to and from the memory. The number of data lines is the word size.
        * **Control Signals:**
            * **Chip Select (CS or CE):**  Enables the memory chip. Only when CS is active, the memory responds to other control signals.
            * **Read Enable (RE or OE - Output Enable):**  When active, enables read operation. Memory outputs data onto the data lines.
            * **Write Enable (WE):** When active, enables write operation. Data from the data lines is written into the selected memory location.
            * **Clock (CLK):** For synchronous memories (like SRAM in FPGAs), a clock signal synchronizes memory operations.
            * **Byte Enables (BE):** In byte-addressable memories, byte enable signals allow writing to individual bytes within a word.
    * **Memory Protocols/Timing:**
        * **Synchronous vs. Asynchronous Interfaces:**
            * **Synchronous:** Memory operations are synchronized to a clock signal. Easier to interface with synchronous digital systems and allows for higher speed. SRAM in FPGAs is typically synchronous.
            * **Asynchronous:** Memory operations are not directly clocked. Timing is controlled by control signal transitions. DRAM interfaces can be asynchronous or synchronous (SDRAM, DDR SDRAM).
        * **Read Cycle:** Sequence of signals and timing for reading data from memory. Involves setting address, asserting CS and RE, and waiting for data to become valid on the data lines.
        * **Write Cycle:** Sequence of signals and timing for writing data to memory. Involves setting address, data on data lines, asserting CS and WE, and holding signals stable for specified durations.
        * **Timing Parameters:**  Datasheets specify timing parameters like access time, cycle time, setup time, hold time for address, data, and control signals. Understanding these is crucial for proper memory interface design.

* **Instantiating and Using Memory Blocks in FPGAs/ASICs:**

    * **Embedded Memory Blocks in FPGAs (Block RAM - BRAM):**
        * FPGAs contain dedicated on-chip memory blocks (BRAMs) that are optimized for performance and efficiency.
        * Instantiation: FPGA vendors provide primitives or macros for instantiating BRAMs in HDL code.
        * Configuration Options: BRAMs are highly configurable in terms of:
            * Data width and depth (aspect ratio).
            * Number of ports (single-port, dual-port, true dual-port).
            * Read/write modes (read-first, write-first, no-change).
            * Initialization values.
        * Vendor Documentation is Key: Refer to FPGA vendor documentation (Xilinx Block RAM User Guide, Intel Memory IP User Guide) for specific instantiation templates, parameters, and usage guidelines.
    * **ASIC Memory Instances (Memory Compilers):**
        * ASIC design often uses memory compilers to generate optimized memory instances tailored to specific technology libraries and requirements.
        * Memory Compiler Tools: Tools from Synopsys, Cadence, and other EDA vendors are used to generate memory instances.
        * Configuration: Memory compilers allow specifying memory size, word size, number of ports, speed, power, and other parameters.
        * Integration: Generated memory instances are integrated into the ASIC design netlist.

* **Practical RTL Considerations for Memories:**

    * **Inference vs. Instantiation:** Small memories can often be inferred from synthesizable array-based RTL, while larger or feature-rich memories are commonly instantiated with vendor IP or technology macros.
    * **Read-During-Write Behavior Matters:** Always define what should happen when the same location is read and written in the same cycle. Technologies differ in whether they behave as read-first, write-first, or no-change.
    * **Synchronous Reads are Common in FPGAs:** Many FPGA block memories are synchronous, so read data often appears one clock later rather than changing immediately with the address.
    * **Avoid Internal Tri-States:** Inside an FPGA or ASIC, it is usually better to hold the previous value, drive a defined value, or provide a separate valid signal instead of modeling an internal high-impedance output.
    * **Initialization and Reset Need Care:** Large memories are usually not reset entry-by-entry in RTL. Prefer initialization files, power-up contents, or software-driven initialization when practical.

* **Memory Controllers (Basic Concepts):**

    * **Purpose of Memory Controllers:** To manage the interface between a processor or other master device and memory devices (especially DRAM).
    * **Complexity of DRAM Controllers:** DRAM interfaces are complex due to refresh requirements, timing protocols, and different DRAM standards (DDRx). Dedicated memory controllers are usually needed.
    * **Basic Memory Controller Functions:**
        * Address Mapping and Decoding: Translating logical addresses from the processor to physical memory addresses.
        * Command Generation: Generating control signals (RAS, CAS, WE, RE, etc.) according to the memory protocol.
        * Refresh Management (for DRAM): Generating refresh cycles to maintain data in DRAM.
        * Timing Control:  Ensuring proper timing for memory accesses to meet datasheet specifications.
        * Arbitration (if multiple masters): Handling memory access requests from multiple masters.
        * Error Correction (optional): Implementing ECC (Error Correction Code) for data integrity.
    * **RTL Implementation of Simple Memory Controllers (Conceptual):** For simple SRAM or ROM, a memory controller might be very basic, primarily handling address decoding and control signal generation. For DRAM, controllers are significantly more complex and often use pre-designed IP cores.

* **FIFO (First-In, First-Out) Design:**

    * **FIFO Functionality:** A buffer that stores data in a first-in, first-out order. Data is written at one end (write side) and read from the other end (read side).
    * **Applications:** Data buffering between modules operating at different rates, asynchronous interfaces, data streaming, communication channels.
    * **FIFO Components:**
        * Memory Array:  Storage for data (often implemented using SRAM or registers).
        * Write Pointer: Tracks the location to write the next data element.
        * Read Pointer: Tracks the location to read the next data element.
        * Control Logic: Manages read and write operations, handles full and empty conditions, and pointer updates.
        * Status Flags:  `full` flag (indicates FIFO is full, cannot write more data), `empty` flag (indicates FIFO is empty, cannot read data).
    * **FIFO Implementation in RTL:**
        * Memory array can be implemented using registers (for small FIFOs) or instantiated BRAMs (for larger FIFOs).
        * Pointers are typically implemented as counters.
        * Control logic is implemented using combinational and sequential logic to manage pointers, flags, and read/write operations.
        * Consider synchronous FIFO (both read and write clocks are the same or derived from the same source) or asynchronous FIFO (read and write clocks are independent - requires clock domain crossing handling for pointers and flags).
    * **FIFO Depth:** The number of data elements the FIFO can store. Depth is chosen based on buffering requirements and potential data rate mismatches.

## Learning Resources

* **Memory vendor datasheets (e.g., Micron, Samsung) for understanding memory types and interfaces:**

    * **Website Navigation:** Go to the websites of memory vendors like Micron ([Micron Technology, Inc. - Memory and Storage Solutions](https://www.micron.com/)) and Samsung ([Samsung Semiconductor Global Website](https://www.samsung.com/semiconductor/dram/)). Navigate to their DRAM, SRAM, and ROM product sections.
    * **Search for Datasheets:** Look for specific memory part numbers (e.g., "MT40A1G8," "K6R4008V2D") or memory types (e.g., "DDR4 SDRAM datasheet," "SRAM datasheet"). Download datasheets in PDF format.
    * **Datasheet Sections to Focus On:**
        * **Features:**  Highlight the key characteristics of the memory type (speed, density, power, interface).
        * **Block Diagram:** Understand the internal organization of the memory.
        * **Pin Description:** Identify address pins, data pins, control signals (CS, WE, RE, clocks), and power/ground pins.
        * **Functional Description:**  Read about read and write operation cycles, refresh cycles (for DRAM), and control signal behavior.
        * **Timing Diagrams and AC Characteristics:**  Crucially important for interface design. Understand timing parameters like access time, cycle time, setup time, hold time, and clock-to-Q delays.
        * **DC Characteristics and Power Consumption:**  Understand voltage levels, current requirements, and power dissipation.

* **FPGA vendor documentation on embedded memory blocks (Block RAM - BRAM):**

    * **Search Query Suggestion:** Search for "Xilinx Block RAM," "Xilinx Memory Resources," "Intel on-chip memory," "Intel FPGA memory blocks," "Vivado Block Memory Generator," "Quartus Memory IP."
    * **Vendor Documentation Websites:**  Go to the documentation sections of Xilinx ([Xilinx - Adaptable. Intelligent.](https://www.xilinx.com/)) and Intel FPGA ([Intel FPGA Programmable Solutions](https://www.intel.com/content/www/us/en/products/programmable.html)).
    * **User Guides and Application Notes:** Look for user guides, application notes, and IP core documentation related to Block RAM or on-chip memory for your target FPGA family.
    * **Key Information to Find:**
        * **BRAM Architecture:** Understand the structure of the BRAM blocks in the FPGA architecture.
        * **Configuration Options:**  Learn about configurable parameters like data width, depth, port configurations (single, dual, true dual-port), read/write modes, initialization options.
        * **Instantiation Templates:**  Find SystemVerilog or VHDL instantiation templates for BRAM primitives or macros.
        * **Timing and Performance:** Understand the performance characteristics of BRAMs, such as access time and clock frequency limitations.
        * **IP Core Generators:**  Explore IP core generators (like Xilinx Memory IP Generator or Intel Platform Designer) that simplify BRAM instantiation and configuration through a GUI.

* **Online tutorials and articles on memory design in RTL:**

    * **Search Query Suggestion:** Search for "RTL memory design tutorial," "SystemVerilog SRAM design," "FPGA memory controller RTL," "FIFO design SystemVerilog," "asynchronous FIFO implementation."
    * **Focus on RTL Examples:** Look for tutorials and articles that provide SystemVerilog code examples for:
        * Simple SRAM models in RTL.
        * Instantiating FPGA BRAMs.
        * FIFO implementations (synchronous and asynchronous).
        * Basic memory controller logic (for SRAM or simple memory).
    * **Understand Design Trade-offs:**  Pay attention to discussions about design choices, such as synchronous vs. asynchronous reset for memory, single-port vs. dual-port memory, FIFO depth considerations, and performance vs. area trade-offs in memory design.

## Exercises

* **Design a simple single-port SRAM using SystemVerilog:**

    * **Functionality:** Implement a single-port synchronous SRAM with basic read and write operations.
    * **Interface:** Define ports for:
        * Clock (`clk`)
        * Address input (`addr`)
        * Data input (`data_in`)
        * Data output (`data_out`)
        * Write enable (`we`)
        * Chip select (`cs`)
    * **Internal Memory Array:**  Use a SystemVerilog array (e.g., `logic [DATA_WIDTH-1:0] memory [0:DEPTH-1];`) to model the SRAM storage.
    * **Read and Write Logic:**
        * Use an `always_ff @(posedge clk)` block for synchronous memory operations.
        * Inside the `always_ff` block, implement read and write logic based on `we` and `cs` signals.
        * For write operation (`we && cs` active), write `data_in` to `memory[addr]`.
        * For read operation (`!we && cs` active), output `memory[addr]` to `data_out` (register the output for synchronous behavior).
        * When `cs` is inactive, `data_out` should typically retain its previous value or be qualified with a valid/enable signal rather than using an internal high-impedance value.
    * **Parameterization:** Make the SRAM module parameterized for `DATA_WIDTH` (word size) and `DEPTH` (number of locations).
    * **Testbench:** Write a testbench to verify read and write operations, address range, and chip select functionality.

* **Instantiate and use FPGA block RAM in a design:**

    * **Target FPGA Vendor:** Choose either Xilinx or Intel FPGA for this exercise (based on tool availability).
    * **Find BRAM Instantiation Template:**  Refer to the FPGA vendor documentation (using learning resources mentioned above) to find the correct SystemVerilog instantiation template for Block RAM (e.g., `RAMB18E1` or similar for Xilinx, or equivalent for Intel).
    * **Create a Wrapper Module:** Create a wrapper module that instantiates the BRAM primitive.
    * **Connect Interface Signals:** Connect the wrapper module's ports to the BRAM instance ports according to the vendor's template and your desired memory configuration (e.g., single-port, data width, address width).
    * **Simple Design Example:** Integrate the BRAM wrapper into a simple design, such as a data buffer or a lookup table.
    * **Synthesis and Implementation (Optional):** If FPGA tools are available, synthesize and implement the design targeting a specific FPGA device to see how the BRAM is utilized in hardware.
    * **Simulation:** Write a testbench to verify data read and write operations to the instantiated BRAM.

* **Design a FIFO module in RTL:**

    * **Functionality:** Implement a synchronous FIFO (both read and write operations clocked by the same clock) with `full` and `empty` flags.
    * **Interface:** Define ports for:
        * Clock (`clk`)
        * Reset (`rst`)
        * Write data input (`wr_data`)
        * Write enable (`wr_en`)
        * Read data output (`rd_data`)
        * Read enable (`rd_en`)
        * `full` flag output
        * `empty` flag output
    * **Internal Components:**
        * Memory array (use registers for a small FIFO or BRAM for a larger FIFO).
        * Write pointer (counter).
        * Read pointer (counter).
        * Control logic to manage pointers, `full`, and `empty` flags.
    * **FIFO Depth Parameter:** Make the FIFO depth parameterized.
    * **Full and Empty Flag Logic:** Implement logic to correctly set the `full` flag when the FIFO is full and the `empty` flag when it's empty. Handle wrap-around of pointers correctly.
    * **Testbench:** Write a testbench to verify FIFO operation:
        * Write data into the FIFO until it's full, verify `full` flag.
        * Read data from the FIFO until it's empty, verify `empty` flag.
        * Test concurrent read and write operations.
        * Test FIFO reset functionality.

##### Copyright (c) 2026 squared-studio

