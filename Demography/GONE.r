# GONE 
# 1. generate file ped/map
# plink
# --allow-extra-chr
#  --out Lin1_bigger1Mbscaffolds_FilteredPCAandUCE_Max30missingDepthmin10
#  --recode
#  --vcf Lin1_bigger500kbscaffolds_FilteredPCAandUCE_Max30missingDepthmin10_GeographicNames_allsamples.vcf.recode.vcf.gz

# 2. organize the map file 
# change scaffolds to chr : 
  # awk '!seen[$1]++ { chr++; map[$1]=chr } { print map[$1], $2, $3, $4 }' Lin1_bigger1Mbscaffolds_FilteredPCAandUCE_Max30missingDepthmin10_chr.map > Lin1_bigger1Mbscaffolds_FilteredPCAandUCE_Max30missingDepthmin10_chr.map
  # cp Lin1_bigger1Mbscaffolds_FilteredPCAandUCE_Max30missingDepthmin10.ped Lin1_bigger1Mbscaffolds_FilteredPCAandUCE_Max30missingDepthmin10_chr.ped
# add snp numbers to each snp 
  # awk '{$2=NR; print}' Lin1_bigger1Mbscaffolds_FilteredPCAandUCE_Max30missingDepthmin10_chr.map > Lin1_bigger1Mbscaffolds_FilteredPCAandUCE_Max30missingDepthmin10_chr1.map
  # mv Lin1_bigger1Mbscaffolds_FilteredPCAandUCE_Max30missingDepthmin10_chr1.map Lin1_bigger1Mbscaffolds_FilteredPCAandUCE_Max30missingDepthmin10_chr.map
# move the files to the GONE directory
  # mv Lin1_bigger1Mbscaffolds_FilteredPCAandUCE_Max30missingDepthmin10_chr* ~/Scytalopus/GONE/Linux/

# 3. run GONE
# before running:       
  #export TMPDIR="$(pwd)/tmp"
  #export TEMP="$TMPDIR"
  #export TMP="$TMPDIR"
# bash scrip_GONE.sh filemap/ped

# 4. plot in R 
# Read GONE output
library(ggplot2)
setwd("./")
gone <- read.table("Output_Ne_Lin7_42scaffolds2M_FilteredPCAandUCE_Max30missingDepthmin10_chr", header = TRUE, skip=1)

# Detect format
if (ncol(gone) == 2) {
  colnames(gone) <- c("Generation", "Ne")
} else {
  colnames(gone) <- c("Generation", "Ne", "Ne_low", "Ne_high")
}

g <- 3.2  # example
gone$Years <- gone$Generation * g

pdf("Lin7.pdf",,width = 10,height = 10)
ggplot(gone, aes(x = Generation, y = Ne)) +
  geom_line(linewidth = 1) +
  scale_x_log10() +
  labs(
    x = "Generations in the past",
    y = "Effective population size (Ne)",
    title = "Demographic history inferred by GONE"
  ) +
  theme_classic()

ggplot(gone, aes(x = Generation, y = Ne)) +
  geom_line(linewidth = 1) +
  scale_x_log10(limits = c(1, 150)) +
  theme_classic()
dev.off()

# Plot
plot(
  gone$Generation,
  gone$Ne,
  type = "l",
  log = "x",
  lwd = 2,
  xlab = "Generations in the past",
  ylab = "Effective population size (Ne)",
  main = "Demographic history inferred by GONE"
)

# Add CI if present
if ("Ne_low" %in% colnames(gone)) {
  polygon(
    c(gone$Generation, rev(gone$Generation)),
    c(gone$Ne_low, rev(gone$Ne_high)),
    col = rgb(0.7, 0.7, 0.7, 0.5),
    border = NA
  )
  lines(gone$Generation, gone$Ne, lwd = 2)
}


###################################################################
conda activate plink

