# all populations together to estimate the ancester allele 
for i in chrVXBX0100*vcf.gz; do python SFS/Generate_input_est-sfs.py $i SFS/groupfile_ANCAllele_Lin4Lin3LinDEV.txt > inputest-sfs_$i.allele; done

# edited generated file
for i in inputest-sfs_*.allele; do tail -n +2 $i | awk -F'\t' 'BEGIN{OFS="\t"} {gsub(/2/,"1",$2); gsub(/2/,"1",$3); print}' > $i.txt; done

# run est-sfsls 
echo "running first chr..."
est-sfs config_file.txt chrVXBX01009921.allele.txt seedfile.txt chrVXBX01009921_output-file-sfs.txt hrVXBX01009921_output-file-pvalues.txt
echo "you made it! next"
est-sfs config_file.txt chrVXBX01004249.allele.txt seedfile.txt chrVXBX01009921_output-file-sfs.txt chrVXBX01009921_output-file-pvalues.txt
echo "done! celebrate and do it all again"

# get the ancester allele 
for i in chrVXBX*_output-file-pvalues.txt; do sed '1,8d' $i > MODIF_$i; done
bash gettheancestralstate.sh

# get the reference allele
for i in {1..38}; do
  grep -v "#" ${VCF_FILTERED}.chr$i.vcf | cut -f 1,2,4 > variants_chr$i.txt
done

# merge ref and ancester state 
# do for all files
paste -d '\t' ../variants_chrchrVXBX01000547_FilteredMinDPMaxDPperInd20MaxMissBialelicSNPs_FilteredPCAandUCE_GeographicNames_allsamples.recode.vcf.gz.txt ./ancestral_states_chrVXBX0100MODIF_chrVXBX01000547_output-file-pvalues.txt.txt > ./chrVXBX01000547_ref_ancalleles.txt
cat *_ref_ancalleles.txt > 41chr_ancallele.txt

# DO NOT DO THIS 
# subset the reference fasta and turn all bases in N 
#bedtools maskfasta -fi GCA_013400415.1_ASM1340041v1_genomic.fa -bed Ninallpos.bed -fo allNchr.fasta -mc N
#samtools faidx allNchr.fasta
#xargs samtools faidx allNchr.fasta < keepchr.txt > subset41chr_allNchr.fasta

# change fasta position to ancestral allele base
# the command understand fastas in block 
# there is no need to change the header of the fasta sequence 
# needs to check if there is need to change -1 or +1 the position of the base to change 
# write a script to extract only the bases that have the anc allele as A, as T, as G and as T
# sunset to use this positions in each step
bash basefiles.sh
  #!/bin/bash

  input="41chr_ancallele.txt"
  awk '$3=="A"' "$input" > baseA.txt
  awk '$3=="C"' "$input" > baseC.txt
  awk '$3=="G"' "$input" > baseG.txt
  awk '$3=="T"' "$input" > baseT.txt
  awk '$3=="-nan"' 41chr_ancallele.txt > basenan.txt

# now organize the base file to be a bed format 
awk 'BEGIN{OFS="\t"} {print $1, $2-1, $2}' baseA.txt > position2changeA.bed
awk 'BEGIN{OFS="\t"} {print $1, $2-1, $2}' baseC.txt > position2changeC.bed
awk 'BEGIN{OFS="\t"} {print $1, $2-1, $2}' baseG.txt > position2changeG.bed
awk 'BEGIN{OFS="\t"} {print $1, $2-1, $2}' baseT.txt > position2changeT.bed
awk 'BEGIN{OFS="\t"} {print $1, $2-1, $2}' basenan.txt > position2changenan.bed

# obtain all the variants called in the vcf 
bcftools query -f '%CHROM\t%POS\n' FilteredMinDPMaxDPperInd_FilteredPCAandUCE_GeographicNames_allsamples.vcf.gz | awk 'BEGIN{OFS="\t"}{print $1,$2-1,$2}' > Sites_FilteredMinDPMaxDPperInd_FilteredPCAandUCE_GeographicNames_allsamples.bed
awk 'NR==FNR {keep[$1]; next} $1 in keep' chromosomesbigger2M.txt Sites_FilteredMinDPMaxDPperInd_FilteredPCAandUCE_GeographicNames_allsamples.bed > subset_Sites_FilteredMinDPMaxDPperInd_FilteredPCAandUCE_GeographicNames_allsamples.bed
awk 'NR==FNR {exclude[$1 FS $2 FS $3]; next} !($1 FS $2 FS $3 in exclude)' SFS/editedfastaancallele/allpositionsancalleles.bed subset_Sites_FilteredMinDPMaxDPperInd_FilteredPCAandUCE_GeographicNames_allsamples.bed > position2changelowdepthvariants.bed

