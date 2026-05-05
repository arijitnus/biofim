#!/bin/bash

#SBATCH -n 1
#SBATCH --cpus-per-task=90
#SBATCH --mem=45g
#SBATCH -t 12:00:00
#SBATCH --mail-type=begin,end,fail
#SBATCH --mail-user=arijitm@unc.edu

module load samtools
for bam in *.bam; do
  base="${bam%.bam}"
  samtools sort -@ 90 -o "${base}_sort.bam" "$bam"
done

