#!/bin/bash
# How to run:
# Specify DBFILE, QUERYFILE, num_threads and NUM_REPEAT below
# And run:
# bash batch_run_v2.sh 

LOG_DIR=log
mkdir -p ${LOG_DIR}

D=`date +"%FT%T"`
# OUT="batch_run_log_"${D//:}".log"
OUT="${LOG_DIR}/batch_run_log_"${D//:}".log"

DBFILE="m_vals_2048.txt"
QUERYFILE="n_vals_2048.txt"

LEN_DB=`cat $DBFILE | wc -l`
LEN_QR=`cat $QUERYFILE | wc -l`
TASKS=$((LEN_DB*LEN_QR))

num_threads=(1 2 4 8)
NUM_REPEAT=3

for thr in ${num_threads[@]}; do
    echo "" 2>&1 | tee >> ${OUT}
    echo "Submit jobs with threads: $thr" 2>&1 | tee >> ${OUT}
	MEM=$((22/$thr))
	for (( t=1; t<=${NUM_REPEAT}; t++ ))
	do 
		echo "" 2>&1 | tee >> ${OUT}
		echo "Threads: ${thr}, Test: $t" 2>&1 | tee >> ${OUT}
		
		CMD="qsub -t 1-"${TASKS}" -N "blast_array_${thr}_${t}" -l h_vmem=${MEM}G \
		-pe thread $thr -l dell01=true -l gpus=0 sge_extractblast_v3.sh \
		type1test"$t"_"$thr" $DBFILE $QUERYFILE"
		
		echo "$CMD" 2>&1 | tee >> ${OUT}
		$CMD
		sleep 1 

		CMD="qsub -t 1-"${TASKS}" -N "blast_array_"${thr}"_"${t}"" -l h_vmem=${MEM}G \
		-pe thread "${thr}" -q '*@@betsy_original' sge_extractblast_v3.sh \
		type2test"$t"_"$thr" $DBFILE $QUERYFILE"
		echo "$CMD" 2>&1 | tee >> ${OUT}
		qsub -t 1-"${TASKS}" -N "blast_array_"${thr}"_"${t}"" -l h_vmem=${MEM}G \
		-pe thread "${thr}" -q '*@@betsy_original' sge_extractblast_v3.sh \
		type2test"$t"_"$thr" $DBFILE $QUERYFILE 
		sleep 1 
		
		CMD="qsub -t 1-"${TASKS}" -N "blast_array_${thr}_${t}" -l h_vmem=${MEM}G \
		-pe thread $thr -l bigbox sge_extractblast_v3.sh \
		type3test"$t"_"$thr" $DBFILE $QUERYFILE"
		echo "$CMD" 2>&1 | tee >> ${OUT}
		$CMD 
		sleep 1 
		
		CMD="qsub -t 1-"${TASKS}" -N "blast_array_${thr}_${t}" -l h_vmem=${MEM}G \
		-pe thread $thr -l sm01 sge_extractblast_v3.sh \
		type4test"$t"_"$thr" $DBFILE $QUERYFILE"
		echo "$CMD" 2>&1 | tee >> ${OUT}
		$CMD 
		sleep 1 

		CMD="qsub -t 1-"${TASKS}" -N "blast_array_${thr}_${t}" -l h_vmem=${MEM}G \
		-pe thread $thr -l sm02 sge_extractblast_v3.sh \
		type5test"$t"_"$thr" $DBFILE $QUERYFILE"
		echo "$CMD" 2>&1 | tee >> ${OUT}
		$CMD 
		sleep 1 

		CMD="qsub -t 1-"${TASKS}" -N "blast_array_${thr}_${t}" -l h_vmem=${MEM}G \
		-pe thread $thr -l hpe01=true -l gpus=0 sge_extractblast_v3.sh \
		type6test"$t"_"$thr" $DBFILE $QUERYFILE"
		echo "$CMD" 2>&1 | tee >> ${OUT}
		$CMD 
		sleep 1 
	done
done
