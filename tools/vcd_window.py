#!/usr/bin/env python3
"""Print a window of signal values from a Yosys-SMTBMC VCD.
Usage: python3 -I vcd_window.py TRACE.vcd [N_BEFORE=10] [name1 name2 ...]
The window ends at the LAST timestamp in the file (BMC stops at the failing step).
Names match by suffix of the hierarchical signal name (case-sensitive)."""
import sys
DEFAULT = ["wr_clk","rd_clk","wr_rst_n","rd_rst_n","rd_rst_n_prev","rd_have_reset",
           "rd_empty","rd_empty_prev","rd_gray_ptr","wr_gray_sync","wr_gray_sync_prev","wr_gray_ptr"]
def parse(path):
    ids, scope, times, cur, state = {}, [], [], {}, {}
    t = None
    with open(path) as f:
        for line in f:
            s = line.strip()
            if not s: continue
            if s.startswith("$scope"):
                scope.append(s.split()[2])
            elif s.startswith("$upscope"):
                scope.pop()
            elif s.startswith("$var"):
                p = s.split(); ids.setdefault(p[3], []).append(".".join(scope+[p[4]]))
            elif s.startswith("#"):
                if t is not None: times.append((t, dict(cur)))
                t = int(s[1:])
            elif s[0] in "01xXzZ" and not s.startswith("$"):
                cur[s[1:]] = s[0]
            elif s[0] in "bB":
                v, i = s[1:].split(); cur[i] = v
    if t is not None: times.append((t, dict(cur)))
    return ids, times
def main():
    a = sys.argv[1:]
    if not a: sys.exit(__doc__)
    path, n = a[0], 10
    rest = a[1:]
    if rest and rest[0].isdigit(): n = int(rest[0]); rest = rest[1:]
    want = rest or DEFAULT
    ids, times = parse(path)
    cols = {}
    for w in want:
        hits = [(i, nm) for i, nms in ids.items() for nm in nms if nm == w or nm.endswith("."+w)]
        if hits: cols[w] = hits[0][0]
        else: print(f"NOT FOUND: {w}")
    print(f"{len(times)} timestamps; showing last {min(n+1,len(times))}")
    print("time".ljust(7) + "".join(w[:16].ljust(18) for w in cols))
    for t, st in times[-(n+1):]:
        print(str(t).ljust(7) + "".join(str(st.get(i, "?")).ljust(18) for i in cols.values()))
main()
