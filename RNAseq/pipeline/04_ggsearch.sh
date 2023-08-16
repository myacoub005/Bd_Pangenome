#!/bin/bash -l
#SBATCH -p short -N 1 -n 16 --mem 16gb --out logs/ggsearch.log

module load fasta
INDIR=genome
#for t in genome/; do

ggsearch36 -d 1 -m 8c $INDIR/Single_copy_JEL423_Ids.fasta $INDIR/Single_copy_CLFT044_Ids.fasta -O Single_Copy_CLFT044.ggsearch.m8c.tab

#done
