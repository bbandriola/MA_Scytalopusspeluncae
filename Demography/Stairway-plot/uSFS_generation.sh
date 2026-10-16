angsd -GL 1 -b Lin5.bamlist -anc editedfastaancallele/editedACGT_subset41chr_allNchr.fasta -P 10 -out Lin5 -doSaf 1 -minInd 4 -rf chr2include.txt
angsd -GL 1 -b Lin6.bamlist -anc editedfastaancallele/editedACGT_subset41chr_allNchr.fasta -P 10 -out Lin6 -doSaf 1 -minInd 4 -rf chr2include.txt
angsd -GL 1 -b Lin7.bamlist -anc editedfastaancallele/editedACGT_subset41chr_allNchr.fasta -P 10 -out Lin7 -doSaf 1 -minInd 4 -rf chr2include.txt
angsd -GL 1 -b Lin3_OnlyMant.bamlist -anc editedfastaancallele/editedACGT_subset41chr_allNchr.fasta -P 10 -out Lin3_OnlyMant -doSaf 1 -minInd 4 -rf chr2include.txt
angsd -GL 1 -b Lin1.bamlist -anc editedfastaancallele/editedACGT_subset41chr_allNchr.fasta -P 10 -out Lin1 -doSaf 1 -minInd 4 -rf chr2include.txt
realSFS Lin3_OnlyMant.saf.idx -P 10 > Lin3OnlyMant_dsfs.sfs # total sites: 665,743
realSFS Lin4.saf.idx -P 10 > Lin4_dsfs.sfs # total sites: 665,499
realSFS Lin5.saf.idx -P 10 > Lin5_dsfs.sfs # total sites: 665,822
realSFS Lin6.saf.idx -P 10 > Lin6_dsfs.sfs # total sites: 665,819
realSFS Lin7.saf.idx -P 10 > Lin7_dsfs.sfs # total sites: 665,819
realSFS Lin1.saf.idx -P 10 > Lin1_dsfs.sfs # total sites: 665,656




