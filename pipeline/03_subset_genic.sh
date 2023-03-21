#!/usr/bin/bash
#SBATCH -p short -N 1 -n 16 --mem 16gb --out logs/get_intergenic.%a.log

module load samtools

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
NAME=$INDIR/$SAMPLE.scaffolds.fa
PREFIX=$(basename $NAME .scaffolds.fa)
GFF=GFF/$SAMPLE.gff3

awk '$3 == "gene"' $GFF| cut -f1,4,5 > $SAMPLE.genes.bed
done
