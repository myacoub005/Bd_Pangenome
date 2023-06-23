### Check for co-localization of Pathogenicity proteases#

library(ggplot2)
library(RColorBrewer)
library(colorRamps)
library(dplyr)
library(tidyverse)

df <- read.table("Path_positions_10kb.txt", header=T, sep="\t")
 
df$Chr <- sub("supercontig_1\\.","",df$Chr,perl=TRUE) 


chrlist = c(1:23)
d=df[df$Chr %in% chrlist, ]
d <- d[order(d$Chr, d$Chr_start), ]
d$index = rep.int(seq_along(unique(d$Chr)), times = tapply(d$Chr_start,d$Chr,length)) 

d$pos=NA


nchr = length(unique(d$Chr))
lastbase=0
ticks = NULL
minor = vector(,23)
for (i in 1:23 ) {
  if (i==1) {
    d[d$index==i, ]$pos=d[d$index==i, ]$Chr_start
  } else {
    ## chromosome position maybe not start at 1, eg. 9999. So gaps may be produced. 
    lastbase = lastbase + max(d[d$index==(i-1),"Chr_start"])
    minor[i] = lastbase
    d[d$index == i,"Chr_start"] =
      d[d$index == i,"Chr_start"]-min(d[d$index==i,"Chr_start"]) +1
    d[d$index == i,"End"] = lastbase
    d[d$index == i, "pos"] = d[d$index == i,"Chr_start"] + lastbase
  }
}

ticks <-tapply(d$pos,d$index,quantile,probs=0.5)
print(ticks)

pdffile= sprintf('plots/Clus_density_%dkb_all.pdf')
Title = "Feature density"
d$Chromosome <- df$Chr
d$Track.order = factor(df$Track,levels = c("Repeats",                                                                        "PopA.SNP.lungonly_curated_final",
                                           "CRN", "M36", "ASP"))

labels=c("Repeats",
         "CRN",
         "M36", "ASP")


df$Chr

df$Chr <- factor(df$Chr, levels = c("supercontig_1.1","supercontig_1.2","supercontig_1.3", "supercontig_1.4", 
                                    "supercontig_1.5", "supercontig_1.6", "supercontig_1.7", "supercontig_1.8", 
                                    "supercontig_1.9", "supercontig_1.10", "supercontig_1.11", "supercontig_1.12", 
                                    "supercontig_1.13", "supercontig_1.14", "supercontig_1.15", "supercontig_1.16", 
                                    "supercontig_1.17", "supercontig_1.18", "supercontig_1.19", "supercontig_1.20", 
                                    "supercontig_1.21", "supercontig_1.22", "supercontig_1.23"))


p <- ggplot(d, aes(pos, Density)) + geom_point(aes(color=df$Chr),
                                               alpha=0.5,size=1.5) +
  facet_wrap( ~Track.order, ncol=1, scales = "free") +
  labs(title="Repeat and Path Gene Density 10kb window JEL423",xlab="Chromosome",scales="free_y") +
  scale_x_continuous(position = "bottom",name="Chromosome", expand = c(0, 0),
                     breaks=ticks,
                     labels=(unique(d$Chr))) +   scale_y_continuous(expand=c(0,1))+
  theme_minimal() +
  theme(legend.position="bottom", panel.border = element_blank(),panel.grid.minor = element_blank(),
        panel.grid.major = element_blank(), axis.text.x = element_blank())

p

colourCount = length(unique(d$Chr))
getPalette = colorRampPalette(brewer.pal(23, "Accent"))

p <- ggplot(d, aes(pos, Density)) + geom_point(aes(color=df$Chr),
                                               alpha=0.5,size=1.5) +
  facet_wrap( ~Track.order, ncol=1, scales = "free") +
  labs(title="Repeat and Path Gene Density 10kb window JEL423",xlab="Chromosome",scales="free_y") +
  scale_x_continuous(position = "bottom",name="Chromosome", expand = c(0, 0),
                     breaks=ticks,
                     labels=(unique(d$Chr))) +   scale_y_continuous(expand=c(0,1))+
  theme_minimal() +
  theme(legend.position="bottom", panel.border = element_blank(),panel.grid.minor = element_blank(),
        panel.grid.major = element_blank(), axis.text.x = element_blank()) + scale_color_manual(values = getPalette(colourCount))

