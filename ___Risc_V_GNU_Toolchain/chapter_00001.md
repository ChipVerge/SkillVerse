# RISC-V GNU Linker Script Syntax Guide

## Basic Structure & Syntax

* **Commands**: Linker scripts consist of a series of commands. Commands can be keywords (often followed by arguments) or symbol assignments.
* **Semicolons**: Commands are typically separated by semicolons (`;`), although they are often optional at the end of a line.
* **Whitespace**: Whitespace is generally ignored, except where it separates tokens.
* **Comments**: C-style comments (`/* ... */`) are used for adding explanations.
* **Expressions**: C-like expressions can be used for calculating addresses, sizes, and other values. These expressions use integer arithmetic.
* **File Names**: File or format names can be written directly. If they contain special characters (like commas), enclose them in double quotes (`"`).
* **Location Counter (`.`)**: A special variable, the **location counter**, represents the current output address. It can be read and assigned to, allowing you to control where sections are placed.

---

## Key Commands

### `ENTRY(symbol)`

This command sets the **entry point** of the program – the address of the first instruction to execute. `symbol` must be a defined symbol in one of the input object files.

```ld
ENTRY(_start)
```

### `MEMORY` 💾

The `MEMORY` command describes the **memory layout** of the target system. It defines named memory regions, specifying their attributes (like read `r`, write `w`, execute `x`), their starting address (`ORIGIN`), and their size (`LENGTH`).

```ld
MEMORY
{
  FLASH (rx) : ORIGIN = 0x08000000, LENGTH = 128K
  RAM   (rwx): ORIGIN = 0x20000000, LENGTH = 64K
}
```

This is particularly important in RISC-V bare-metal development where you need to map code and data to specific memory devices like flash and SRAM.

### `SECTIONS` 🗺️

This is the most crucial command. It defines how input sections (like `.text`, `.data`, `.bss` from your compiled object files) are **mapped into output sections** in the final executable and where these output sections are placed in memory.

```ld
SECTIONS
{
  /* The code section */
  .text :
  {
    KEEP(*(.vectors .vectors.*)) /* Keep the vector table first */
    *(.text .text.*)             /* All .text sections */
    *(.rodata .rodata.*)         /* All read-only data */
    _etext = .;                  /* Define a symbol at the end */
  } > FLASH                      /* Place this section in FLASH */

  /* The initialized data section */
  .data :
  {
    _sdata = .;                  /* Start of data */
    *(.data .data.*)             /* All .data sections */
    _edata = .;                  /* End of data */
  } > RAM AT> FLASH              /* Store in FLASH, load into RAM */

  /* The uninitialized data section (BSS) */
  .bss :
  {
    _sbss = .;                   /* Start of BSS */
    *(.bss .bss.*)               /* All .bss sections */
    *(COMMON)                    /* Common symbols */
    _ebss = .;                   /* End of BSS */
  } > RAM                      /* Place in RAM */

  /* Stack definition (example) */
  . = ALIGN(8);
  . = . + 4K;                   /* Reserve 4K for the stack */
  _stack_top = .;               /* Define stack top symbol */
}
```

---

## Inside the `SECTIONS` Block

* **Output Section Definition**: `output_section_name [address] [(type)] : [AT(lma)] { input_section_descriptions } [> region] [=fill_value]`
    * `output_section_name`: Name like `.text`, `.data`.
    * `address`: Optional VMA (Virtual Memory Address).
    * `AT(lma)`: Optional LMA (Load Memory Address). Useful for initializing data in RAM by storing it in ROM/FLASH.
    * `input_section_descriptions`: Specifies which input sections go here.
        * `*(.text)`: Includes the `.text` section from *all* input files.
        * `my_object.o(.data)`: Includes the `.data` section from `my_object.o`.
        * `KEEP(...)`: Prevents the linker from discarding these sections if they appear unused.
    * `> region`: Specifies the memory region (defined in `MEMORY`) where this section should be placed.
* **Symbol Assignments**: You can define symbols within the `SECTIONS` block (or outside). These symbols represent addresses and can be used by your C or assembly code.
    * `_my_symbol = . ;` (Assigns the current location counter value).
    * `_my_symbol = 0x1000;` (Assigns an absolute value).
    * `PROVIDE(_my_symbol = .);` (Defines the symbol only if it's not defined elsewhere).

---

## RISC-V Specific Considerations

While the syntax is standard GNU LD, for `riscv-unknown-elf-gcc`, especially in bare-metal contexts, you'll pay close attention to:

* **Memory Map (`MEMORY`)**: Accurately reflecting your specific hardware's memory addresses and sizes (Flash, SRAM, peripherals).
* **Startup Code (`ENTRY` & `.vectors`)**: Ensuring the entry point points to your startup code (`_start`) and that the interrupt/exception vector table is placed correctly (often at the beginning of executable memory).
* **Stack Pointer**: You often need to explicitly define a stack region and initialize the stack pointer (`sp`) in your startup code, using a symbol defined in the linker script (`_stack_top`).
* **ABI Compliance**: While not strictly a linker script *syntax* issue, the linker script helps ensure the final layout is compatible with the chosen RISC-V ABI (e.g., `ilp32`, `lp64`).
* **Linker Relaxation**: RISC-V linkers can perform "relaxations," optimizing certain instruction sequences. This doesn't usually change the script syntax but is a feature of the RISC-V linking process.

##### Copyright (c) 2026 ChipVerge

