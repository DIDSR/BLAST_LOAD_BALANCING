#!/bin/bash

# updated 7/21/2021

# input file: fasta format, delimiter '>'
# retrieve the first M records from 2.5 GB database, N records from query, put BLAST results in filenameMxN
# usage: extract_blast2.sh <M> <N> <filename>

# BASE_DIR=/scratch/trinity.cheng/blast_surface

BASE_DIR=/scratch/mikem/UserSupport/trinity.cheng/blast_surface

TIME_SUMMARY_DIR=${BASE_DIR}/time_summary				# new query result dir
# TIME_SUMMARY_DIR=${BASE_DIR}/time_summary_old_query			# old query result dir

mkdir -p ${BASE_DIR}/sge_results
mkdir -p ${TIME_SUMMARY_DIR}

QUERY_FILE=${BASE_DIR}/orig_query_split/SRR5713923				# new query file
# QUERY_FILE=${BASE_DIR}/orig_old_query_split/orig_query			# old query file


BASE_DB_DIR=/projects/mikem/UserSupport/ncbi/nt_2020
DB_NAME=nt
DB_FILE=${BASE_DB_DIR}/nt

# BASE_DB_DIR=/scratch/trinity.cheng/blast_surface/orig_db_split
# DB_NAME=orig_db
# DB_FILE=${BASE_DB_DIR}/${DB_NAME}

BLAST=/projects/mikem/applications/centos7/blast2.12.0_fda/ncbi-blast-2.12.0+-src/c++/ReleaseMT/bin/blastn
MAKEBLASTDB=/projects/mikem/applications/centos7/blast2.12.0_fda/ncbi-blast-2.12.0+-src/c++/ReleaseMT/bin/makeblastdb


echo $QUERY_FILE
echo $DB_FILE

NREC_DB=$1
echo $NREC_DB
# location of extracted db
SPLIT_DB=${BASE_DB_DIR}/orig_db_split/"${DB_NAME}""${NREC_DB}"
echo $SPLIT_DB

NREC_QUERY=$2
echo $NREC_QUERY
# location of extracted query
SPLIT_QUERY=${BASE_DIR}/orig_query_split/orig_query"$NREC_QUERY"		# new query split
# SPLIT_QUERY=${BASE_DIR}/orig_old_query_split/orig_query"$NREC_QUERY"		# old query split
echo $SPLIT_QUERY

DESC=$3

SLOTS=$4

# If query does not already exist, extract fragments and create split query.
if [ ! -f $SPLIT_QUERY ];
then
	awk -v N=$NREC_QUERY 'BEGIN {N_start=1; RS=">"}; {if (NR>N_start && NR<=N_start+N) {print ">" $0}}' $QUERY_FILE > $SPLIT_QUERY
fi

# If database does not already exist, extract fragments and create split database. Then, run makeblastdb to index. 
if [ ! -f $SPLIT_DB ];
then
	awk -v N=$NREC_DB 'BEGIN {N_start=1; RS=">"}; {if (NR>N_start && NR<=N_start+N) {print ">" $0}}' $DB_FILE > $SPLIT_DB
	$MAKEBLASTDB -in $SPLIT_DB -dbtype nucl
fi

BASE_OUT=/scratch/mikem/UserSupport/trinity.cheng/blast_surface 
# run BLAST and time, put results in sge_reuslts/"$DESC"_"$NREC_DB"X"$NREC_QUERY"
# output the time in seconds into time_summary.txt file

if [ $SLOTS == 1 ]
then
   NUM_THREADS=""
else
   NUM_THREADS="-num_threads $SLOTS"
fi

echo "CMD: time $BLAST $NUM_THREADS -dbseqnum $NREC_DB -query $SPLIT_QUERY -db $SPLIT_DB"
TIMEFORMAT="%E %U %S";
(time $BLAST $NUM_THREADS -dbseqnum $NREC_DB -query $SPLIT_QUERY -db $SPLIT_DB) &> ${BASE_OUT}/sge_results/"$DESC"_"$NREC_DB"x"$NREC_QUERY"
sleep 1
TIME=$(tail -n 1 ${BASE_OUT}/sge_results/"$DESC"_"$NREC_DB"x"$NREC_QUERY")

# output line: "M N time" for every M and N configuration into time_summary file.
## echo "$NREC_DB" "$NREC_QUERY" $TIME >> ${BASE_OUT}/time_summary/new_times_for_modeling/time_summary_"$DESC".txt
echo "$NREC_DB" "$NREC_QUERY" $TIME >> ${TIME_SUMMARY_DIR}/time_summary_"$DESC"_"$SLOTS"cpus.txt


# QUERY_FILE=${BASE_DIR}/orig_query_split/orig_query
# DB_FILE=${BASE_DIR}/orig_db_split/orig_db
# DB_NAME=SRR5713923
# DB_FILE=${BASE_DIR}/orig_db_split/${DB_NAME}
