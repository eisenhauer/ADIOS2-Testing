#!/bin/bash

EFILE1=xgc_frontier_evaluation_timer_list.txt
EFILE2=xgc_frontier_evaluation_timer_list_sorted.txt
EFILE3=xgc_frontier_evaluation_timer.txt

rm -f $EFILE1 $EFILE2 $EFILE3

for r in round? ; do
    for rn in $r/n* ; do
        for s in null shm ews ew ew-ar1 bp4; do
            f=$rn/$s.1/timing_all.txt_stats
            if [ -f "$f" ]; then
                echo -n "${f}" | sed -e "s/^round.\/n//"  -e "s/\.1\/timing.*stats/ /" >> $EFILE1
                #grep ADIOS_WRITE_RESTART $f | awk "BEGIN {sum=0}{sum=sum+\$7} END {print sum}"  
                grep RESTART_WRITE $f | awk "BEGIN {sum=0}{sum=sum+\$7} END {print sum}" >> $EFILE1 
                #| sed -e "s/^round.\/n//" -e "s/\.1\/timing.*\"//" | sort -n
                #echo ""
            fi
        done
    done
done

sort -n $EFILE1 > $EFILE2

for s in null shm ews ew  ew-ar1 bp4; do
    grep "${s} " $EFILE2  | awk 'BEGIN{m="";s=""} {if ($1==m) {s=s" "$2} else {print m,s; m=$1; s=$2}} END {print m, s}' >> $EFILE3
done
