#!/bin/bash

#SBATCH -n 1
#SBATCH --cpus-per-task=256
#SBATCH --mem=950g
#SBATCH -t 26:00:00
#SBATCH --mail-type=begin,end,fail
#SBATCH --mail-user=arijitm@unc.edu

source /nas/longleaf/home/arijitm/miniconda3/etc/profile.d/conda.sh
conda activate megahit
megahit --12 *.fq --k-min 27 --k-max 197 --k-step 10 --min-contig-len 1000 -t 256
