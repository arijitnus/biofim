#!/bin/bash

#SBATCH -n 1
#SBATCH --cpus-per-task=90
#SBATCH --mem=145g
#SBATCH -t 8:00:00
#SBATCH --mail-type=begin,end,fail
#SBATCH --mail-user=arijitm@unc.edu
module load bbmap
for r1 in *_R1_cut.fastq.gz; do
    r2=${r1/_R1_cut.fastq.gz/_R2_cut.fastq.gz}
    base=${r1%_R1_cut.fastq.gz}

    bbduk.sh -Xmx1g \
        in="$r1" \
        in2="$r2" \
        out1="clean_${base}_R1.fq.gz" \
        out2="clean_${base}_R2.fq.gz" \
        trimq=20 qtrim=rl minlen=75
done
