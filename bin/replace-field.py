#!/usr/bin/env python3

"replace-field.py 2_COLUMN_DICTIONARY [--col=1] [TSV]"

__author__ = "Florian Leitner <florian.leitner@gmail.com>" # no rights reserved
__version__ = "1.0"

import fileinput
import sys

if not len(sys.argv) > 1 or "-h" == sys.argv[0] or "--help" == sys.argv[0]:
    print(__doc__, file=sys.stderr)
    sys.exit(1)

# parse mappings
mappings = dict(m.strip().split('\t') for m in open(sys.argv[1]))
sys.argv.pop(1)

# determine column in input to be mapped
col = 1
if len(sys.argv) > 1 and sys.argv[1].startswith("--col"):
    if sys.argv[1] == "--col":
        if len(sys.argv) > 2:
            col = int(sys.argv[2])
            sys.argv.pop(1)
            sys.argv.pop(1)
    elif sys.argv[1].startswith("--col="):
        col = int(sys.argv[1][6:])
        sys.argv.pop(1)

col -= 1
errors = 0

def Process(items):
    try:
        items[col] = mappings[items[col]]
        print('\t'.join(items))
    except KeyError as e:
        print('not in dictionary:', e, file=sys.stderr)
        global errors
        errors += 1

for line in fileinput.input():
    Process(line.strip().split('\t'))

if errors > 0:
    print(errors, 'entries not found (skipped)', file=sys.stderr)

sys.exit(errors)
