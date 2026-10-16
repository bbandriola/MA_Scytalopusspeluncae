angsd -b filteredbamlist_Lin1.txt -out Lin1_FilteredRegions20and60depth -gl 1 -dosaf 1 -uniqueOnly -minQ 30 -nThreads 10 -anc ~/../../DATAPART7/sandro_grupo/raw_data/bruna/refSsuperciliaris/GCA_013400415.1_ASM1340041v1/GCA_013400415.1_ASM1340041v1_genomic.fa
source $HOME/.cargo/env
winsfs Lin1_FilteredRegions20and60depth.saf.idx > Lin1_FilteredRegions20and60depth.sfs