plink --vcf /media/labgenoma5/DATAPART3/bandriola/Scytalopus/snparcher/vcfs/ManuscriptVCFs/41chr_FilteredMinDPMaxDPperInd20MaxMissBialelicSNPs_FilteredPCAandUCE_GeographicNames_allsamples.recode.vcf.gz.recode.vcf.gz --keep Lin1.txt --allow-extra-chr --recode --double-id --geno 0.5 --out Lin1_41chr_FilteredMinDPMaxDPperInd20MaxMissBialelicSNPs
plink --vcf /media/labgenoma5/DATAPART3/bandriola/Scytalopus/snparcher/vcfs/ManuscriptVCFs/41chr_FilteredMinDPMaxDPperInd20MaxMissBialelicSNPs_FilteredPCAandUCE_GeographicNames_allsamples.recode.vcf.gz.recode.vcf.gz --keep Lin3Mant.txt --allow-extra-chr --recode --double-id --out Lin3Mant_41chr_FilteredMinDPMaxDPperInd20MaxMissBialelicSNPs
plink --vcf /media/labgenoma5/DATAPART3/bandriola/Scytalopus/snparcher/vcfs/ManuscriptVCFs/41chr_FilteredMinDPMaxDPperInd20MaxMissBialelicSNPs_FilteredPCAandUCE_GeographicNames_allsamples.recode.vcf.gz.recode.vcf.gz --keep Lin4.txt --allow-extra-chr --recode --double-id --out Lin4_41chr_FilteredMinDPMaxDPperInd20MaxMissBialelicSNPs
plink --vcf /media/labgenoma5/DATAPART3/bandriola/Scytalopus/snparcher/vcfs/ManuscriptVCFs/41chr_FilteredMinDPMaxDPperInd20MaxMissBialelicSNPs_FilteredPCAandUCE_GeographicNames_allsamples.recode.vcf.gz.recode.vcf.gz --keep Lin5n.txt --allow-extra-chr --recode --double-id --out Lin5n_41chr_FilteredMinDPMaxDPperInd20MaxMissBialelicSNPs
plink --vcf /media/labgenoma5/DATAPART3/bandriola/Scytalopus/snparcher/vcfs/ManuscriptVCFs/41chr_FilteredMinDPMaxDPperInd20MaxMissBialelicSNPs_FilteredPCAandUCE_GeographicNames_allsamples.recode.vcf.gz.recode.vcf.gz --keep Lin7n.txt --allow-extra-chr --recode --double-id --out Lin7n_41chr_FilteredMinDPMaxDPperInd20MaxMissBialelicSNPs

awk '!seen[$1]++ { chr++; map[$1]=chr } { print map[$1], $2, $3, $4 }' Lin1_41chr_FilteredMinDPMaxDPperInd20MaxMissBialelicSNPs.map > Lin1_41chr_FilteredMinDPMaxDPperInd20MaxMissBialelicSNPs_chr.map
awk '!seen[$1]++ { chr++; map[$1]=chr } { print map[$1], $2, $3, $4 }' Lin3Mant_41chr_FilteredMinDPMaxDPperInd20MaxMissBialelicSNPs.map > Lin3Mant_41chr_FilteredMinDPMaxDPperInd20MaxMissBialelicSNPs_chr.map
awk '!seen[$1]++ { chr++; map[$1]=chr } { print map[$1], $2, $3, $4 }' Lin4_41chr_FilteredMinDPMaxDPperInd20MaxMissBialelicSNPs.map > Lin4_41chr_FilteredMinDPMaxDPperInd20MaxMissBialelicSNPs_chr.map
awk '!seen[$1]++ { chr++; map[$1]=chr } { print map[$1], $2, $3, $4 }' Lin5n_41chr_FilteredMinDPMaxDPperInd20MaxMissBialelicSNPs.map > Lin5n_41chr_FilteredMinDPMaxDPperInd20MaxMissBialelicSNPs_chr.map
awk '!seen[$1]++ { chr++; map[$1]=chr } { print map[$1], $2, $3, $4 }' Lin7n_41chr_FilteredMinDPMaxDPperInd20MaxMissBialelicSNPs.map > Lin7n_41chr_FilteredMinDPMaxDPperInd20MaxMissBialelicSNPs_chr.map

cp Lin1_41chr_FilteredMinDPMaxDPperInd20MaxMissBialelicSNPs.ped Lin1_41chr_FilteredMinDPMaxDPperInd20MaxMissBialelicSNPs_chr.ped
cp Lin3Mant_41chr_FilteredMinDPMaxDPperInd20MaxMissBialelicSNPs.ped Lin3Mant_41chr_FilteredMinDPMaxDPperInd20MaxMissBialelicSNPs_chr.ped
cp Lin4_41chr_FilteredMinDPMaxDPperInd20MaxMissBialelicSNPs.ped Lin4_41chr_FilteredMinDPMaxDPperInd20MaxMissBialelicSNPs_chr.ped
cp Lin5n_41chr_FilteredMinDPMaxDPperInd20MaxMissBialelicSNPs.ped Lin5n_41chr_FilteredMinDPMaxDPperInd20MaxMissBialelicSNPs_chr.ped
cp Lin7n_41chr_FilteredMinDPMaxDPperInd20MaxMissBialelicSNPs.ped Lin7n_41chr_FilteredMinDPMaxDPperInd20MaxMissBialelicSNPs_chr.ped

