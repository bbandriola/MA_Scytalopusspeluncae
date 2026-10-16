for i in *_lin1_final.bam; do samtools view -b -L Lin1_common_regions.bed -o "${i%.bam}_FilteredRegions20and60.bam" "$i"; done
