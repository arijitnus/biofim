#!/bin/bash

#SBATCH -n 1
#SBATCH --cpus-per-task=90
#SBATCH --mem=100g
#SBATCH -t 24:00:00
#SBATCH --mail-type=begin,end,fail
#SBATCH --mail-user=arijitm@unc.edu

source /nas/longleaf/home/arijitm/miniconda3/etc/profile.d/conda.sh
conda activate eggnog
emapper.py \
  -i genes.faa \
  -m diamond \
  --sensmode more-sensitive \
  --data_dir /users/a/r/arijitm/biofilm_proj/prodigal_coassembly/eggnog_db \
  --dbmem \
  --cpu 90 \
  --output emap \
  --output_dir /users/a/r/arijitm/biofilm_proj/prodigal_coassembly/eggnog_out

