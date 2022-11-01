#!/bin/bash

# Specify DIR and OUTPUT in lines 5 and 6 below.
# Run as: 
# bash failed_rows.sh 

DIR=/scratch/mikem/UserSupport/trinity.cheng/blast_surface/time_summary
OUTPUT=failed_rows.txt
echo `date` > ${OUTPUT}
echo "Files on directory: $DIR" >> ${OUTPUT}

echo >> ${OUTPUT}
for file in ${DIR}/*; do
	RES=`awk ' NF==2 {print NR,$0} '  $file`
	if [ ! -z "$RES" ]
	then
	  	echo "Found defetive line(s) in ${file##*/}" >> ${OUTPUT}
	  	awk ' NF==2 {print NR,$0} '  $file >> ${OUTPUT}
		echo >> ${OUTPUT}
	fi	
done

echo "See ${OUTPUT} for results."
