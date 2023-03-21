library(ggplot2)
library(tidyverse)
library(dplyr)
library(tidyr)
library(cowplot)

###Read in the data file ###
Stats <- read.table("Pangenom_general_stats.txt", header=TRUE, sep="\t", row.names = NULL)
Stats


## Total genome Size and TE content (Mbp)
Size <- ggplot(data=Stats, aes(x=Count, y=Genome, fill=Factor, group = Factor)) +
  geom_bar(colour="black", stat="identity", position = "stack") + theme(legend.position = "top") + xlab("") + theme(legend.title= element_blank()) +
  scale_fill_brewer(palette="Accent")

Size

Size <- ggplot(data=Stats, aes(x=Count, y=Genome, fill=factor(Factor, levels = c("Size(Mbp)","Intergenic_Space(Mbp)", "TE_content(Mbp)")))) +
  geom_bar(colour="black", stat="identity", position = position_dodge(width = 0), width=2.5) + theme(legend.position = "top") + xlab("") + theme(legend.title= element_blank()) +
  scale_fill_brewer(palette="Accent")

Size

###Read in the next data file ###
GeneCount <- read.table("Pangenome_geneCoutns.txt", header=TRUE, sep="\t", row.names = NULL)
GeneCount
## Total genome Size and TE content (Mbp)
Count <- ggplot(data=GeneCount, aes(x=Count, y=Genome, fill=Factor)) +
  geom_bar(colour="black", stat="identity") + theme(legend.position = "top") + xlab("") +
  theme(axis.text.y=element_blank(), #remove x axis labels
        axis.ticks.y=element_blank(),
        axis.title.y = element_blank(),
  ) + scale_fill_manual(values=c("#E69F00")) + scale_x_continuous(breaks = seq(0, 20000, by = 5000)) + theme(legend.title= element_blank())

Count

#### Read in the data file for TE types ####

TEs <- read.table("Pangenome_TEs.txt", header=TRUE, sep="\t", row.names = NULL)
TEs

### TE content Count and Types ###
TEp <- ggplot(data=TEs, aes(x=Count, y=Genome, fill=Factor)) +
  geom_bar(colour="black", stat="identity") + theme(legend.position = "top") + xlab("") + scale_fill_brewer(palette="Dark2")+
  theme(axis.text.y=element_blank(), #remove x axis labels
        axis.ticks.y=element_blank(),
        axis.title.y = element_blank(),
  ) + theme(legend.title= element_blank())

TEp

plot_grid(Size, Count, TEp, ncol=3,rel_widths = c(3, 2, 2))
