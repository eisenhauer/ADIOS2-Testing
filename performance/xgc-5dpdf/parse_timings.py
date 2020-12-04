#!/usr/bin/env python3
import json
import re
import sys


def get_total_time(stdout_file):
    """
    Open stdout and read the line 'ADIOS IOTEST test time'
    to get the total runtime of the application
    """

    lines = []
    total_time = 'N/A'

    # Open stdout file and read all lines into a list
    try:
        with open(stdout_file) as f:
            lines = f.readlines()
    except IOError:
        print("ERROR: Could not find {}".format(stdout_file))
    except Exception as e:
        print("ERROR: {}".format(e))

    # Parse lines to get the total runtime
    for line in lines:
        if 'ADIOS IOTEST' in line:
            try:
                total_time = re.findall("\d+\.\d+", line)[0]
            except Exception as e:
                print("WARNING: Could not parse line about total time. Skipping..")
                print("ERROR: {}".format(e))

    # Return the total runtime obtained from the stdout
    return total_time


def parse_timings():
    d = {'writer_time_stdout': get_total_time('codar.workflow.stdout.writer'),
         'reader_time_stdout': get_total_time('codar.workflow.stdout.reader')}
    # Write data to 'cheetah_user_report.json'
    rv = 0
    try:
        with open("cheetah_user_report.json", "w") as f:
            json.dump(d, f)
    except IOError:
        print("ERROR: Could not write times from stdout to cheetah_user_report.json.")
        rv = 1
    except Exception as e:
        print("ERROR: {}".format(e))
        rv = 1

    return rv


if __name__ == "__main__":
    sys.exit(parse_timings())
