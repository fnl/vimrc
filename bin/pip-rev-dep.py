#!/usr/bin/env python3
import pip
import sys

def rdeps(package_name):
    return [pkg.project_name
            for pkg in pip.get_installed_distributions()
            if package_name in [requirement.project_name
                                for requirement in pkg.requires()]]

for pckg in sys.argv[1:]:
    print(pckg)
    for dep in rdeps(pckg):
        print("<-", dep)
