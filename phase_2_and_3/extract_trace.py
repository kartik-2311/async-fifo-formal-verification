#!/usr/bin/env python3
"""Extract key signals per BMC step from a VCD trace."""
import re
import sys

def parse_vcd(path):
    signals = {}
    timesteps = []
    current_vals = {}
    current_time = None
    scope_stack = []
    with open(path) as f:
        for line in f:
            line = line.strip()
            if line.startswith('$scope'):
                scope_stack.append(line.split()[2])
            elif line.startswith('$upscope'):
                scope_stack.pop()
            elif line.startswith('$var'):
                parts = line.split()
                signals[parts[3]] = ('.'.join(scope_stack + [parts[4]]), int(parts[2]))
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
    s, ts = parse_vcd(path)
    n2id = {v[0]: k for k, v in s.items()}
    keys = [
        'async_fifo.wr_clk', 'async_fifo.wr_rst_n', 'async_fifo.wr_en',
        'async_fifo.u_wr_ptr.wr_gray_ptr', 'async_fifo.u_wr_ptr.wr_full',
        'async_fifo.u_formal.wr_have_reset', 'async_fifo.u_formal.wr_rst_n_prev',
        'async_fifo.u_formal.wr_gray_ptr_prev', 'async_fifo.u_formal.rd_gray_sync_prev',
        'async_fifo.u_sync_rd2wr.sync_ff',
        'async_fifo.rd_clk', 'async_fifo.rd_rst_n',
        'async_fifo.u_rd_ptr.rd_gray_ptr', 'async_fifo.u_rd_ptr.rd_empty',
        'async_fifo.u_formal.rd_have_reset', 'async_fifo.u_formal.rd_rst_n_prev',
        'async_fifo.u_formal.rd_gray_ptr_prev', 'async_fifo.u_formal.wr_gray_sync_prev',
        'async_fifo.u_sync_wr2rd.sync_ff',
    ]
    hdr = 'step ' + ' '.join(k.split('.')[-1][:12].ljust(12) for k in keys)
    print(hdr)
    for i, (t, v) in enumerate(ts):
        row = f'{i:4d} '
        for k in keys:
            sid = n2id.get(k)
            row += str(v.get(sid, '?')).rjust(12) + ' '
        print(row)

if __name__ == '__main__':
    main()
