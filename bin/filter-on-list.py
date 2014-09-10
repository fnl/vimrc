#!/usr/bin/env python
"""
filter-on-list.py COL rows.tsv filter.list -x

Filter rows in a TSV file (tab-separted values) with a value in column COL
that matches a term in the filter list (a plain-text, newline separated file).

COL     column number in rows.tsv to filter
-x      select matching lines (instead of filtering them)
"""
from __future__ import print_function

import sys

__author__ = "Florian Leitner <florian.leitner@gmail.com>"  # no rights reserved


if not 3 < len(sys.argv) < 6 or "-h" in sys.argv or "--help" in sys.argv:
    print >> sys.stderr, __doc__
    sys.exit(1)

col = int(sys.argv[1]) - 1
filter_list = [i.strip() for i in open(sys.argv[3])]

if len(sys.argv) == 4:
    cond = lambda i: i[col] in filter_list
else:
    cond = lambda i: i[col] not in filter_list

for i in filter(cond, [i.strip().split('\t') for i in open(sys.argv[2])]):
    print('\t'.join(i))