p
ggsave("Path_positions.pdf",p,width=15,height=10)

### Let's look at the pathogenicity gene placement with respect to each other ###

Distances <- read.table("Path_distances.txt", header=T, sep="\t")
Distances

cats <- Distances$Gene %>% table(cut(Distances$Distance, breaks = seq(0, 300000, 1000)))

#cats <- table(cut(Distances$Distance, breaks = seq(0, 50000, 1000)))
view(dat)

dat <- as.data.frame(cats)
dat

#fiftyplus <-sum(Distances$Distance>50000)
#fiftyplus

#dat <- data.frame(range=c(names(cats), "50000+"),
                  #count=c(as.numeric(cats), fiftyplus))


write.table(dat, file = "Gene_Range_distances.csv", sep=',')

dat2 <- read.csv("Gene_Range_distances.csv")
dat2
ggplot(dat) + geom_bar(aes(x=range, y=count), stat = "identity")

dat <- data.frame(range=c(names(cats)),
                  count=c(as.numeric(cats)))
                  
ggplot(dat2) + geom_bar(aes(x=End, y=Counts, color=Gene, fill=Gene), stat = "identity",position = position_dodge(width = 0))+ theme(axis.text.x = element_text(angle = 45, hjust = 1)) + 
  ggtitle("Distances between gene pairs") +
  xlab("Distance between gene pairs") + ylab("Number of gene pairs") + scale_color_brewer(palette="Set1") + scale_fill_brewer(palette="Set1")

ggplot(dat) + geom_point(aes(x=Var2, y=Freq, color=., group=.))

ggplot(dat2) + geom_density(aes(x=End, color=Gene, group=Gene, adjust=0.5))+ scale_color_brewer(palette="Set1") + scale_fill_brewer(palette="Set1") +
  xlab("Distance between gene pairs") + ylab("Density of gene pairs")

ggplot(data=dat2, aes(x=Start, y=Counts, color=Gene, group=Gene)) +
  geom_line()+
  geom_point() + ylim(0,35) + theme(axis.text.x = element_text(angle = 45, hjust = 1)) + 
  ggtitle("Distances between gene pairs") +
  xlab("Distance between gene pairs") + ylab("Number of gene pairs")

dat2



## Now let's check for tandem duplications ###

Distances <- read.table("Tandems_ggsearch.tab.txt", header=T, sep="\t")
Distances

cats <- Distances$Gene %>% table(cut(Distances$Distance, breaks = seq(0, 300000, 1000)))

#cats <- table(cut(Distances$Distance, breaks = seq(0, 50000, 1000)))
view(dat)

dat <- as.data.frame(cats)
dat

#fiftyplus <-sum(Distances$Distance>50000)
#fiftyplus

#dat <- data.frame(range=c(names(cats), "50000+"),
#count=c(as.numeric(cats), fiftyplus))


write.table(dat, file = "Tandems_distances.csv", sep=',')

dat2 <- read.csv("Tandems_distances.csv")
dat2


dat <- data.frame(range=c(names(cats)),
                  count=c(as.numeric(cats)))

ggplot(dat2) + geom_bar(aes(x=End, y=Count, color=Gene, fill=Gene), stat = "identity",position = position_dodge(width = 0))+ theme(axis.text.x = element_text(angle = 45, hjust = 1)) + 
  ggtitle("Distances between gene pairs") +
  xlab("Distance between gene pairs") + ylab("Number of gene pairs") + scale_color_brewer(palette="Set1") + scale_fill_brewer(palette="Set1")

ggplot(dat) + geom_point(aes(x=Var2, y=Freq, color=., group=.))

ggplot(dat2) + geom_density(aes(x=End, color=Gene, group=Gene, adjust=0.5))+ scale_color_brewer(palette="Set1") + scale_fill_brewer(palette="Set1") +
  xlab("Distance between best hits") + ylab("Density of gene pairs")

ggplot(data=dat2, aes(x=Start, y=Count, color=Gene, group=Gene)) +
  geom_line()+
  geom_point() + ylim(0,35) + theme(axis.text.x = element_text(angle = 45, hjust = 1)) + 
  ggtitle("Distances between gene pairs") +
  xlab("Distance between gene pairs") + ylab("Number of gene pairs")

dat2
