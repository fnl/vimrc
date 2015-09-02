#!/usr/bin/env python3

"%s [--rev[erse]] DICT [--col[umn]=1] < TSV > MAPPED"

__author__ = "Florian Leitner <florian.leitner@gmail.com>"  # no rights reserved
__version__ = "1.0"

import fileinput
import os
import sys

basename = os.path.basename(sys.argv.pop(0))

if not len(sys.argv) or "-h" == sys.argv[0] or "--help" == sys.argv[0]:
    print(__doc__ % basename, file=sys.stderr)
    sys.exit(1)

if len(sys.argv) and sys.argv[0] in ("--reverse", "--rev"):
    print('reversed dictionary', file=sys.stderr)
    order = reversed
    sys.argv.pop(0)
else:
    order = lambda x: x

mappings = dict(order(m.strip().split('\t')) for m in open(sys.argv.pop(0)))
col = 1

if len(sys.argv) and sys.argv[0].startswith("--col"):
    col = sys.argv.pop(0)

    if '=' in col and not sys.argv:
        col = int(col[col.find('=') + 1:])
    elif sys.argv:
        col = int(sys.argv.pop(0))
    else:
        print('unrecognized option', col, file=sys.stderr)

col -= 1
errors = 0
count = 0
print('mapping input...', file=sys.stderr)

for line in fileinput.input():
    count += 1
    items = line.strip().split('\t')

    if count % 100 == 0:
        print('.', end='', file=sys.stderr)

    try:
        items[col] = mappings[items[col]]
        print('\t'.join(items))
    except KeyError as e:
        print('not in dictionary:', e, file=sys.stderr)
        errors += 1

if errors:
    print(errors, 'entries not found (skipped)', file=sys.stderr)

sys.exit(errors)
