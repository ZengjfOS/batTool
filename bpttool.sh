#!/bin/sh

BPTTOOL=tools/bpttool/bpttool

for pfile in ./partitions/*; do
    if test -f ${pfile}; then
        pfile_name=`basename ${pfile}`
    
        # echo ${pfile} ${pfile_name} ${pfile_name%.*}
        ${BPTTOOL} make_table --output_gpt output/${pfile_name%.*}.img --output_json output/${pfile_name%.*}.bpt --input ${pfile}
    fi
done
