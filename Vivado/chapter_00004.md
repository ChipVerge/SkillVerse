# Simulating a Simple RTL on Vivado GUI

In this chapter, we will walk through the steps to simulate a simple RTL (Register Transfer Level) design using the Vivado GUI. Simulation is a crucial step in verifying the functionality of your design before implementing it on hardware.

## Creating a New Project

1. Launch Vivado and select "Create New Project" from the Quick Start menu.
2. Enter a name for your project and choose a location to save it.
3. Select "RTL Project" and check the box for "Do not specify sources at this time."
4. Click "Next" and choose the appropriate part for your FPGA board.
5. Click "Finish" to create the project.

## Adding RTL Sources

1. In the Flow Navigator, click on "Add Sources."
2. Select "Add or Create Design Sources" and click "Next."
3. Click "Add Files" and browse to the location of your RTL files (e.g., Verilog or VHDL files).
4. Select the files and click "OK," then click "Finish" to add the sources to your project.

## Adding Simulation Sources

1. In the Flow Navigator, click on "Add Sources."
2. Select "Add or Create Simulation Sources" and click "Next."
3. Click "Add Files" and browse to the location of your testbench files.
4. Select the files and click "OK," then click "Finish" to add the simulation sources to your project.

## Running the Simulation

1. In the Flow Navigator, click on "Run Simulation" under the "Simulation" section.
2. Select "Run Behavioral Simulation" to start the simulation process.
3. The Vivado simulator will launch, and you will see the simulation waveform window.
4. Use the waveform window to analyze the signals and verify the functionality of your design.

## Analyzing Simulation Results

1. Use the zoom and pan tools in the waveform window to navigate through the simulation results.
2. Check the signal values at different time points to ensure that your design behaves as expected.
3. If you find any issues, go back to your RTL code, make the necessary changes, and re-run the simulation.

By following these steps, you can simulate and verify your RTL design using the Vivado GUI. Simulation helps you catch and fix issues early in the design process, ensuring a smoother implementation on hardware.

##### Copyright (c) 2026 ChipVerge

