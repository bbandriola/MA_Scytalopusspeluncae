# Usage: python script.py input.vcf(.gz) groups.txt
# groups.txt
# INGROUP: sample1 sample2 sample3
# OUTGROUP1: sample11
# OUTGROUP2: sample12 sample13

import sys
import re
import gzip


def open_vcf(filename):
    if filename.endswith(".gz"):
        return gzip.open(filename, "rt")
    return open(filename)


def parse_group_file(group_file):
    groups = {}
    with open(group_file) as f:
        for line in f:
            line = line.strip()
            if not line or line.startswith("#"):
                continue
            name, samples = line.split(":")
            groups[name.strip()] = samples.strip().split()
    return groups


def get_sample_indices(vcf_header, groups):
    header_fields = vcf_header.strip().split("\t")
    sample_names = header_fields[9:]

    indices = {}
    for group, samples in groups.items():
        indices[group] = []
        for s in samples:
            if s not in sample_names:
                raise ValueError(f"Sample {s} not found in VCF")
            indices[group].append(sample_names.index(s))
    return indices


def extract_genotypes(fields):
    format_fields = fields[8].split(":")
    if "GT" not in format_fields:
        return None

    gt_index = format_fields.index("GT")
    sample_data = fields[9:]

    genotypes = []
    for s in sample_data:
        parts = s.split(":")
        if len(parts) <= gt_index:
            genotypes.append("./.")
        else:
            genotypes.append(parts[gt_index])

    return genotypes


def count_nucleotides(genotypes, ref, alt):
    counts = {"A": 0, "C": 0, "G": 0, "T": 0}
    alleles = [ref] + alt.split(",")

    for gt in genotypes:
        if gt in ("./.", ".|.", "."):
            continue  # just skip missing, don't kill site

        gt = re.split("[/|]", gt)

        for allele in gt:
            if allele == ".":
                continue
            allele = int(allele)
            if allele < len(alleles):
                base = alleles[allele]
                if base in counts:
                    counts[base] += 1

    return counts


def format_counts(counts):
    return f"{counts['A']},{counts['C']},{counts['G']},{counts['T']}"


def main(vcf_file, group_file):
    groups = parse_group_file(group_file)

    with open_vcf(vcf_file) as f:
        for line in f:
            if line.startswith("#CHROM"):
                indices = get_sample_indices(line, groups)
                print("\t".join(groups.keys()))
                continue

            if line.startswith("#"):
                continue

            fields = line.strip().split("\t")
            ref = fields[3]
            alt = fields[4]

            # keep SNP filter (you can remove if needed)
            if len(ref) != 1 or any(len(a) != 1 for a in alt.split(",")):
                continue

            genotypes = extract_genotypes(fields)
            if genotypes is None:
                continue

            output = []

            for group in groups:
                group_gts = [genotypes[i] for i in indices[group]]
                counts = count_nucleotides(group_gts, ref, alt)
                output.append(format_counts(counts))

            print("\t".join(output))


if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: python script.py input.vcf(.gz) groups.txt")
        sys.exit(1)

    main(sys.argv[1], sys.argv[2])
