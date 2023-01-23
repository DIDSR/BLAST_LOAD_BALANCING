#!/bin/bash

# 07/29/2022

# input file: m_vals.txt, n_vals.txt

BASE_DIR=/scratch/user1/UserSupport/user2/blast_surface

# QUERY_FILE=${BASE_DIR}/orig_query_split/SRR5713923			# new query
QUERY_FILE=${BASE_DIR}/orig_old_query_split/orig_query			# old query

BASE_DB_DIR=/projects/user1/UserSupport/ncbi/nt_2020
DB_NAME=nt
DB_FILE=${BASE_DB_DIR}/nt

MAKEBLASTDB=./makeblastdb

DBSEQUENCES=$(cat m_vals_4096.txt)
QUERYSEQUENCES=$(cat n_vals_4096.txt)

for dsequence in $DBSEQUENCES
do
	# location of extracted db
	SPLIT_DB=${BASE_DB_DIR}/orig_db_split/"${DB_NAME}""${dsequence}"
	echo $SPLIT_DB
	# If database does not already exist, extract fragments and create split database. Then, run makeblastdb to index. 
	if [ ! -f $SPLIT_DB ];
	then
		awk -v N=$dsequence 'BEGIN {N_start=1; RS=">"}; {if (NR>N_start && NR<=N_start+N) {print ">" $0}}' $DB_FILE > $SPLIT_DB
		$MAKEBLASTDB -in $SPLIT_DB -dbtype nucl
	fi
done

for qsequence in $QUERYSEQUENCES
do 
	# location of extracted query
	# SPLIT_QUERY=${BASE_DIR}/orig_query_split/orig_query"$qsequence"			# new query
	SPLIT_QUERY=${BASE_DIR}/orig_old_query_split/orig_query"$qsequence"			# old query
	echo $SPLIT_QUERY
	# If query does not already exist, extract fragments and create split query.
	if [ ! -f $SPLIT_QUERY ];
	then
		awk -v N=$qsequence 'BEGIN {N_start=1; RS=">"}; {if (NR>N_start && NR<=N_start+N) {print ">" $0}}' $QUERY_FILE > $SPLIT_QUERY
	fi
done
