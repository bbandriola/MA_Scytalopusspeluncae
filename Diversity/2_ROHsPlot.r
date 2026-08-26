# Load libraries and read data
library(tidyverse)
#install.packages("ggrepel")
library(ggrepel)

args <- commandArgs(trailingOnly = TRUE)

if (length(args) < 1) {
  stop("Usage: Rscript 2_ROHsPlot.r <FilteredPCAandUCE_Max30missinessDepthmin10max100_Sspeluncaecomplexedited.roh.population.txt>")
}

input_file <- args[1]
# Read data with read_delim() for better control over input file parsing
roh <- read_delim(input_file, delim = "\t", col_names = c("Sample", "Chromosome", "RoH_length", "Population"))

# Compute NROH and SROH
roh <- roh %>%
  mutate(RoH_length = as.numeric(RoH_length))

nroh <- roh %>%
  group_by(Sample) %>%
  summarize(NROH = n())

sroh <- roh %>%
  group_by(Sample) %>%
  summarize(SROH = sum(RoH_length))

# Combine population information
data <- inner_join(nroh, sroh, by = "Sample") %>%
  inner_join(roh %>% select(Sample, Population) %>% distinct(), by = "Sample")

# Inspect the resulting dataset to ensure it is correct
#head(data)

my.colors <- c("#0660FB","#4D9F8C", "#7570B3", "#E8488B", "#66A61D","#E93F33","#E6AC2F")

# Create the plot using the preprocessed dataset
snroh_plot <- data %>%
  ggplot(aes(x = SROH, y = NROH, color = Population)) +
  geom_point(size = 3) +
  scale_colour_manual(values =my.colors)+
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5)) +
  labs(title = "NROH vs. SROH", color = "Population")

# Print the plot
print(snroh_plot)
ggsave("dsroh_nroh.png", snroh_plot, width = 8, height = 6, dpi = 300)

#summed_roh%%R

# Create RoH length categories
#roh_categories <- roh %>%
#  mutate(RoH_category = case_when(
#      RoH_length >= 1000000 ~ "< 1 Mb",
#      RoH_length >= 1000000 & RoH_length < 3000000 ~ "1 Mb - 3 Mb",
#      RoH_length >= 3000000 & RoH_length < 5000000 ~ "3 Mb - 5 Mb",
#      RoH_length >= 5000000 ~ "> 5 Mb",
#      TRUE ~ NA_character_)) %>% # Assign NA to lengths < 1 Mb
#  mutate(RoH_category = factor(RoH_category, levels = c("> 5 Mb", "3 Mb - 5 Mb", "1 Mb - 3 Mb","< 1 Mb"))) %>%
#  filter(!is.na(RoH_category)) # Remove rows where RoH_category is NA
roh_categories <- roh %>%
  mutate(
    RoH_length = as.numeric(gsub("[^0-9.]", "", RoH_length)),
    RoH_category = case_when(
      RoH_length < 1e5 ~ "< 100 kb",
      RoH_length >= 1e5 & RoH_length < 5e5 ~ "100 kb - 500 kb",
      RoH_length >= 5e5 & RoH_length < 1e6 ~ "500 kb - 1 Mb",
      RoH_length >= 1e6 & RoH_length < 2e6 ~ "1 Mb - 2 Mb",
      RoH_length >= 2e6 ~ "> 2 Mb",
      TRUE ~ NA_character_
    )
  ) %>%
  mutate(
    RoH_category = factor(
      RoH_category,
      levels = c("> 2 Mb","1 Mb - 2 Mb","500 kb - 1 Mb","100 kb - 500 kb","< 100 kb")
    )
  ) %>%
  filter(!is.na(RoH_category))


# Summing RoH_length by Sample, RoH_category, and Population
#summed_roh <- roh_categories %>%
#  group_by(Sample, RoH_category, Population) %>%
#  summarise(total_RoH_length = sum(RoH_length), .groups = "drop")  # Sum the RoH_length for each group
summed_roh <- roh_categories %>%
  group_by(Sample, RoH_category, Population) %>%
  summarise(total_RoH_length = sum(RoH_length), .groups = "drop")
my_sample_order <- c("SerradaLontras1_lin1","SerradaLontras2_lin1","SerradaLontras3_lin1","SerradaLontras4_lin1","SerradaLontras5_lin1",
                     "SerraDaOuricana1_lin1","SerraDaOuricana2_lin1","SerraDaOuricana3_lin1","SerraDaOuricana4_lin1",
                     "NorteMantiqueira1_lin3","NorteMantiqueira2_lin3",
                     "NorteMantiqueira3_lin3","NorteMantiqueira4_lin3","SulMantiqueira2_lin3","SulMantiqueira3_lin3","SulMantiqueira4_lin3",
                     "SulMantiqueira5_lin3","CunhaSerraDoMarRJ2_lin4","BocainaSerraDoMarRJ1_lin4",
                     "BocainaSerraDoMarRJ3_lin4","BocainaSerraDoMarRJ4_lin4","DevonianaPR8_lin5","DevonianaSP3_lin5",
                     "DevonianaSP4_lin5","DevonianaPR5_lin5","DevonianaPR6_lin5","DevonianaPR7_lin5","DevonianaPR2_lin5"
                     ,"DevonianaSP1_lin5","DevonianaSP2_lin5","DevonianaPR3_lin5","DevonianaPR4_lin5","NortePR1_lin7",
                     "NortePR2_lin7","NortePR3_lin7","NortePR4_lin7","NortePR5_lin7","HNortePR_lin7","CentroLestePR1_lin7",
                     "HCentroLesteSC_lin7","CentroLesteSC1_lin7","CentroOesteSC1_lin7","CentroOesteSC2_lin7","CentroOesteSC3_lin7",
                     "CentroOesteSC4_lin7","CentroOesteSC5_lin7","ExtremoSulSC1_lin7","ExtremoSulRS3_lin7","ExtremoSulRS2_lin7",
                     "BoaEsperanca1_lin6","BoaEsperanca2_lin6","BoaEsperanca3_lin7")  # your list here
my_sample_order_rev <- rev(my_sample_order)
summed_roh <- summed_roh %>%
  filter(Sample %in% my_sample_order) %>%
  mutate(Sample = factor(Sample, levels = my_sample_order_rev))
roh_colors <- c(
  "< 100 kb"      = "#568743",
  "100 kb - 500 kb" = "#5bc12c",
  "500 kb - 1 Mb"   = "#345e27",
  "1 Mb - 2 Mb"   = "#8a8368",
  "> 2 Mb"        = "#231f10"
)
print(summed_roh)

# Create the stacked bar plot
stacked_barplot <- summed_roh %>%
  ggplot(aes(x = Sample, y = total_RoH_length/1000000, fill = RoH_category)) +
  geom_bar(stat = "identity",width = 0.8) +
  theme_minimal(base_size = 10) +
  theme(
    axis.text.x = element_text(hjust = 1),
    strip.text = element_text(angle = 90, size = 10),panel.grid.major.x = element_blank(),
    panel.grid.minor = element_blank()
  ) +
  scale_y_continuous(labels = scales::comma) +
  scale_fill_manual(values = roh_colors) +
  labs(
    x = "Sample",
    y = "Total RoH Length (Mb)",
    fill = "RoH Category"
  )+ coord_flip()
# Print the plot
print(stacked_barplot)
ggsave("smallcategories_rohs_barplot.svg", stacked_barplot, width = 8, height = 6, dpi = 300)
