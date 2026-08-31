for pop in Lin1 Lin3 Lin4 Lin5 Lin7; do
    infile="${pop}_FilteredMinDPMaxDPperInd20MaxMissBialelicSNPs_FilteredPCAandUCE_GeographicNames_speluncaecomplex.recode.vcf.gz"
    outfile="${pop}_renamed.vcf.gz"

    bcftools annotate --rename-chrs chrom_rename_map.txt "$infile" -Oz -o "$outfile"
    tabix -p vcf "$outfile"
done
