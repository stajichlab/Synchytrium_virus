#!/usr/bin/bash -l
#SBATCH -p short --out logs/hisat.index.log
module load hisat2

mkdir -p db
pushd db

# download two S_endo assemblies
wget https://ftp.ncbi.nlm.nih.gov/genomes/all/GCA/006/535/955/GCA_006535955.1_ASM653595v1/GCA_006535955.1_ASM653595v1_genomic.fna.gz
wget https://ftp.ncbi.nlm.nih.gov/genomes/all/GCA/006/536/045/GCA_006536045.1_ASM653604v1/GCA_006536045.1_ASM653604v1_genomic.fna.gz

gunzip GCA_006535955.1_ASM653595v1_genomic.fna.gz
gunzip GCA_006536045.1_ASM653604v1_genomic.fna.gz

ln -s GCA_006535955.1_ASM653595v1_genomic.fna S_endobioticum_MB42.fasta
ln -s GCA_006536045.1_ASM653604v1_genomic.fna S_endobioticum_LEV6574.fasta

hisat2-build S_endobioticum_LEV6574.fasta S_endobioticum_LEV6574
hisat2-build S_endobioticum_MB42.fasta S_endobioticum_MB42
