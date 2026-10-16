# Script constructed by Henrique Figueiró and adapted by Bruna Boizonave
# Source: https://github.com/henriquevf/Tutorials/blob/main/Neofelis_snpdenPlot_sample.R
# 6.5.25

# Set the working directory to where the data files are located
setwd("~/Desktop/Projetos/Sspeluncae/Analises/SNPsDensity/") #Change the path to your own folder

# Load the required packages
library(tidyverse)
library(gdata)

# Read the SNP density data file
snpden <- read.table("Sspeluncae_hetsites.snpden", header = T)

# Define the order of the scaffolds to be used in the visualization
# scaffold_file <- "19BiggerScaf.txt" dind't work
# target <- c("VXBX01009921.1","VXBX01004249.1","VXBX01003474.1","VXBX01008609.1","VXBX01002725.1",
#            "VXBX01005888.1","VXBX01003014.1","VXBX01007701.1","VXBX01003755.1","VXBX01008695.1",
#            "VXBX01007125.1","VXBX01008236.1","VXBX01009439.1","VXBX01001056.1","VXBX01001501.1",
#            "VXBX01007795.1","VXBX01004397.1","VXBX01007997.1","VXBX01008145.1")

target <- c("VXBX01004249.1")

# rename to modify a different file instead the original 
snpden.master <- snpden

# Reorder the chromosome column of the data frame according to the target order
snpden.master$CHROM <- reorder.factor(snpden.master$CHROM, new.order = target)

# Subset data from chromosomes that are not "NA"
snpden.master <-subset(snpden.master, snpden.master$CHROM!='NA')
# Define DNP density intervals 
snpden.master$groups <- cut(as.numeric(snpden.master$VARIANTS.KB), 
                            c(0,0.05,0.1,0.15,0.20,0.25,0.5,0.75,1,1.25,1.5,1.75,2,2.25,2.5,2.75,
                              3,3.25,3.5,3.75,4,4.25,4.5,4.75,5,10,15,Inf),
                            include.lowest = TRUE, labels = c("0", "0.05-0.1", "0.1-0.15", "0.15-0.2", 
                                                              "0.2-0.25", "0.25-0.5", "0.5-0.75", "0.75-1", 
                                                              "1-1.25", "1.25-1.5", "1.5-1.75", "1.75-2", 
                                                              "2-2.25", "2.25-2.5", "2.5-2.75", "2.75-3", 
                                                              "3-3.25", "3.25-3.5", "3.5-3.75", "3.75-4", 
                                                              "4-4.25", "4.25-4.5", "4.5-4.75", "4.75-5",
                                                              "5-10","10-15", ">15"))

snpden.master$groups[snpden.master$VARIANTS.KB == 0] <- "0"
snpden.master$BIN_START <- as.numeric(as.character(snpden.master$BIN_START))

# Generate a list of all individuals from the Indv col
names_vec <- unique(snpden.master$Indiv)


