#!/usr/bin/bash
#SBATCH -p short -N 1 -n 16 --mem 16gb -J intergenic --out logs/bedtools_complement.%a.log

module load bedtools

if [[ -z ${SLURM_CPUS_ON_NODE} ]]; then
    CPUS=1
else
    CPUS=${SLURM_CPUS_ON_NODE}
fi

N=${SLURM_ARRAY_TASK_ID}

if [ ! $N ]; then
    N=$1
    if [ ! $N ]; then
        echo "need to provide a number by --array or cmdline"
        exit
    fi
fi

IFS=,
tail -n +2 samples_NP.tsv | sed -n ${N}p | while read SAMPLE FQ
do

INDIR=genome
OUTDIR=Intergenic

mkdir -p $OUTDIR

sort -k1,1 $INDIR/$SAMPLE.chroms.bed > $INDIR/$SAMPLE.chroms.sorted.bed
sort -k1,1 -k2,2n $SAMPLE.genes.bed > $SAMPLE.genes.sorted.bed

bedtools complement -i $SAMPLE.genes.sorted.bed -g $INDIR/$SAMPLE.chroms.sorted.bed > $OUTDIR/$SAMPLE.intergenic.out

awk 'BEGIN { OFS = "\t" } { $4 = $3 - $2 } 1' $OUTDIR/$SAMPLE.intergenic.out > $OUTDIR/$SAMPLE.intergenic_Lengths.out

done
