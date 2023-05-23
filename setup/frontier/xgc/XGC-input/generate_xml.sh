#!/bin/bash

ENGINEXML=${1:-engine_shm.xml}
INXML=${2:-adios2cfg_in.xml}
OUTXML=${3:-adios2cfg.xml}

ENGINETXT=`cat ${ENGINEXML}`

rm -f ${OUTXML}

IFS=''
while read -r LINE
do
    if [ "$LINE" == "#ENGINE#" ]; then
        echo "${ENGINETXT}" >> ${OUTXML}
    else
        echo "$LINE" >> ${OUTXML}
    fi
done <${INXML}

