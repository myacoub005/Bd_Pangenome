#!/bin/bash
#SBATCH -p short -N 1 -n 16 --mem 16gb --out logs/cdhit.log

# we need to define representatives for the TE counts ##

module load cd-hit

OUTDIR=TE_cdhit
mkdir -p $OUTDIR
INDIR=libraries

cat $INDIR/* > $OUTDIR/All_TE_families.fasta

cd-hit -i $OUTDIR/All_TE_families.fasta -o $OUTDIR/All_TEs.90.hits.fasta -c 0.90 -n 5 -M 16000 -d 0 -T 8