# modify fasta to explicity determiny the bases to the ancestral allele
echo "starting.."
bedtools maskfasta -fi GCA_013400415.1_ASM1340041v1_genomic.fa -bed position2changeA.bed -fo editedA_subset41chr.fasta -mc A
echo "next"
bedtools maskfasta -fi editedA_subset41chr.fasta -bed position2changeC.bed -fo editedAC_subset41chr.fasta -mc C
echo "next"
bedtools maskfasta -fi editedAC_subset41chr.fasta -bed position2changeG.bed -fo editedACG_subset41chr.fasta -mc G
echo "next"
bedtools maskfasta -fi editedACG_subset41chr.fasta -bed position2changeT.bed -fo editedACGT_subset41chr.fasta -mc T
echo "next"
bedtools maskfasta -fi editedACGT_subset41chr.fasta -bed position2changenan.bed -fo editedACGTnan_subset41chr.fasta -mc N
echo "next"
bedtools maskfasta -fi editedACGTnan_subset41chr.fasta -bed position2changelowdepthvariants.bed -fo editedACGTnanlowdepthvariants_subset41chr.fasta -mc N 
echo "done!"

# ----------------- Workflow using vcf_to_fastsimcoal.py -----------------
# source: https://ppp.readthedocs.io/en/latest/PPP_pages/Input_File_Generators/vcf_to_fastsimcoal.html
conda activate py3

model_creator.py --model 3Pop --model-pop-file 3Pop 3Pops.txt --pop-ind-file Lin3 Lin3.txt --pop-ind-file Lin4 Lin4.txt --pop-ind-file LinSouth LinSouth.txt
# output: out.model

# generate unfolded sfs
vcf_to_fastsimcoal.py --vcf ../FilteredMinDPMaxDPperInd20MaxMissBialelicSNPs_FilteredPCAandUCE_GeographicNames_allsamples.vcf.gz --model-file out.model --modelname 3Pop --dim m --basename Lin3Lin4LinSouth --bed-file editedfastaancallele/allpositionsancalleles.bed --outgroup-fasta editedfastaancallele/editedACGTnanlowdepthvariants_subseted41chr.fasta

# ----------------- Workflow using ANGSD/realSFS -----------------
# subset the individuals to generate the SFS 
## LinSouthDEV_4ind.bamlist DevonianaSP4_lin5 DevonianaSP1_lin5 DevonianaSP2_lin5 DevonianaPR6_lin5
## Lin3_4ind.bamlist SulMantiqueira2_lin3 SulMantiqueira3_lin3 NorteMantiqueira1_lin3 NorteMantiqueira3_lin3
## Lin4_4ind.bamlist BocainaSerraDoMarRJ1_lin4 BocainaSerraDoMarRJ3_lin4 BocainaSerraDoMarRJ4_lin4 CunhaSerraDoMarRJ2_lin4
## LinSouthDEV_4ind.bamlist
## /media/labgenoma5/DATAPART3/bandriola/Scytalopus/snparcher/bams/Sspeluncae32_lin5_final.bam
## /media/labgenoma5/DATAPART3/bandriola/Scytalopus/snparcher/bams/Sspeluncae23_lin5_final.bam
## /media/labgenoma5/DATAPART3/bandriola/Scytalopus/snparcher/bams/Sspeluncae28_lin5_final.bam
## /media/labgenoma5/DATAPART3/bandriola/Scytalopus/snparcher/bams/Sspeluncae109_lin5_final.bam
## 
## Lin3_4ind.bamlist
## /media/labgenoma5/DATAPART3/bandriola/Scytalopus/snparcher/bams/Sspeluncae13_lin3_final.bam
## /media/labgenoma5/DATAPART3/bandriola/Scytalopus/snparcher/bams/Sspeluncae14_lin3_final.bam
## /media/labgenoma5/DATAPART3/bandriola/Scytalopus/snparcher/bams/Sspeluncae9_lin3_final.bam
## /media/labgenoma5/DATAPART3/bandriola/Scytalopus/snparcher/bams/Sspeluncae113_lin3_final.bam
## 
## Lin4_4ind.bamlist
## /media/labgenoma5/DATAPART3/bandriola/Scytalopus/snparcher/bams/Sspeluncae2_lin4_final.bam
## /media/labgenoma5/DATAPART3/bandriola/Scytalopus/snparcher/bams/Sspeluncae4_lin4_final.bam
## /media/labgenoma5/DATAPART3/bandriola/Scytalopus/snparcher/bams/Sspeluncae5_lin4_final.bam
## /media/labgenoma5/DATAPART3/bandriola/Scytalopus/snparcher/bams/Sspeluncae16_lin4_final.bam

# APPROACH TO CALCULATE THE MONOMORPHIC SITES 
# change all the estimated ancesters allele by est-sfs to Ns
# calculate the saf with this fasta modified with N in te parts that were considered as the rest of the fasta 
# calcula the fold SFS 
# extract the mornomorphic sites of the folded SFS and sum with the unfolded. Use this as the number of monomorphic sites
# generate saf file for SFS folded to get the monomorphirc sites 
# 1. change the ref fasta: 
cat position2changeA.bed position2changeC.bed position2changeG.bed position2changeT.bed position2changenan.bed > maskancAleles.bed
bedtools maskfasta -fi GCA_013400415.1_ASM1340041v1_genomic.fa -bed maskancAleles.bed -fo maskedAncAllele_subset41chr.fasta -mc N

