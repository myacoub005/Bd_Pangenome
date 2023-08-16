#!/bin/bash
#SBATCH -p batch --time 2-0:00:00 --ntasks 8 --nodes 1 --mem 12G 
#SBATCH --out logs/hmmsearch.%a.log

module load hmmer/3


for file in *.hmm; do dir=$(echo $file | cut -d. -f1); mkdir -p $dir; mv $file $dir; done


for i in */*.hmm; do

cat pep_Bd_LR/* > allseqs.aa
esl-sfetch --index allseqs.aa
hmmsearch --domtbl ${i}.domtbl -E 1e-5 ${i} allseqs.aa > ${i}.hmmsearch
done
