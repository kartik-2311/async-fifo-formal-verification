#!/usr/bin/env python3
"""Make a COPY of a property file where every immediate assert is preceded by `cover (1'b1);`.
Running cover mode on the copy proves each assertion's enclosing path is reachable, so none
passes only because its guard can never be true. The original file is never modified.
usage: python3 make_vacuity_copy.py async_fifo_formal.sv  -> async_fifo_formal_vacuity.sv
       and writes <sby>_vacuity.sby if a matching sby is given as 2nd arg."""
import re, sys
src = sys.argv[1]; dst = src.replace(".sv", "_vacuity.sv")
lines = open(src).read().split("\n"); out = []; n = 0; wrapped = []
prev = ""; depth = 0; closing = False
for i, ln in enumerate(lines, 1):
    if re.match(r"^\s*assert\s*\(", ln) and not closing and depth == 0:
        indent = re.match(r"^(\s*)", ln).group(1)
        dangling = bool(re.search(r"(\)|\belse)\s*$", prev)) and not re.search(r"\bbegin\s*$", prev)
        if dangling:
            out.append(f"{indent}begin"); closing = True; wrapped.append(i)   # keep if/else semantics
        out.append(f"{indent}cover (1'b1); // vacuity: reachability of the assert below (line {i})"); n += 1
        depth = 0
    out.append(ln)
    if closing or (re.match(r"^\s*assert\s*\(", ln) or depth > 0):
        depth += ln.count("(") - ln.count(")")
        if depth <= 0 and ";" in ln:
            depth = 0
            if closing:
                out.append(re.match(r"^(\s*)", ln).group(1) + "end"); closing = False
    if ln.strip(): prev = ln
open(dst, "w").write("\n".join(out))
print(f"wrote {dst}: {n} covers inserted")
if wrapped: print("note: wrapped in begin/end to keep if/else meaning, at original lines", wrapped)
if len(sys.argv) > 2:
    sby = sys.argv[2]; s = open(sby).read().replace(src, dst)
    o = sby.replace(".sby", "_vacuity.sby"); open(o, "w").write(s); print("wrote", o)
