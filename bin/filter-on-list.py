#!/usr/bin/env python3
"""
filter-on-list.py COL rows.tsv filter.list -x

Filter rows in a TSV file (tab-separted values) with a value in column COL
that matches a term in the filter list (a plain-text, newline separated file).

COL     column number in rows.tsv to filter
-x      remove matching lines (instead of selecting them)
"""
import sys

__author__ = "Florian Leitner <florian.leitner@gmail.com>"  # no rights reserved


if not 3 < len(sys.argv) < 6 or "-h" in sys.argv or "--help" in sys.argv:
    print(__doc__, file=sys.stderr)
    sys.exit(1)

col = int(sys.argv[1]) - 1
filter_list = {i.strip() for i in open(sys.argv[3])}

if len(sys.argv) == 4:
    cond = lambda i: i[col] in filter_list
else:
    cond = lambda i: i[col] not in filter_list


def row_gen(stream):
    for row in stream:
        yield row.strip().split('\t')


with open(sys.argv[2]) as stream:
    for i in filter(cond, row_gen(stream)):
        print('\t'.join(i))
