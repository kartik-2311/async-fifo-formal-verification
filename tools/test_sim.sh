#!/usr/bin/env bash
set -euo pipefail
ROOT=$(cd "$(dirname "$0")/.." && pwd)
mkdir -p "$ROOT/results"
RUN=$(mktemp -d "$ROOT/results/boolean-sim.XXXXXX")
iverilog -g2012 -s tb_fifo_smoke -o "$RUN/smoke.vvp" \
  "$ROOT/async_fifo.sv" "$ROOT/fpga/boolean/fifo_smoke.sv" \
  "$ROOT/fpga/boolean/tb_fifo_smoke.sv"
vvp "$RUN/smoke.vvp" | tee "$RUN/smoke.log"
