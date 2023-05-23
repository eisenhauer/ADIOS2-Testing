#!/bin/bash

LOG=evaluation.txt
rm -rf $LOG
for f in n[0-9]*/*/restart_dir/*.bp; do
    echo -n "$f " >> $LOG
    for m in open write close endstep ; do
        echo  -n "$m " >> $LOG
        #PTN="s/.*\"${name}\":{\"mus\"://"
        #echo "Eval '$f' '$m' '$PTN'"
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
        #cat $f/profiling.json | sed -e $PTN -e 's/,.*//' | sort -n  | tail -10 >> $LOG
        echo -n "$VALUE " >> $LOG
    done
    echo "" >> $LOG
done
