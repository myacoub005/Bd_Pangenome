#!/bin/bash
#SBATCH -p batch -N 1 -n 32 --mem 32gb --out logs/hisat2.%a.log

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

module load hisat2

INDIR=assemblies
GENOME=GCA_000149865.1
OUTDIR=hisat

mkdir -p $OUTDIR

IFS=,
tail -n +2 strains.updated.tsv | sed -n ${N}p | while read SAMPLE REP FQ1 FQ2
do

OUTNAME=$SAMPLE.$REP

hisat2-build $INDIR/GCA_000149865.1_BD_JEL423_genomic.fa $OUTDIR/GCA_000149865.1

hisat2 -x $OUTDIR/GCA_000149865.1 -1 $FQ1 -2 $FQ2 -S $OUTDIR/GCA_000149865.1.$OUTNAME.bam

done
