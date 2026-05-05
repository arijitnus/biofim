#!/bin/bash

#SBATCH -n 1
#SBATCH --cpus-per-task=48
#SBATCH --mem=45g
#SBATCH -t 6:30:00
#SBATCH --mail-type=begin,end,fail
#SBATCH --mail-user=arijitm@unc.edu
set -euo pipefail
module load bowtie2
for r1 in *_R1.fq.gz; do
  base="${r1%_R1.fq.gz}"
  r2="${base}_R2.fq.gz"

  if [[ ! -f "$r2" ]]; then
    echo "Skipping $base: missing $r2"
    continue
  fi

  bowtie2 \
    -x contigs_indexed \
    -1 "$r1" \
    -2 "$r2" \
    --no-unal \
    -X 1000 \
    -S "${base}_contigs.sam" \
    -p 48
done
