#!/bin/bash
#SBATCH -p short --ntasks 8 --nodes 1 --mem 24G --out blast.log

#Identify the TE names from the rep base database

module load ncbi-blast

OUT=EDTA_RM_BLAST
INDIR=TE_cdhit
IN=$INDIR/All_TEs.90.hits.fasta

mkdir -p $OUT

#grep -A 1 "Unknown" $INDIR/All_TEs.90.hits.fasta.fa > $INDIR/Unknowns.fasta

for t in fngrep.fa;
do
makeblastdb -in ${t} -dbtype nucl -out $OUT/db
blastn -query $IN -db $OUT/db -perc_identity 70 -outfmt 6 -max_target_seqs 1 -max_hsps 1 -out $OUT/Repbase_Identified_EDTA_RM_IDs.tsv
done
