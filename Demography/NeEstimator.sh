# independent sites: OnlyVariants_NoZW_FilteredPCAandUCE_Max10missingDepthmin15_GeographicNames_OnlySpeluncae.recode.vcf.gz from each lineage
# 1. vcf to geno file using vcf2popgen
python 
import vcf2popgen
data = vcf2popgen.read('/media/labgenoma5/DATAPART2/bandriola/Scytalopus/vcfs/normalizedVCFs/.vcf', '/media/labgenoma5/DATAPART2/bandriola/Scytalopus/vcfs/normalizedVCFs/.csv')
data.to_genepop('./Lin2')
data.to_genepop('./PureLin5.geno')
# 2. NeEstimator
./Ne2x
Input file > GENOinput_*
1
Lin2_OnlyVariants_NoZW_FilteredPCAandUCE_Max10missingDepthmin15_GeographicNames_OnlySpeluncae.recode.vcf.gz
Lin3_OnlyVariants_NoZW_FilteredPCAandUCE_Max10missingDepthmin15_GeographicNames_OnlySpeluncae.recode.vcf.gz
Lin4_OnlyVariants_NoZW_FilteredPCAandUCE_Max10missingDepthmin15_GeographicNames_OnlySpeluncae.recode.vcf.gz
Lin6_OnlyVariants_NoZW_FilteredPCAandUCE_Max10missingDepthmin15_GeographicNames_OnlySpeluncae.recode.vcf.gz
PureLin5_OnlyVariants_NoZW_FilteredPCAandUCE_Max10missingDepthmin15_GeographicNames_OnlySpeluncae.recode.vcf.gz
PureLin7_OnlyVariants_NoZW_FilteredPCAandUCE_Max10missingDepthmin15_GeographicNames_OnlySpeluncae.recode.vcf.gz

popfileLin2.csv
popfileLin3.csv
popfileLin4.csv
popfileLin6.csv
popfilePureLin5.csv
popfilePureLin7.csv
