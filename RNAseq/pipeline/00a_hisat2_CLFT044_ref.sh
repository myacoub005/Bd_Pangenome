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
GENOME=Batrachochytrium_dendrobatidis_CLFT044.scaffolds.fa
OUTDIR=hisat/CLFT044_ref

mkdir -p $OUTDIR

IFS=,
tail -n +2 strains.updated.tsv | sed -n ${N}p | while read SAMPLE REP FQ1 FQ2
do

OUTNAME=$SAMPLE.$REP

hisat2-build $INDIR/$GENOME $OUTDIR/Bd_CLFT044

hisat2 -x $OUTDIR/Bd_CLFT044 -1 $FQ1 -2 $FQ2 -S $OUTDIR/Bd_CLFT044.$OUTNAME.sam

done
