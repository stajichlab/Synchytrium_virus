#!/usr/bin/bash
#SBATCH -p short -N 1 -n 16 --mem 8gb --out logs/rename2.log


zcat Reverse.fq.gz | awk '{{print (NR%4 == 1) ? "@1_" ++i "/2": $0}}' | pigz -c > reverse_edit.fq.gz
zcat Forward.fq.gz | awk '{{print (NR%4 == 1) ? "@1_" ++i "/1": $0}}' | pigz -c > forward_edit.fq.gz

zcat Forward.fq.gz | sed '/^[+SRR12590377]/s/[^ ]* /+/'| sed 's/[+].*$/+/'  > Forward_sed.fq
zcat Reverse.fq.gz | sed '/^[+SRR12590377]/s/[^ ]* /+/'| sed 's/[+].*$/+/'  > Reverse_sed.fq