# plot per scaffold
for (chromosome in unique(snpden.master$CHROM)){
  # Subset the data for the current chromosome
  snpden.chr <- subset(snpden.master, snpden.master$CHROM == chromosome)
  # Define title
  title<-expression(paste(italic("Scytalopus speluncae")))
  #Create ggplot object 
  snpden_plot <- snpden.chr %>% 
    mutate(Indiv = factor(Indiv, levels = names_vec)) %>%
    ggplot(aes(x=BIN_START, y=VARIANTS.KB)) + 
    geom_tile(aes(fill=groups)) +
    facet_grid(Indiv ~ ., switch='y') +
    labs(x = 'Scaffold Length', 
         y = 'Scaffold Number', 
         title = expression(paste(italic("Scytalopus speluncae"))), 
         subtitle = paste0("Scaffold ", chromosome, " heterozygous SNP densities")) + 
    theme_minimal() +
    theme(axis.title.y=element_blank(),
          axis.text.y=element_blank(),
          axis.ticks.y=element_blank(),
          panel.grid.minor = element_blank(),
          panel.grid.major = element_blank(),
          strip.text.y.left = element_text(angle = 0, size=8),
          panel.spacing.y=unit(0.15, "lines"),
          plot.title = element_text(hjust = .5, size = 15),
          plot.subtitle = element_text(hjust = .5, size = 13, color = "gray")) +
    scale_fill_manual(values = c("#000081", "#0000f3", "#004dff", "#00b3ff","#00e200", "#ceff29","#FDE74C", "#ffc600","#FFBA08",
                                 "#FF7E33","#ff6800","#EC3F13","#f30900", "#8E0103","brown"),
                      name = "Variants/kb",
                      labels = c("0", "0.05-0.1", "0.1-0.15", "0.15-0.2", 
                                 "0.2-0.25", "0.25-0.5", "0.5-0.75", "0.75-1", 
                                 "1-1.25", "1.25-1.5", "1.5-1.75", "1.75-2", 
                                 "2-2.25", "2.25-2.5", "2.5-2.75", "2.75-3", 
                                 "3-3.25", "3.25-3.5", "3.5-3.75", "3.75-4", 
                                 "4-4.25", "4.25-4.5", "4.5-4.75", "4.75-5",
                                 "5-10","10-15", ">15")) + # 15 labels 
    guides(fill = guide_legend(ncol = 2)+
    theme(legend.position = "right", legend.box = "vertical") +
    scale_x_continuous(name='Scaffold length', labels = c('0', '1Mb', '2Mb', '3Mb', '4Mb', '5Mb'),
                       breaks = seq(0, 5e6, by = 1e6), expand = c(0,0))
  
  ggsave(filename = paste0('Sspeluncae_',chromosome, '.1Mb.snpden.png'), plot = snpden_plot, device = 'png',
         dpi = 600, units = c('cm'), width = 50, height = 25, path = "plots/", bg = "white")
  
}

for (chromosome in unique(snpden.master$CHROM)) {
  # Subset the data for the current chromosome
  snpden.chr <- subset(snpden.master, snpden.master$CHROM == chromosome)
  
  # Define title
  title<-expression(paste(italic("Scytalopus speluncae")))
  
  #Create ggplot object 
  snpden_plot <- snpden.chr %>% 
    mutate(Indiv = factor(Indiv, levels = c("Sspeluncae113_lin3", "Sspeluncae120_lin1"))) %>%
    ggplot(aes(x=BIN_START, y=1)) + 
    geom_tile(aes(fill=groups)) +
    facet_grid(Indiv ~ ., switch='y') +
    labs(x = 'Scaffold Length' , 
         y = 'Scaffold Number' , 
         title = expression(paste(italic("Scytalopus speluncae"))), 
         subtitle = paste0("Scaffold ", chromosome, " heterozygous SNP densities")) + 
    theme_minimal() +
    theme(axis.title.y=element_blank(),
          axis.text.y=element_blank(),
          axis.ticks.y=element_blank(),
          panel.grid.minor = element_blank(),
          panel.grid.major = element_blank(),
          strip.text.y.left = element_text(angle = 0, size=8),
          panel.spacing.y=unit(0.15, "lines"),
          plot.title = element_text(hjust = .5, size = 15),
          plot.subtitle = element_text(hjust = .5, size = 13, color = "gray")) +
    scale_fill_manual(values = c("#000081", "#0000f3", "#004dff", "#00b3ff", "#29ffce", 
                                 "#7bff7b", "#ceff29", "#ffc600", "#ff6800", "#f30900", "brown","#800000","black"),
                      name = "Variants/kb",
                      labels = c("<0.05","0.05-0.10","0.10-0.15","0.15-0.20","0.20-0.25",
                                 "0.25-0.50","0.50-0.75","0.75-1.0","1.0-1.25","1.25-1.5",
                                 "1.5-1.75","1.75-2.0","2.0-2.25","2.25-2.5")) +  
    guides(fill = guide_legend(nrow = 2)) + 
    theme(legend.position = "bottom", legend.box = "horizontal") +
    scale_x_continuous(name='Scaffold length', labels = c('0', '1Mb', '2Mb', '3Mb', '4Mb', '5Mb'),
                       breaks = seq(0, 5e6, by = 1e6), expand = c(0,0))
  
  ggsave(filename = paste0('Sspeluncae_',chromosome, '.1Mb.snpden.png'), plot = snpden_plot, device = 'png',
         dpi = 600, units = c('cm'), width = 50, height = 25, path = "plots/", bg = "white")
  
}
