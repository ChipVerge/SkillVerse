# Command-Line Simulation

In this chapter, we will explore how to perform RTL simulation using Vivado's command-line tools: `xvlog`, `xelab`, and `xsim`. These tools provide a powerful way to automate and script your simulation workflows.

## Overview of Command-Line Tools

- **xvlog**: Compiles Verilog and SystemVerilog source files.
- **xelab**: Elaborates the design and generates a simulation snapshot.
- **xsim**: Runs the simulation using the generated snapshot.

## Setting Up the Environment

Before running the command-line tools, ensure that the Vivado environment is set up correctly. This can be done by sourcing the Vivado settings script:

```bash
source /opt/Xilinx/Vivado/<version>/settings64.sh
```

## Compiling the RTL Sources

Use `xvlog` to compile your Verilog or SystemVerilog source files. For example:

```bash
xvlog -sv my_design.sv my_testbench.sv
```

This command compiles `my_design.sv` and `my_testbench.sv` files.

## Elaborating the Design

After compiling the sources, use `xelab` to elaborate the design and create a simulation snapshot. For example:

```bash
xelab -debug typical my_testbench -s my_sim_snapshot
```

This command elaborates the `my_testbench` module and creates a simulation snapshot named `my_sim_snapshot`.

## Running the Simulation

Finally, use `xsim` to run the simulation with the generated snapshot. For example:

```bash
xsim my_sim_snapshot -gui
```

This command runs the simulation and opens the GUI for waveform analysis.

## Common Options for Command-Line Tools

Here are some common options for `xvlog`, `xelab`, and `xsim` that you might find useful:

### xvlog Options

- **-sv**: Specifies that the input files are SystemVerilog files.
- **-d <macro>**: Defines a macro for conditional compilation.
- **-i <include_dir>**: Specifies the directory to search for include files.

Example:
```bash
xvlog -sv -d SIMULATION -i ./include my_design.sv
```

### xelab Options

- **-debug <level>**: Specifies the debug level (e.g., `typical`, `full`) for the simulation.
- **-s <snapshot>**: Names the simulation snapshot.

Example:
```bash
xelab -debug typical my_testbench -s my_sim_snapshot
```

### xsim Options

- **-gui**: Launches the simulation in the GUI mode.
- **-R**: Runs the simulation without entering the interactive mode.

Example:
```bash
xsim my_sim_snapshot -R -gui
```

By using these options, you can customize and control the behavior of the Vivado command-line tools to better suit your simulation needs.

## Automating the Workflow with a Script

You can automate the entire simulation workflow by creating a shell script. Here is an example script:

```bash
#!/bin/bash

# Source the Vivado settings
source /opt/Xilinx/Vivado/<version>/settings64.sh

# Compile the RTL sources
xvlog -sv my_design.sv my_testbench.sv

# Elaborate the design
xelab -debug typical my_testbench -s my_sim_snapshot

# Run the simulation
xsim my_sim_snapshot -gui
```

Save this script as `run_simulation.sh`, make it executable, and run it:

```bash
chmod +x run_simulation.sh
./run_simulation.sh
```

By following these steps, you can perform RTL simulation using Vivado's command-line tools, allowing for greater flexibility and automation in your design verification process.

##### Copyright (c) 2026 ChipVerge

