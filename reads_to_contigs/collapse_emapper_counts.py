#!/usr/bin/env python3
import csv
from collections import defaultdict

ann_file = "emap.emapper.annotations"
count_file = "gene_counts.txt"

out_cog_id = "COG_ID_abundance.tsv"
out_cog_cat = "COG_category_abundance.tsv"
out_kegg = "KEGG_KO_abundance.tsv"
out_egg = "eggNOG_OG_abundance.tsv"

# Parse eggNOG annotations
gene2cogcat = {}
gene2ko = {}
gene2og = {}

with open(ann_file) as f:
    header = None
    for line in f:
        if not line.strip() or line.startswith("##"):
            continue
        if line.startswith("#"):
            line = line[1:]
        parts = line.rstrip("\n").split("\t")
        if header is None:
            header = parts
            col = {name: i for i, name in enumerate(header)}
            for key in ("query", "COG_category", "KEGG_ko", "eggNOG_OGs"):
                if key not in col:
                    raise ValueError(f"Missing {key} in {ann_file} header")
            continue

        q = parts[col["query"]]
        gene2cogcat[q] = parts[col["COG_category"]]
        gene2ko[q] = parts[col["KEGG_ko"]]
        gene2og[q] = parts[col["eggNOG_OGs"]]

# Read counts
with open(count_file) as f:
    _ = f.readline()  # comment
    header = f.readline().rstrip("\n").split("\t")
    samples = header[6:]

    cog_id_counts = defaultdict(lambda: [0.0] * len(samples))
    cog_cat_counts = defaultdict(lambda: [0.0] * len(samples))
    ko_counts = defaultdict(lambda: [0.0] * len(samples))
    og_counts = defaultdict(lambda: [0.0] * len(samples))

    for line in f:
        parts = line.rstrip("\n").split("\t")
        geneid = parts[0]   # e.g. 1_1
        chrid = parts[1]    # contig id
        vals = [float(x) for x in parts[6:]]

        # Build eggNOG query id: contig + "_" + gene number
        gene_num = geneid.split("_")[-1]
        query = f"{chrid}_{gene_num}"

        # COG category (A–Z)
        cogcat = gene2cogcat.get(query, "-")
        if cogcat not in ("-", "", "NA"):
            cats = sorted(set([c for c in cogcat if c.isalpha()]))
            for c in cats:
                row = cog_cat_counts[c]
                for i, v in enumerate(vals):
                    row[i] += v

        # True COG IDs (COG#### from eggNOG_OGs)
        ogs = gene2og.get(query, "-")
        if ogs not in ("-", "", "NA"):
            for og in ogs.split(","):
                og = og.strip()
                if og.startswith("COG"):
                    cog_id = og.split("@")[0]  # COG1410@1|root -> COG1410
                    row = cog_id_counts[cog_id]
                    for i, v in enumerate(vals):
                        row[i] += v

        # KEGG KO
        ko = gene2ko.get(query, "-")
        if ko not in ("-", "", "NA"):
            for k in ko.split(","):
                k = k.strip()
                if not k:
                    continue
                row = ko_counts[k]
                for i, v in enumerate(vals):
                    row[i] += v

        # eggNOG OGs (all OGs)
        if ogs not in ("-", "", "NA"):
            for og in ogs.split(","):
                og = og.strip()
                if not og:
                    continue
                row = og_counts[og]
                for i, v in enumerate(vals):
                    row[i] += v

def write_table(path, data):
    with open(path, "w", newline="") as out:
        w = csv.writer(out, delimiter="\t")
        w.writerow(["Feature"] + samples)
        for key in sorted(data):
            w.writerow([key] + [f"{x:.2f}" for x in data[key]])

write_table(out_cog_id, cog_id_counts)
write_table(out_cog_cat, cog_cat_counts)
write_table(out_kegg, ko_counts)
write_table(out_egg, og_counts)

print("Wrote:", out_cog_id, out_cog_cat, out_kegg, out_egg)
