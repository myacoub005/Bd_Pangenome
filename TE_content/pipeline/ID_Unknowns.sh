#!/bin/bash
#SBATCH -p short -N 1 -n 16 --mem 16g --out logs/hmmsearch.%a.log

module load hmmer/3
module load muscle
module load mafft

INDIR=EDTA_RM_BLAST

#muscle -align $INDIR/Copia-Gypsy.aa.fasta -output $INDIR/Copia-Gypsy.aln

#mafft $INDIR/Copia-Gypsy.aa.fasta > $INDIR/Copia-Gypsy.aln

#hmmbuild $INDIR/Copia_Gypsy.hmm $INDIR/Copia-Gypsy.aln

for i in $INDIR/*.hmm; do

esl-sfetch --index $INDIR/TE_families.proteins.fasta
hmmsearch --domtbl ${i}.domtbl -E 1e-5 ${i} $INDIR/CLFT044_unknowns.proteins.fasta > ${i}.hmmsearch

grep -h -v '^#' ${i}.domtbl | awk '{print $1}' | sort | uniq | esl-sfetch -f $INDIR/CLFT044_unknowns.proteins.fasta - > ${i}.hits.aa.fa
done
