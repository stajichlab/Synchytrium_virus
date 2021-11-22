#!/usr/bin/bash -l
#SBATCH -p short -C xeon -N 1 -n 96 --mem 24gb --out logs/hisat-map.%a.log -a 1-2
module load hisat2
module load samtools
N=${SLURM_ARRAY_TASK_ID}

if [ ! $N ]; then
    N=$1
    if [ ! $N ]; then
        echo "need to provide a number by --array or cmdline"
        exit
    fi
fi

CPU=1
if [ ! -z $SLURM_CPUS_ON_NODE ]; then
    CPU=$SLURM_CPUS_ON_NODE
fi
INDIR=input
DBDIR=db
OUTPUT=search
mkdir -p $OUTPUT
SAMPLE=$(ls $INDIR | sed -n ${N}p)
LEFT=$(ls -1 $INDIR/$SAMPLE/*_1.fastq.gz | perl -p -e 's/\s+/,/g;' | perl -p -e 's/,$//')
RIGHT=$(echo -n "$LEFT" | perl -p -e 's/_1\.fastq/_2.fastq/g')
DB=$DBDIR/$SAMPLE
OUTSAM=$OUTPUT/$SAMPLE.sam
OUTBAM=$OUTPUT/$SAMPLE.bam
if [ ! -f $OUTBAM ]; then
    hisat2 -x $DB -p $CPU --sensitive -q -1 $LEFT -2 $RIGHT -S $OUTSAM
    samtools sort --threads $CPU --reference $DB.fasta -O cram -o $OUTBAM $OUT
fi

NOMATCH=$OUTPUT/$SAMPLE.nomatch.fq
if [ ! -f $NOMATCH ]; then
	samtools fastq -f 12 -F 256 -o $NOMATCH $OUTBAM
fi

