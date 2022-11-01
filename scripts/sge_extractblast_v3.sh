#$ -P CDRHID0014
#$ -cwd 
#$ -l h_rt=48:00:00 
#						$ -l h_vmem=2.5G 
#$ -S /bin/sh 
#$ -j y 
#$ -o sge_results
#				$ -N blast_array
#			$ -t 1-90
#				$ -pe thread 8

# This script runs all MxN combinations from m_vals and n_vals in an array job
# usage: qsub -l <nodename> sge_extractblast_v3.sh <description>
# type 1 = -q '*@@betsy_original'
# type 2 = -l bigbox
# type 3 = -l sm01
# type 4 = -l sm02
# type 5 = -l hpe01=true -l gpus=0
# type 6 = -l dell01=true -l gpus=0

# DESC is a description of the current job/experiment
DESC=$1
DBFILE=$2
QUERYFILE=$3

# DBFILE=m_vals.txt
# QUERYFILE=n_vals.txt


# MxN array, M is row/database, N is column/query

DBNUM=$(cat $DBFILE | wc -l)
QUERYNUM=$(cat $QUERYFILE | wc -l)

ROW=$((((((SGE_TASK_ID-1))/$QUERYNUM))+1)) 
COL=$((((((SGE_TASK_ID-1))%$QUERYNUM))+1)) 

NREC_DB=$(head -n $ROW $DBFILE | tail -n 1)
NREC_QUERY=$(head -n $COL $QUERYFILE | tail -n 1)

# run extract_blast with $NREC_DB database fragments and $NREC_QUERY query fragments
./extract_blast2.sh $NREC_DB $NREC_QUERY $DESC $NSLOTS
