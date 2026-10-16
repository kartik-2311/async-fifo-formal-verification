#!/usr/bin/env python3
"""Decode a Yosys witness trace (.yw) JSON and print signal values per step."""
import json
import sys

def main():
    path = sys.argv[1]
    with open(path) as f:
        trace = json.load(f)
    signals = trace["signals"]
    steps = trace["steps"]

    # Compute bit layout: signals are packed in order, LSB-first per signal.
    layout = []
    pos = 0
    for sig in signals:
        w = sig["width"]
        layout.append((sig["path"], w, pos, sig.get("init_only", False)))
        pos += w
    total = pos

    for si, step in enumerate(steps):
        bits = step["bits"]
        # bits string: each char is a bit, LSB-first overall? Yosys packs MSB first
        # within the step string actually. Let's just index left-to-right.
        print(f"\n=== Step {si} ===")
        for (path, w, off, init_only) in layout:
            if init_only and si > 0:
                continue
            if off + w > len(bits):
                val = "?" * w
            else:
                val = bits[off:off+w]
            name = ".".join(path)
            # Try to interpret as integer if no '?'
            if '?' not in val:
                try:
                    ival = int(val[::-1], 2)  # LSB first? try both
                    print(f"  {name:40s} = {val} (int={ival})")
                except:
                    print(f"  {name:40s} = {val}")
            else:
                print(f"  {name:40s} = {val}")

if __name__ == "__main__":
    main()
