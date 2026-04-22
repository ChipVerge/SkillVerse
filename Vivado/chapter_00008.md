# Debugging in Vivado

In this chapter, we will cover the steps to debug your design using the Vivado GUI. Debugging helps you identify and fix issues in your design.

## Setting Up Debug Probes

1. Open your project in Vivado.
2. In the Flow Navigator, click on "Set Up Debug" under the "Program and Debug" section.
3. Select the signals you want to monitor and add them as debug probes.
4. Click "OK" to insert the debug cores into your design.

## Running the Debug

1. In the Flow Navigator, click on "Run Implementation" to re-implement the design with the debug probes.
2. Once implementation is complete, generate the bitstream and program the FPGA as described in the previous chapter.
3. In the Flow Navigator, click on "Open Hardware Manager" and connect to your FPGA board.
4. Click "Run Trigger" to start capturing data from the debug probes.

## Analyzing Debug Results

1. Use the waveform viewer in the Hardware Manager to analyze the captured data.
2. Check the signal values and timing to identify any issues in your design.
3. If you find any issues, go back to your RTL code, make the necessary changes, and re-run the implementation and debugging process.

By following these steps, you can debug your design using Vivado and ensure it functions correctly on the FPGA.

##### Copyright (c) 2026 ChipVerge

