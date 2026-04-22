# Synthesis in Vivado

In this chapter, we will cover the steps to synthesize an RTL design using the Vivado GUI. Synthesis is the process of converting your RTL code into a gate-level netlist that can be implemented on an FPGA.

## Setting Up the Synthesis

1. Open your project in Vivado.
2. In the Flow Navigator, click on "Run Synthesis" under the "Synthesis" section.
3. Vivado will start the synthesis process, converting your RTL code into a gate-level netlist.

## Analyzing Synthesis Results

1. Once the synthesis is complete, Vivado will display the Synthesis Completed dialog.
2. Click "Open Synthesized Design" to view the synthesized netlist.
3. Use the various analysis tools available in Vivado to inspect the synthesized design, such as the Schematic Viewer and the Timing Summary.

## Synthesis Settings

1. In the Flow Navigator, click on "Settings" under the "Project Manager" section.
2. Navigate to the "Synthesis" settings to configure various synthesis options, such as optimization goals and constraints.
3. Adjust the settings as needed to meet your design requirements.

## Common Synthesis Options

Here are some common options you might use during synthesis:

- **-flatten_hierarchy**: Controls the flattening of the design hierarchy.
- **-opt_mode**: Specifies the optimization mode (e.g., `Area`, `Performance`).
- **-retiming**: Enables or disables retiming optimization.

Example:
```tcl
synth_design -top top_module -flatten_hierarchy full -opt_mode Performance -retiming
```

By following these steps, you can synthesize your RTL design using Vivado and analyze the results to ensure your design meets the required specifications.

##### Copyright (c) 2026 ChipVerge

