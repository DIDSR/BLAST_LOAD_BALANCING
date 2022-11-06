# README for BLAST Load Balancing
## Introduction

The Basic Local Alignment Search Tool (BLAST) is a suite of commonly used algorithms for identifying matches between biological sequences. The user supplies a database file and query file of sequences for BLAST to find identical sequences between the two. The typical millions of database and query sequences make BLAST computationally challenging but also well suited for parallelization on high-performance computing (HPC) clusters. The efficacy of parallelization depends on the data partitioning, where the optimal data partitioning relies on an accurate performance model. In previous studies, a BLAST job was sped up by 27 times by partitioning the database and query among thousands of processor nodes. However, the optimality of the partitioning method was not studied. Unlike BLAST performance models proposed in the literature that usually have problem size and hardware configuration as the only variables, the execution time of a BLAST job is a function of database size, query size, and hardware capability. In this work, the nucleotide BLAST application BLASTN was profiled using three methods: shell-level profiling with the Unix “time” command, code-level profiling with the built-in “profiler” module, and system-level profiling with the Unix “gprof” program. The runtimes were measured for six node types, using six different database files and 15 query files, on a heterogeneous HPC cluster with 500+ nodes. The empirical measurement data were fitted with quadratic functions to develop performance models that were used to guide the data parallelization for BLASTN jobs.

## Disclaimer

This software and documentation (the "Software") were developed at the Food and Drug Administration (FDA) by employees of the Federal Government in the course of their official duties. Pursuant to Title 17, Section 105 of the United States Code, this work is not subject to copyright protection and is in the public domain. Permission is hereby granted, free of charge, to any person obtaining a copy of the Software, to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, or sell copies of the Software or derivatives, and to permit persons to whom the Software is furnished to do so. FDA assumes no responsibility whatsoever for use by other parties of the Software, its source code, documentation or compiled executables, and makes no guarantees, expressed or implied, about its quality, reliability, or any other characteristic. Further, use of this code in no way implies endorsement by the FDA or confers any advantage in regulatory decisions. Although this software can be redistributed and/or modified freely, we ask that any derivative works bear some notice that they are derived from it, and any modified versions bear some notice that they have been modified.

## Code features

In this section we provide a brief description of the Unix scripts for truncating the input database and query into sub-databases and sub-queries which contain a different number of sequences.

### batch_run_v2.sh

### create_db_and_query.sh
### extract_blast2.sh
### failed_rows.sh
### sge_extractblast_v3.sh

## Code output

The output of these scripts is a .txt file which contains five columns: database number, query number, real time, user time, and sys time. This file can then be processed to generate the meshes and bar charts shown in our manuscript.

## References

  - [1]  T. Cheng, M. Mikailov, P. Chin, K. Cha, N. Petrick, Profiling the BLAST bioinformatics application for load balancing on high-performance computing clusters,  BMC bioinformatics (2022), accepted.

[![Github All Releases](https://img.shields.io/github/downloads/DIDSR/BLAST_LOAD_BALANCING/total)]()


