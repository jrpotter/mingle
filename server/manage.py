#!/usr/bin/env python
import os
import sys

# Load environment variables
try:
    with open('.env') as f:
        for line in f:
            stmt = line.split('=', 1)
            os.environ.setdefault(stmt[0], stmt[1].rstrip())
except IOError:
    pass

# Run Command
if __name__ == "__main__":
    os.environ.setdefault("DJANGO_SETTINGS_MODULE", "conf.settings")
    from django.core.management import execute_from_command_line
    execute_from_command_line(sys.argv)
