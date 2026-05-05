#!/bin/bash

#SBATCH -n 2
#SBATCH --cpus-per-task=90
#SBATCH --mem=145g
#SBATCH -t 6:00:00
#SBATCH --mail-type=begin,end,fail
#SBATCH --mail-user=arijitm@unc.edu

module load cutadapt
bash cutadapt.sh
