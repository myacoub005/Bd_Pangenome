#!/bin/bash
#SBATCH -p intel -N 1 -n 16 --mem 16gb --out logs/trees.log 

module load muscle
module load iqtree

for t in */*.hits.aa.fa; do

if [ ! -s ${t}.fasaln ]; then
	muscle -align ${t} -output ${t}.fasaln
fi

iqtree2 -T AUTO -s ${t}.fasaln -alrt 1000 -m MFP

done
