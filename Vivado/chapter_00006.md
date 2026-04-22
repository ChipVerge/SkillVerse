# Implementation in Vivado

In this chapter, we will cover the steps to implement an RTL design using the Vivado GUI. Implementation involves placing and routing the synthesized netlist onto the FPGA fabric.

## Setting Up the Implementation

1. Open your project in Vivado.
2. In the Flow Navigator, click on "Run Implementation" under the "Implementation" section.
3. Vivado will start the implementation process, which includes placement and routing of the design.

## Analyzing Implementation Results

1. Once the implementation is complete, Vivado will display the Implementation Completed dialog.
2. Click "Open Implemented Design" to view the implemented design.
3. Use the various analysis tools available in Vivado to inspect the implemented design, such as the Device Viewer and the Timing Summary.

## Implementation Settings

1. In the Flow Navigator, click on "Settings" under the "Project Manager" section.
2. Navigate to the "Implementation" settings to configure various implementation options, such as placement and routing strategies.
3. Adjust the settings as needed to meet your design requirements.

## Common Implementation Options

Here are some common options you might use during implementation:

- **-directive**: Specifies the implementation directive (e.g., `Performance_Explore`, `Area_Explore`).
- **-place_design**: Controls the placement of the design.
- **-route_design**: Controls the routing of the design.

Example:
```tcl
place_design -directive Performance_Explore
route_design -directive Performance_Explore
```

By following these steps, you can implement your RTL design using Vivado and analyze the results to ensure your design meets the required specifications.

##### Copyright (c) 2026 ChipVerge

