#!/usr/bin/env python

try:
    with open('.sequence', 'r') as f:
        sequence = int(f.read())
except IOError:
    sequence = 0
with open('.sequence', 'w') as f:
    f.write("{sequence}\n".format(sequence=sequence+1))
print("52:54:00:13:37:{cur:02x}".format(cur=sequence+0x20))

