#!/bin/bash

# run ROH estimation 
# com qualidade da base 
bcftools roh -G30 --output FilteredMinDPMaxDPperInd20MaxMissBialelicSNPs /media/labgenoma5/DATAPART3/bandriola/Scytalopus/snparcher/vcfs/ManuscriptVCFs/FilteredMinDPMaxDPperInd20MaxMissBialelicSNPs_FilteredPCAandUCE_GeographicNames_speluncaecomplex.vcf.gz

grep "RG" FilteredMinDPMaxDPperInd20MaxMissBialelicSNPs.txt | cut -f 2,3,6 > allsamples.edited.roh.txt
# add origem populacional 
# cat scytalopus.popfile
## SampleID,Pop
## Sdiamantinensis,Sdiamantinensis
## SerradaLontras5_lin1,lin1

# get pops + rohs in a single file 
awk 'BEGIN{FS="\t";OFS="\t"}NR==FNR{if(FNR>1){split($0,a,",");pop[a[1]]=a[2]}next}FNR==1{print $0,"Population";next}{print $0,(pop[$1]?pop[$1]:"NA")}' \
   scytalopus.popfile allsamples.edited.roh.txt > allsamples.edited.roh.population.txt
