# Open Bus Interface (OBI)

## Description

The Open Bus Interface (OBI) is a lightweight bus protocol used to connect masters and slaves in embedded and SoC designs. It is designed to be easy to implement in RTL while still supporting practical features such as reads, writes, wait states, and byte enables.

At its core, OBI separates a transaction into two parts:

1. **Request acceptance** using `req` and `gnt`
2. **Transaction completion** using `rvalid` and, for reads, `rdata`

That split makes OBI simple to reason about:

- the master asks for a transfer,
- the slave accepts it when ready,
- the slave later returns the completion.

This chapter focuses on the common minimal OBI-style interface shown in the waveform below.

### Why OBI is useful

- **Simple handshake:** easy to implement and verify
- **Low overhead:** good fit for small and medium interconnects
- **Configurable widths:** address and data widths are implementation-defined
- **Byte enables:** supports partial-word writes
- **Latency tolerant:** the slave can delay either acceptance or completion

## Protocol Overview

An OBI transfer is considered **accepted** in the cycle where both `req` and `gnt` are high.

- `req` is driven by the master
- `gnt` is driven by the slave
- `rvalid` indicates that the slave is returning the response
- `rdata` is meaningful only for read responses

In this simplified interface, the protocol is typically used with **one outstanding transaction at a time**. That means the master waits for `rvalid` before starting the next transfer.

## Signals

### Clock and Reset

- **`clk`**: system clock; interface signals are sampled on the rising edge
- **`arst_n`**: asynchronous active-low reset

### Request Channel (Master to Slave)

- **`req`**: request valid from the master
- **`addr`**: transfer address
- **`we`**: write enable; `1` for write, `0` for read
- **`wdata`**: write data; valid for write transactions
- **`be`**: byte enable mask for partial writes

### Response / Handshake Channel (Slave to Master)

- **`gnt`**: grant; indicates the slave accepts the request in this cycle
- **`rvalid`**: response valid; indicates the transaction has completed
- **`rdata`**: read data; valid only when `rvalid = 1` for a read response

## Transfer Rules

The following rules are the most important ones to remember:

1. The master asserts `req` when it has a valid request.
2. While waiting for `gnt`, the master must keep request signals stable.
3. A request is accepted only in a cycle where `req && gnt` is true.
4. The response may come later, indicated by `rvalid`.
5. For writes, `rvalid` is a completion acknowledgement; `rdata` is ignored.
6. For reads, the master samples `rdata` when `rvalid` is asserted.

## Waveform

![Waveform](waveform.svg)

### How to read the waveform

- The master raises `req` together with address and control information.
- If the slave is not ready, `gnt` stays low and the request must remain unchanged.
- When `gnt` goes high, the request is accepted on that rising edge.
- Some cycles later, the slave asserts `rvalid` to finish the transfer.
- If the transfer was a read, `rdata` is valid in the `rvalid` cycle.

## Operations

### Reset

When `arst_n` is low, the interface returns to its idle state.

**Master side:**

- `req = 0`
- `addr`, `we`, `wdata`, and `be` are don't-care unless the design specifies otherwise

**Slave side:**

- `gnt = 0`
- `rvalid = 0`
- `rdata` is don't-care unless the design specifies otherwise

After reset is released, transfers can begin on a subsequent rising edge of `clk`.

### Read Operation

For a read transfer, the master:

1. Drives the target address on `addr`
2. Sets `we = 0`
3. Asserts `req = 1`
4. Keeps the request stable until the slave asserts `gnt`

**Acceptance phase:**

- The slave may immediately assert `gnt`, or it may insert wait states.
- The read request is accepted on the cycle where `req && gnt` is true.

**Completion phase:**

- At a later cycle, the slave asserts `rvalid = 1`.
- In that same cycle, `rdata` contains valid read data.
- The master samples `rdata` on the rising edge when `rvalid = 1`.

### Write Operation

For a write transfer, the master:

1. Drives the target address on `addr`
2. Sets `we = 1`
3. Drives write data on `wdata`
4. Drives the byte mask on `be`
5. Asserts `req = 1`
6. Keeps all request signals stable until `gnt`

**Acceptance phase:**

- The write is accepted when `req && gnt` is true.
- At that point, the slave has accepted the address, control, and write data.

**Completion phase:**

- The slave later asserts `rvalid = 1` to indicate completion.
- During a write response, `rdata` is not used and should be ignored.

## Byte Enable Examples

For a 32-bit data bus, `be` is typically 4 bits wide:

- `4'b1111` writes all 4 bytes
- `4'b0001` writes only byte 0
- `4'b0011` writes the lower halfword
- `4'b1100` writes the upper halfword

## Practical Notes

- OBI allows the request and response phases to be separated by any number of cycles.
- A slave can throttle requests by keeping `gnt` low.
- A slave can add response latency by delaying `rvalid`.
- In this simplified usage model, responses return in order because only one request is outstanding.

If you remember only one rule, remember this: **keep the request stable until grant, then wait for `rvalid` to know the transfer is finished.**

##### Copyright (c) 2026 squared-studio
