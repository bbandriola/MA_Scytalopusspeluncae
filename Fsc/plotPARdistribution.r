library(tidyverse)
setwd("./")
table=read.table("allmodel1.bestlhoods",header=T)

pdf("dist_MaxEstLhood.pdf", height = 5, width = 6)
ggplot(table)+geom_line(aes(y=RUN,x=MaxEstLhood))
dev.off()

ggplot(table, aes(x = RUN, y = MaxEstLhood)) + geom_line() +
theme_bw() +

scale_y_continuous(breaks = unique(table$MaxEstLhood)
ggplot(table, aes(x = RUN, y = TSPLIT2)) + geom_line() +
theme_bw() +
scale_y_continuous(breaks = unique(table$TSPLIT2))
