#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
# Copyright (C) 2019 RARE Technologies s.r.o.
# Authors: Radim Rehurek <radim@rare-technologies.com>
# MIT License

"""
Find private/shared memory of one or more processes, identified by their process ids (PIDs).

Works on both Python 2 and Python 3. Relies on information from /proc/PID and only works in Linux.

Example:
    python smaps.py 123 124 125
    python smaps.py `ps aux | grep python | awk '{ print $2 }'`

"""

import logging
import sys
import os

logger = logging.getLogger(__name__)


if __name__ == '__main__':
    logging.basicConfig(
        level=logging.INFO,
        format='%(asctime)s - %(levelname)s - %(filename)s:%(lineno)s - %(message)s'
    )
    logger.info("running %s", " ".join(sys.argv))
    program = sys.argv[0]

    total_virt, total_shared, total_private = 0, 0, 0
    for pid in sys.argv[1:]:
        logger.debug("reading proc stats for PID %s", pid)
        virt, shared, private = 0, 0, 0

        try:
            # Find total virtual memory size
            for line in open(os.path.join('/proc', pid, 'status')): # XXX: only works on Linux!
                if line.startswith('VmSize'):
                    var, value, unit = line.split()
                    assert unit == 'kB'
                    virt = int(value)

            # Add up individual shared memory segments
            for line in open(os.path.join('/proc', pid, 'smaps')): # XXX: only works on Linux!
                if line.startswith('Private_Dirty'):
                    var, value, unit = line.split()
                    assert unit == 'kB'
                    private += int(value)
                if line.startswith('Shared_Dirty'):
                    var, value, unit = line.split()
                    assert unit == 'kB'
                    shared += int(value)

            logger.info(
                "total for PID %s: virt %.2f MB, shared dirty %.2f MB, private dirty %.2f MB",
                pid, virt / 1024.0, shared / 1024.0, private / 1024.0,
            )
        except IOError:
             logger.info("failed to load PID %s, skipping", pid)
             continue

        # Update aggregate stats over all the PIDs
        total_virt += virt
        total_shared += shared
        total_private += private

    logger.info(
        "total for %i processes: virt %.2f MB, shared dirty %.2f MB, private dirty %.2f MB",
        len(sys.argv) - 1, total_virt / 1024.0, total_shared / 1024.0, total_private / 1024.0,
    )
    logger.info("finished running %s", program)
