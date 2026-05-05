#!/bin/bash

#SBATCH -n 1
#SBATCH --cpus-per-task=90
#SBATCH --mem=45g
#SBATCH -t 34:00:00
#SBATCH --mail-type=begin,end,fail
#SBATCH --mail-user=arijitm@unc.edu

module load samtools
for f in *.sam; do
  [ -e "$f" ] || continue
  samtools view --threads 48 -bS "$f" > "${f%.sam}.bam"
done

