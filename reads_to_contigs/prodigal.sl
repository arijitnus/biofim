#!/bin/bash

#SBATCH -n 1
#SBATCH --cpus-per-task=90
#SBATCH --mem=45g
#SBATCH -t 4:00:00
#SBATCH --mail-type=begin,end,fail
#SBATCH --mail-user=arijitm@unc.edu

conda activate prodigal
prodigal -i filtered_renamed_contigs.fa \
  -a genes.faa \
  -d genes.fna \
  -f gff \
  -o genes.gff \
  -p meta
