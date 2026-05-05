#!/bin/bash

#SBATCH -n 1
#SBATCH --cpus-per-task=90
#SBATCH --mem=45g
#SBATCH -t 2:00:00
#SBATCH --mail-type=begin,end,fail
#SBATCH --mail-user=arijitm@unc.edu

module load subread
featureCounts -a genes.gff -o gene_counts.txt -T 16 -t CDS -g ID -p *.bam

