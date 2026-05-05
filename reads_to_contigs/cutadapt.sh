#!/bin/bash

for r1 in *_R1_*.fastq.gz; do
    r2=${r1/_R1_/_R2_}

    # Skip if the R2 pair doesn't exist
    [[ ! -f "$r2" ]] && continue

    prefix=${r1%%_R1_*}

    cutadapt \
	-a AGATCGGAAGAGCACACGTCTGAACTCCAGTCA -A AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGT \
        --error-rate 0.2 \
        --minimum-length 75 \
        --no-indels \
	-j 90 \
        -o "${prefix}_R1_cut.fastq.gz" \
        -p "${prefix}_R2_cut.fastq.gz" \
        "$r1" "$r2"
done
