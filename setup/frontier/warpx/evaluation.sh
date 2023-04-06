#!/bin/bash

LOG=evaluation.txt
rm -rf $LOG
for f in n*/*/diags/N1/openpmd.bp; do
    echo -n "Test $f: " >> $LOG
    for m in open write close endstep PP ; do
        echo  -n "$m " >> $LOG
        if [ -f $f/mmd.0 ]; then
            #BP5
            VALUE=`grep \"$m\" $f/profiling.json | sed -e "s/transport_1.*//" | sed -e "s/.*\"${m}\":{\"mus\"://" -e 's/,.*//' | sort -n  | tail -1`
        else
            #BP4
            VALUE=`grep \"$m\" $f/profiling.json | sed -e "s/transport_1.*//" | sed -e "s/.*\"${m}\":{\"mus\"://" -e 's/,.*//' | sort -n  | tail -1`
        fi
        if [ -z "$VALUE" ]; then
            VALUE="n/a"
        fi
        echo -n "$VALUE " >> $LOG
    done
    echo "" >> $LOG
done
