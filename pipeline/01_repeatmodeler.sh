#!/bin/bash -l
#SBATCH -p batch -N 1 -n 48 --mem 96gb --out logs/repeatmodeler.%a..log

module load RepeatModeler

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
if [ ! -f $PREFIX.nin ]; then
	BuildDatabase -engine rmblast -name $PREFIX $NAME
fi

RepeatModeler -pa $CPUS -database $PREFIX -LTRStruct
done
