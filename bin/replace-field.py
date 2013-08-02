#!/usr/bin/env python

"replace-field.py input.tsv val2alt_val.tsv {col=1st}"

__author__ = "Florian Leitner <florian.leitner@gmail.com>" # no rights reserved
__version__ = "1.0"

import sys

if not len(sys.argv) > 2 or "-h" in sys.argv or "--help" in sys.argv:
    print >> sys.stderr, __doc__
    sys.exit(1)

val2alt = dict(i.strip().split('\t') for i in open(sys.argv[2]))
col = 0 if len(sys.argv) == 3 else int(sys.argv[3]) - 1

def printer(items):
    items[col] = val2alt[items[col]]
    print '\t'.join(items)

for line in open(sys.argv[1]):
    printer(line.strip().split('\t'))
