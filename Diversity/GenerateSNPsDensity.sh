# Workflow to generate SNP Density plot per individual 
# script based on: https://github.com/henriquevf/Tutorials/blob/main/SNP%20density%20tutorial.md

# 1. Generate a vcf file for each individual 
# Bash GenerateVCF.sh
#!/bin/bash
vcf_file="$1"          # First argument: VCF file
shift                  # Shift to get remaining arguments as samples
sample_list=("$@")     # All remaining arguments are sample names
echo "activate conda"
conda activate bcftools
echo "starting analyses"
# Iterate over each sample
for sample in "${sample_list[@]}"; do
     # Process each sample individually
     vcftools --gzvcf "$vcf_file" --indv "$sample" --recode --out "${sample}_FilteredMax30missingDepthmin5_hetsites" --maf 0.1
done
echo "done"

# command: 
./GenerateVCF.sh ../../vcffiles/OnlySspeluncae_FilteredMax30missingDepthmin5_mergedVCFproject0_1_2_4_5_6_7_8.vcf.gz  Sspeluncae48_lin1 Sspeluncae118_lin1 Sspeluncae6_lin2 Sspeluncae8_lin2 Sspeluncae83_lin2 Sspeluncae116_lin3 Sspeluncae113_lin3 Sspeluncae13_lin3 Sspeluncae5_lin4 Sspeluncae16_lin4 Sspeluncae28_lin5 Sspeluncae140_lin5 Sspeluncae54_lin6 Sspeluncae122_lin6 Sspeluncae56_lin7 Sspeluncae87_lin7 Sspeluncae52_lin7 Sspeluncae64_lin7 Sspeluncae71_lin7 Sspeluncae123_lin7 Sspeluncae139_lin7

# 2. Genetate the snps density files with vcftools 
for file in *.vcf
do
    name=$(basename $file)
    name=${name%.vcf.gz}
    vcftools --vcf $file --SNPdensity 50000 --out ${name}_density
done


# 3. Add a ind collumn o the files so it can be concateneted latter 
# add ind label 
# labels.sh
# bash labels.sh 
for file in *_SNPsDensity.snpden; do
    sample=${file%_SNPsDensity.snpden}
    awk -v sample="$sample" 'NR==1{print $0"\tIndiv"} NR>1{print $0"\t"sample}' "$file" > "${sample}_SNPsDensity.snpden_id.snpden"
done

# 3. Concatenate all into a single file
tail -q -n +2 *_id.snpden > Sspeluncae_hetsites.snpden