# 2. Generate the SAF files for paper 2
# reindex bam 
while read bam; do echo "Reindexing $bam"; samtools index -@ 10 "$bam"; done < Lin3_4ind.bamlist
while read bam; do echo "Reindexing $bam"; samtools index -@ 10 "$bam"; done < Lin4_4ind.bamlist
while read bam; do echo "Reindexing $bam"; samtools index -@ 10 "$bam"; done < LinSouthDEV_4ind.bamlist
while read bam; do echo "Reindexing $bam"; samtools index -@ 10 "$bam"; done < Lin5.bamlist
while read bam; do echo "Reindexing $bam"; samtools index -@ 10 "$bam"; done < Lin6.bamlist
while read bam; do echo "Reindexing $bam"; samtools index -@ 10 "$bam"; done < Lin7.bamlist
while read bam; do echo "Reindexing $bam"; samtools index -@ 10 "$bam"; done < Lin3_OnlyMant.bamlist
while read bam; do echo "Reindexing $bam"; samtools index -@ 10 "$bam"; done < Lin1.bamlist

# generate saf file for SFS unfolded
angsd -GL 1 -b Lin1.bamlist -anc editedfastaancallele/editedACGTnanlowdepthvariants_subseted41chr.fasta -P 10 -out Lin1_maskedancallele -doSaf 1 -rf 41chromosomes_sorted.txt
angsd -GL 1 -b Lin3_OnlyMant.bamlist -anc editedfastaancallele/editedACGTnanlowdepthvariants_subseted41chr.fasta -P 10 -out Lin3OnlyMant_maskedancallele -doSaf 1 -minInd 4 -rf chr2include.txt 
angsd -GL 1 -b Lin3_OnlyMant.bamlist -anc editedfastaancallele/editedACGTnanlowdepthvariants_subseted41chr.fasta -P 10 -out Lin3_OnlyMant_maskedancallele -doSaf 1 -rf chr2include.txt 
angsd -GL 1 -b Lin4_4ind.bamlist -anc editedfastaancallele/editedACGTnanlowdepthvariants_subseted41chr.fasta -P 10 -out Lin4_maskedancallele -doSaf 1 -minInd 4 -rf chr2include.txt
angsd -GL 1 -b Lin5.bamlist -anc editedfastaancallele/editedACGTnanlowdepthvariants_subseted41chr.fasta -P 10 -out Lin5_maskedancallele -doSaf 1 -rf chr2include.txt
angsd -GL 1 -b Lin6.bamlist -anc editedfastaancallele/editedACGTnanlowdepthvariants_subseted41chr.fasta -P 10 -out Lin6_maskedancallele -doSaf 1 -rf chr2include.txt
angsd -GL 1 -b Lin7.bamlist -anc editedfastaancallele/editedACGTnanlowdepthvariants_subseted41chr.fasta -P 10 -out Lin7_maskedancallele -doSaf 1 -rf chr2include.txt
  # this resulted in 665,530 (LinDEV) /665,481 (Lin3) /665,499 (Lin4) sites analyzed
# generate SFS# run realSFS with the v.921 teh steps above were ran with the v.940
realSFS Lin1_maskedancallele.saf.idx -P 3 > Lin1_maskedancallele.sfs
realSFS Lin3_OnlyMant_maskedancallele.saf.idx -P 3 > Lin3_OnlyMant_maskedancallele_dsfs.sfs
realSFS Lin3OnlyMant_maskedancallele.saf.idx -P 3 > Lin3OnlyMant4ind_maskedancallele.sfs
realSFS Lin4_maskedancallele.saf.idx -P 3 > Lin4_maskedancallele.sfs
realSFS Lin5_maskedancallele.saf.idx -P 3 > Lin5_maskedancallele.sfs
realSFS Lin6_maskedancallele.saf.idx -P 3 > Lin6_maskedancallele.sfs
realSFS Lin7_maskedancallele.saf.idx -P 3 > Lin7_maskedancallele.sfs

# 2. Generate the SAF files for paper 1
# Generate file saf
angsd -GL 1 -b Lin3_4ind.bamlist -anc editedfastaancallele/editedACGTnanlowdepthvariants_subseted41chr.fasta -P 10 -out Lin34ind_maskedancallele -doSaf 1 -rf 41chromosomes_sorted.txt
angsd -GL 1 -b LinSouthDEV_4ind.bamlist -anc editedfastaancallele/editedACGTnanlowdepthvariants_subseted41chr.fasta -P 10 -out LinSouthDEV4ind_maskedancallele -doSaf 1 -minInd 4 -rf 41chromosomes_sorted.txt
# Generate SFS from saf 
realSFS Lin34ind_maskedancallele.saf.idx Lin4_maskedancallele.saf.idx LinSouthDEV4ind_maskedancallele.saf.idx -P 3 > Lin34indLin4LinSouthDEV4ind_maskedancallele_DSFS.sfs
