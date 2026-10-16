# calculated using FilteredPCAandUCE_Max30missinessDepthmin10max100_Sspeluncaecomplex.vcf.gz
# heterozygosity per individual
%%bash 
awk '/^>/ {if (seqlen) {print seqname, seqlen; total += seqlen} seqname=substr($0,2); seqlen=0; next} {seqlen+=length($0)} END {print seqname, seqlen; total+=seqlen; print "Soma total dos comprimentos:", total}' superciliarisref.fasta # result

VCF=".vcf.gz"
GENOME_LENGTH="1061776118"
OUTPUT="heterozigosidade.tsv"

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

# SNV for each population 
#!/bin/bash

#Choose individual
SAMPLE_NAMES="SerradaLontras4_lin1 SerraDosOrgaos3_lin2 Caparao_lin3 SulMantiqueira4_lin3 CunhaSerraDoMarRJ2_lin4 DevonianaPR8_lin5 BoaEsperanca2_lin6 NortePR5_lin7 CentroLesteSC1_lin7 ExtremoSulRS3_lin7"

#Choose the output directory
output_directory="./"
VCF_FILE="../../snparcher/vcfs/FilteredPCAandUCE_Max30missinessDepthmin10max100MAF0.05_Sspeluncaecomplex.vcf.gz"

# Process each individual
for sample in $SAMPLE_NAMES; do
    echo "Processing sample: $sample"

    # Extract individual's VCF
    bcftools view -c 1 -s "$sample" -Oz -o "${output_directory}/${sample}.vcf.gz" "$VCF_FILE"
    bcftools index "${output_directory}/${sample}.vcf.gz"

    #Extract heterozygous positions using bcftools query
	  bcftools query -f '%CHROM\t%POS\t%REF\t%ALT\t[%GT]\n' "${output_directory}/${sample}.vcf.gz" \
	    | grep -w "0/1" > "${output_directory}/${sample}_hets.txt"

    echo "Heterozygous positions for $sample extracted."

    # Cria arquivo de regiões
    awk '{print $1 "\t" $2}' "${output_directory}/${sample}_hets.txt" > "${output_directory}/${sample}_hets.regions"

    # Usa esse arquivo no bcftools
    bcftools view -R "${output_directory}/${sample}_hets.regions" "${output_directory}/${sample}.vcf.gz" \
    -Oz -o "${output_directory}/${sample}_hets.vcf.gz"

    # Indexa o novo VCF
    bcftools index "${output_directory}/${sample}_hets.vcf.gz"

    echo "Heterozygous VCF for $sample created."

done

######## calculate the SNV density in 1Mb 

#!/bin/bash
for file in ./*_hets.vcf.gz; do
    name=$(basename "$file" _hets.vcf.gz)
    vcftools --gzvcf "$file" --SNPdensity 1000000 --out ./"${name}_density"
done


########### FILE PLOT SNV
# Adicione o nome do indivíduo a cada linha do output
#!/bin/bash
for file in ./*_density.snpden; do
    sample=$(basename "$file" _density.snpden)
    awk -v sample="$sample" 'NR==1 {print $0 "\tSample"} NR>1 {print $0 "\t" sample}' "$file" > ./"${sample}_annotated.snpden"
done

# Combine os outputs em um único arquivo

tail -q -n +2 ./*_annotated.snpden > ./combined_snp_density.snpden

####### Plot in R 


