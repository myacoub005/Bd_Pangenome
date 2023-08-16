#!/bin/bash
#SBATCH -p short -N 1 -n 16 --mem 16gb --out logs/repeat_masker.%a.log

module load RepeatMasker

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
OUTDIR=Consensus_Repeatmasker

mkdir -p $OUTDIR

RepeatMasker -lib consensus_library/TE_cleaned-families.fasta $INDIR/$SAMPLE.scaffolds.fa -no_is -gff -dir $OUTDIR/$SAMPLE
done
