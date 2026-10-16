#!/usr/bin/env python3
"""VCD parser with scope tracking."""
import sys
import re

def parse_vcd(path):
    signals = {}      # id -> (hier_name, width)
    timesteps = []
    current_vals = {}
    current_time = None
    scope_stack = []
    in_dumpvars = False

    with open(path) as f:
        for line in f:
            line = line.strip()
            if line.startswith('$scope'):
                parts = line.split()
                scope_stack.append(parts[2])
            elif line.startswith('$upscope'):
                if scope_stack:
                    scope_stack.pop()
            elif line.startswith('$var'):
                parts = line.split()
                w = int(parts[2])
                sid = parts[3]
                name = parts[4]
                hier = '.'.join(scope_stack + [name])
                signals[sid] = (hier, w)
            elif line.startswith('$dumpvars'):
                in_dumpvars = True
            elif line.startswith('$end'):
                in_dumpvars = False
            elif line.startswith('#'):
                if current_time is not None:
                    timesteps.append((current_time, dict(current_vals)))
                current_time = int(line[1:])
            elif line.startswith('b'):
                m = re.match(r'b([01xz]+)\s+(\S+)', line)
                if m:
                    current_vals[m.group(2)] = m.group(1)
            elif line and line[0] in '01xz':
                current_vals[line[1:]] = line[0]
    if current_time is not None:
        timesteps.append((current_time, dict(current_vals)))
    return signals, timesteps

def main():
    path = sys.argv[1]
    signals, timesteps = parse_vcd(path)
    name_to_id = {v[0]: k for k, v in signals.items()}

    interesting = [
        'async_fifo.rd_clk', 'async_fifo.rd_en', 'async_fifo.rd_rst_n',
        'async_fifo.wr_clk', 'async_fifo.wr_en', 'async_fifo.wr_rst_n',
        'async_fifo.u_formal.wr_have_reset', 'async_fifo.u_formal.wr_rst_n_prev',
        'async_fifo.u_formal.wr_gray_ptr_prev', 'async_fifo.u_formal.rd_gray_sync_prev',
        'async_fifo.u_formal.rd_have_reset', 'async_fifo.u_formal.rd_rst_n_prev',
        'async_fifo.u_formal.rd_gray_ptr_prev', 'async_fifo.u_formal.wr_gray_sync_prev',
        'async_fifo.u_wr_ptr.wr_gray_ptr', 'async_fifo.u_wr_ptr.wr_full',
        'async_fifo.u_wr_ptr.wr_bin',
        'async_fifo.u_rd_ptr.rd_gray_ptr', 'async_fifo.u_rd_ptr.rd_empty',
        'async_fifo.u_rd_ptr.rd_bin',
        'async_fifo.u_sync_wr2rd.sync_ff', 'async_fifo.u_sync_wr2rd.meta_ff',
        'async_fifo.u_sync_rd2wr.sync_ff', 'async_fifo.u_sync_rd2wr.meta_ff',
    ]

    for t, vals in timesteps:
        print(f"\n=== Time {t} ===")
        for name in interesting:
            sid = name_to_id.get(name)
            if sid and sid in vals:
                val = vals[sid]
                try:
                    ival = int(val.replace('x', '0').replace('z', '0'), 2)
                    print(f"  {name:45s} = {val:>6s} ({ival})")
                except:
                    print(f"  {name:45s} = {val}")

if __name__ == "__main__":
    main()
