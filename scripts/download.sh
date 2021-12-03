#!/usr/bin/bash
#SBATCH -p short -N 1 -n 96 -C xeon --mem 64gb 
module unload miniconda2 miniconda3 perl
module load parallel
module load sratoolkit
module load parallel-fastq-dump
module load aspera
module load workspace/scratch
parallel -j 2 parallel-fastq-dump  --gzip --threads 48 --outdir . -T $SCRATCH --sra-id {} --split-3 --defline-seq '@$sn[_$rn]/$ri' ::: $(cat acc.txt)
