# Real Digital Boolean FIFO demonstration

Target: `xc7s50csga324-1` on the **Real Digital Boolean** board. The 100 MHz oscillator drives an MMCM with a 600 MHz VCO; buffered outputs run the FIFO write side at 75 MHz and read side at 100 MHz. These clocks share a source; this demonstration does not model independent physical oscillators.

The FIFO has sixteen eight-bit entries. The internal traffic generator/checker exercises stalls and wraps, compares returned sequence data, and watches for lack of read progress. Read data and expected data are registered before the local error comparison, giving one read-clock cycle of comparison latency.

| Board signal | Pin | Meaning |
|---|---|---|
| Clock oscillator | F14 | 100 MHz input |
| Button 0 | J2 | Reset/restart |
| LED0 | G1 | Sticky indication of at least 1,024 completed reads with full/empty activity |
| LED1 | G2 | Sticky mismatch or progress-watchdog failure; must remain off |
| LED2 | F1 | Clock heartbeat, about 1.34 seconds per full blink cycle |

PASS can remain lit after a later failure. Always treat LED1 as the failure indication, regardless of LED0. Button reset clears status and restarts the counters. Reset assertion combines the button and loss of MMCM lock, followed by two local release stages in each domain.

The pin assignments are from the [official Boolean constraints](https://www.realdigital.org/downloads/8d5c167add28c014173edcf51db78bb9.txt). These are not Arty S7 pin assignments.

## Run the portable controller simulation

From the repository root, with Icarus Verilog on PATH:

```bash
bash tools/test_sim.sh
```

It tests 75/100 MHz traffic, full/empty stalls, many wraps, reset/restart and deliberate data corruption. The test is simulation evidence, not a full parameterized formal theorem. `tb_boolean_fifo_board.sv` additionally tests the MMCM/board wrapper using Xilinx's `unisims_ver` primitive library; that library comes with Vivado and is not redistributed here.

## Build a fresh bitstream

With Vivado 2025.2 on PATH:

```text
vivado -mode batch -nojournal -source fpga/boolean/build.tcl
```

The script resolves all source paths from its own location and writes to ignored `results/boolean/`. It refuses to overwrite an existing build. It emits reports and a routed checkpoint, then checks timing, internal clock coverage and DRC before `write_bitstream`. No device or configuration flash is automatically programmed.

The recorded 30 October build had WNS +0.658 ns, WHS +0.044 ns and pulse-width slack +3.000 ns, with zero DRC violations and no unconstrained internal endpoints. Its `.bit` and `.dcp` are intentionally excluded from Git. No bitstream byte hash is promised for future builds: timestamps, paths or tool behavior may change the generated image.

Both Gray buses have bounded 10 ns first-stage datapath delay and skew constraints, using register objects with five-endpoint checks. Ordinary RAM/logic and subsequent synchronizer stages remain normally timed; there is no broad inter-clock false path. The documented build retains one CDC-6 Gray-bus warning and one LUTAR-1 reset aggregation warning. Review the CDC, skew, methodology and DRC reports together; timing success does not establish analog MTBF.

## Optional volatile programming

When the actual Boolean board is available, use Vivado Hardware Manager, Open Target / Auto Connect, select the XC7S50 and Program Device with `results/boolean/boolean_fifo_top.bit`. Observe heartbeat, PASS and absence of FAIL, then press button 0 to repeat. Physical board testing remains **NOT RUN** in the recorded evidence. Flash programming is a separate action.
