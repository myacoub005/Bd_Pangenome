#!/bin/bash -l
#SBATCH -p short -N 1 -n 16 --mem 16gb --out logs/SamToBam.%a.log

## convert our sam alignments to bam for downstream analysis ##

CPU=$SLURM_CPUS_ON_NODE

if [ ! $CPUS ]; then
    CPU=1
fi

N=${SLURM_ARRAY_TASK_ID}

if [ ! $N ]; then
    N=$1
    if [ ! $N ]; then
        echo "need to provide a number by --array or cmdline"
        exit
    fi
fi

module load samtools

OUTDIR=hisat/JEL423_ref

mkdir -p $OUTDIR

IFS=,
tail -n +2 strains.updated.tsv | sed -n ${N}p | while read SAMPLE REP FQ1 FQ2
do

OUTNAME=$SAMPLE.$REP
samtools view -bS $OUTDIR/GCA_000149865.1.$OUTNAME.sam > $OUTDIR/GCA_000149865.1.$OUTNAME.bam

done
