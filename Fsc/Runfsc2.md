Analysis to investigate different populations demographic dynamic within the last maximum glacial in Atlantic Forest distribution. 
Populations: 
* S. gonzagai (n=9) (lin1)
* S. speluncae mantiqueira (n=9) (lin3_onlymant)
* S. speluncae Serra do Mar (n=4) (lin4)
* Sp1 population north of Paraná (n=17) (lin5 (Dev+norte PR)) 
* Sp1 population south of Rio Grande do Sul (n=11) (lin7)

.tpl file
```linux
//Number of population samples (demes)
1
//Population effective sizes (number of genes (dploid)) (correto?)
NCUR
//Sample sizes
22
//Growth rates : negative growth implies population expansion
0
//Number of migration matrices : 0 implies no migration between demes
0
//historical event: time, source, sink, migrants, new size, new growth rate, migr. matrix
2 historical event
TLGM 0 0 0 RESIZELGM GANC 0
TBLGM1 0 0 0 RESIZEBLGM 0 0
//Number of independent loci [chromosome]
1 0
//Per chromosome: Number of linkage blocks
1
//per Block: data type, number of loci, per generation recomb. and mut. rat>
FREQ 1 0 9.03e-10
```

.est fil
```linux
// Priors and rules file
// *********************
[PARAMETERS]
//#isInt? #name #dist. #min #max
//all POP are in number of haploid individuals
1 NCUR logunif 10 100000 output bounded
1 NLGM logunif NCUR 200000 output paramInRange
1 NANC logunif NLGM 200000 output paramInRange
1 TLGM logunif 5000 15625 output bounded 
1 TBLGM1 logunif TLGM 30000 output paramInRange
0 GANC unif -1e-3 -0.1 output bounded
[COMPLEX PARAMETERS]
0 RESIZELGM = NLGM/NCUR output
0 RESIZEBLGM = NANC/NLGM output
```
