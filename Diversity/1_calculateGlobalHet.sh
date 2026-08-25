#!/bin/bash

VCF="/media/labgenoma5/DATAPART3/bandriola/Scytalopus/snparcher/vcfs/ManuscriptVCFs/FilteredLDfiltered_MinDPMaxDPperInd20MaxMissBialelicSNPs_FilteredPCAandUCE_GeographicNames_complex_novacapitalis.recode.vcf.gz"
GENOME_LENGTH="1061776118"
OUTPUT="./heterozigosidade_perind.tsv"

# Get sample names from bcftools
SAMPLES=$(bcftools query -l "$VCF")

# Write header
echo -e "SampleID\tSitios_Heterozigotos\tHeterozigosidade" > "$OUTPUT"

# Count the number of heterozygous positions with bcftools and calculate heterozygosity
for SAMPLE in $SAMPLES; do
  HETEROZIGOTOS=$(bcftools view -s "$SAMPLE" "$VCF" \
                   | grep -v "^#" \
                   | grep -oE "0/1|1/0|0\|1|1\|0" \
                   | wc -l)
  HETEROZIGOSIDADE=$(echo "scale=7; $HETEROZIGOTOS / $GENOME_LENGTH" | bc)
  echo -e "$SAMPLE\t$HETEROZIGOTOS\t$HETEROZIGOSIDADE" >> "$OUTPUT"
done
