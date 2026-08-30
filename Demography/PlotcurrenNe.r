library(ggplot2)
library(dplyr)

Ne<-read.table("currentNe.txt",sep="\t",header=T)

order_lineages <- c("Sgonzagai","Lin3","Lin4","Lin5","Lin7")
Ne$Lineage <- factor(Ne$Lineage, levels = order_lineages)

p <- ggplot(Ne, aes(x = Lineage, y = Ne_point_estimate, color = Lineage)) +
  geom_errorbar(aes(ymin = Lower.bound_90._CI, ymax = Upper.bound_90._CI),
    width = 0.1,linewidth = 0.6,alpha = 0.5) +
  geom_errorbar(aes(ymin = Lower_bound_50._CI, ymax = Upper_bound_50._CI),width = 0.15,linewidth = 3) +
  geom_point(size = 5) +
  scale_color_manual(values = c("Sgonzagai" = "#0660FB","Lin3" = "#7570B3","Lin4" = "deeppink","Lin5" = "#66A61D","Lin6" = "#E93F33","Lin7" = "#E6AC2F")) +
  labs(x = "Lineage",y = expression("Current effective population size ("*N[e]*")")) +
  theme_classic() +
  theme(
    legend.position = "none",
    axis.text.x = element_text(angle = 45, hjust = 1,size=7))
ggsave("currentNe.png", p, width=4, height=5)
