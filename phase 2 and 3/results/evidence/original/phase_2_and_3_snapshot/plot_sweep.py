#!/usr/bin/env python3
"""Plot proof runtime vs FIFO depth from sweep_results.csv.

Usage: python3 plot_sweep.py [sweep_results.csv] [out.png]
Needs matplotlib; if it is missing, a markdown table is printed instead.
Runs that did not PASS are drawn as red crosses so a timeout or failure
is never mistaken for a fast proof.
"""
import csv
import sys
from collections import defaultdict

src = sys.argv[1] if len(sys.argv) > 1 else "sweep_results.csv"
dst = sys.argv[2] if len(sys.argv) > 2 else "runtime_vs_depth.png"

rows = []
with open(src, newline="") as f:
    lines = [ln for ln in f if not ln.startswith("#")]
for r in csv.DictReader(lines):
    r["entries"] = int(r["entries"])
    r["seconds"] = float(r["seconds"])
    rows.append(r)

# Markdown table, always printed (paste into the paper / README)
print("| entries | sby file | task | status | seconds |")
print("|---|---|---|---|---|")
for r in sorted(rows, key=lambda r: (r["sby_file"], r["task"], r["entries"])):
    print(f"| {r['entries']} | {r['sby_file']} | {r['task']} | {r['status']} | {r['seconds']:.0f} |")

try:
    import matplotlib
    matplotlib.use("Agg")
    import matplotlib.pyplot as plt
except ImportError:
    print("\nmatplotlib not installed; skipping the figure.")
    sys.exit(0)

series = defaultdict(list)
for r in rows:
    series[(r["sby_file"], r["task"])].append(r)

fig, ax = plt.subplots(figsize=(8, 5))
for (sby, task), pts in sorted(series.items()):
    pts.sort(key=lambda r: r["entries"])
    name = f"{sby.replace('.sby', '')}: {task}"
    ok = [p for p in pts if p["status"] == "PASS"]
    ax.plot([p["entries"] for p in ok], [max(p["seconds"], 0.5) for p in ok],
            marker="o", label=name)
    bad = [p for p in pts if p["status"] != "PASS"]
    if bad:
        ax.scatter([p["entries"] for p in bad], [max(p["seconds"], 0.5) for p in bad],
                   marker="x", color="red", zorder=5)

ax.set_xscale("log", base=2)
ax.set_yscale("log")
ax.set_xlabel("FIFO depth (entries)")
ax.set_ylabel("wall time (s, log scale)")
ax.set_title("Proof runtime vs FIFO depth (red x = not PASS)")
ax.grid(True, which="both", alpha=0.3)
ax.legend(fontsize=8)
fig.tight_layout()
fig.savefig(dst, dpi=150)
print(f"\nSaved {dst}")
