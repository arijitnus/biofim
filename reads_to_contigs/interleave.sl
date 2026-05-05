#!/bin/bash

#SBATCH -n 1
#SBATCH --cpus-per-task=90
#SBATCH --mem=45g
#SBATCH -t 6:00:00
#SBATCH --mail-type=begin,end,fail
#SBATCH --mail-user=arijitm@unc.edu

for r1 in clean_*_R1.fq.gz; do
    r2=${r1/_R1.fq.gz/_R2.fq.gz}
    sample=${r1#clean_}
    sample=${sample%_R1.fq.gz}

    echo "Interleaving $sample"
    bash interleave.sh "$r1" "$r2" > "int_${sample}.fq"
done

