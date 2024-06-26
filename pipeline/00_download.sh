#!/usr/bin/bash
#SBATCH -p short --out logs/download.log

##Download genomic and pep sequences not in our dataset###
#curl -L -O https://ftp.ncbi.nlm.nih.gov/genomes/refseq/fungi/Batrachochytrium_dendrobatidis/latest_assembly_versions/GCF_000203795.1_v1.0/GCF_000203795.1_v1.0_genomic.gbff.gz

DB=genome
mkdir -p $DB
URL=https://ftp.ncbi.nlm.nih.gov/genomes/genbank/fungi/Batrachochytrium_dendrobatidis/latest_assembly_versions/GCA_000149865.1_BD_JEL423/
for n in GCA_000149865.1_BD_JEL423_genomic.gbff GCA_000149865.1_BD_JEL423_genomic.fna

do
    if [ ! -s $DB/$n ]; then # if the file doesn't exist download and uncompress
	curl -L $URL/$n.gz | pigz -dc > $DB/$n
    fi
done