awk '{$2=NR; print}' Lin1_41chr_FilteredMinDPMaxDPperInd20MaxMissBialelicSNPs_chr.map > Lin1_41chr_FilteredMinDPMaxDPperInd20MaxMissBialelicSNPs_chr1.map
awk '{$2=NR; print}' Lin3Mant_41chr_FilteredMinDPMaxDPperInd20MaxMissBialelicSNPs_chr.map > Lin3Mant_41chr_FilteredMinDPMaxDPperInd20MaxMissBialelicSNPs_chr1.map
awk '{$2=NR; print}' Lin4_41chr_FilteredMinDPMaxDPperInd20MaxMissBialelicSNPs_chr.map > Lin4_41chr_FilteredMinDPMaxDPperInd20MaxMissBialelicSNPs_chr1.map
awk '{$2=NR; print}' Lin5n_41chr_FilteredMinDPMaxDPperInd20MaxMissBialelicSNPs_chr.map > Lin5n_41chr_FilteredMinDPMaxDPperInd20MaxMissBialelicSNPs_chr1.map
awk '{$2=NR; print}' Lin7n_41chr_FilteredMinDPMaxDPperInd20MaxMissBialelicSNPs_chr.map > Lin7n_41chr_FilteredMinDPMaxDPperInd20MaxMissBialelicSNPs_chr1.map

awk '{ $2 = "SNP"$2; print }' Lin1_41chr_FilteredMinDPMaxDPperInd20MaxMissBialelicSNPs_chr1.map > Lin1_41chr_FilteredMinDPMaxDPperInd20MaxMissBialelicSNPs_chr.map
awk '{ $2 = "SNP"$2; print }' Lin3Mant_41chr_FilteredMinDPMaxDPperInd20MaxMissBialelicSNPs_chr1.map > Lin3Mant_41chr_FilteredMinDPMaxDPperInd20MaxMissBialelicSNPs_chr.map
awk '{ $2 = "SNP"$2; print }' Lin4_41chr_FilteredMinDPMaxDPperInd20MaxMissBialelicSNPs_chr1.map > Lin4_41chr_FilteredMinDPMaxDPperInd20MaxMissBialelicSNPs_chr.map
awk '{ $2 = "SNP"$2; print }' Lin5n_41chr_FilteredMinDPMaxDPperInd20MaxMissBialelicSNPs_chr1.map > Lin5n_41chr_FilteredMinDPMaxDPperInd20MaxMissBialelicSNPs_chr.map
awk '{ $2 = "SNP"$2; print }' Lin7n_41chr_FilteredMinDPMaxDPperInd20MaxMissBialelicSNPs_chr1.map > Lin7n_41chr_FilteredMinDPMaxDPperInd20MaxMissBialelicSNPs_chr.map

mv Lin1_41chr_FilteredMinDPMaxDPperInd20MaxMissBialelicSNPs_chr1.map Lin1_41chr_FilteredMinDPMaxDPperInd20MaxMissBialelicSNPs_chr.map
mv Lin3Mant_41chr_FilteredMinDPMaxDPperInd20MaxMissBialelicSNPs_chr1.map Lin3Mant_41chr_FilteredMinDPMaxDPperInd20MaxMissBialelicSNPs_chr.map
mv Lin4_41chr_FilteredMinDPMaxDPperInd20MaxMissBialelicSNPs_chr1.map Lin4_41chr_FilteredMinDPMaxDPperInd20MaxMissBialelicSNPs_chr.map
mv Lin5n_41chr_FilteredMinDPMaxDPperInd20MaxMissBialelicSNPs_chr1.map Lin5n_41chr_FilteredMinDPMaxDPperInd20MaxMissBialelicSNPs_chr.map
mv Lin7n_41chr_FilteredMinDPMaxDPperInd20MaxMissBialelicSNPs_chr1.map Lin7n_41chr_FilteredMinDPMaxDPperInd20MaxMissBialelicSNPs_chr.map

cp Lin1_41chr_FilteredMinDPMaxDPperInd20MaxMissBialelicSNPs_chr.* ./GONE/Linux/
cp Lin3Mant_41chr_FilteredMinDPMaxDPperInd20MaxMissBialelicSNPs_chr.* ./GONE/Linux/
cp Lin4_41chr_FilteredMinDPMaxDPperInd20MaxMissBialelicSNPs_chr.* ./GONE/Linux/
cp Lin5n_41chr_FilteredMinDPMaxDPperInd20MaxMissBialelicSNPs_chr.* ./GONE/Linux/
cp Lin7n_41chr_FilteredMinDPMaxDPperInd20MaxMissBialelicSNPs_chr.* ./GONE/Linux/

# using GONE v.1
bash bashfile.sh Lin1_41chr_FilteredMinDPMaxDPperInd20MaxMissBialelicSNPs_chr
