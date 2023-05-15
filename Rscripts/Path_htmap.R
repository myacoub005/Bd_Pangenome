### Generate a heatmap comparing the pathogenicity gene repertoire between Bd and the nonpathogenic chytrids ##

library(pheatmap)
library(ggplot2)



vals <- read.csv("Path_GeneCount_HtMapData.csv", row.names=1, check.names = FALSE)
#vals <- read.csv("Pathogenicity_genes_htmapData.csv", row.names=1)
vals

Technology <- c("Illumina", "Illumina", "ONT", "Illumina", "ONT", "Illumina", "ONT","Illumina","ONT","SANGER", "Illumina","SANGER", "SANGER")
Species <- c("Homolaphlyctis polyrhiza", "Polyrhizophydium stewartii", "Polyrhizophydium stewartii", "Batrachochytrium dendrobatidis","Batrachochytrium dendrobatidis","Batrachochytrium dendrobatidis","Batrachochytrium dendrobatidis","Batrachochytrium dendrobatidis","Batrachochytrium dendrobatidis","Batrachochytrium dendrobatidis","Batrachochytrium dendrobatidis","Batrachochytrium dendrobatidis","Batrachochytrium dendrobatidis")
Strain <- c("JEL142", "JEL0888", "JEL0888", "CLFT044","CLFT044","CLFT067","CLFT067","CLFT071","CLFT071","JAM81","JEL423","JEL423","RTP6")

sampd <- data.frame(Technology=Technology, Species=Species, Strain=Strain)
sampd#Strain <- factor(sampd$Strain, levels = c("CLFT067", "CLFT071"))

ann_colors = list(
  Technology = c(Illumina="grey95", SANGER="grey50", ONT="grey8"),
  Species = c("Homolaphlyctis polyrhiza"="deepskyblue3", "Batrachochytrium dendrobatidis"="tomato3", "Polyrhizophydium stewartii"="seagreen4"),
  Strain = c(JEL142="deepskyblue3",JEL0888="seagreen4", CLFT044="gold1",CLFT067="orange",CLFT071="chocolate1",JEL423="orchid",JAM81="pink", RTP6="blueviolet"))

rownames(sampd) <- colnames(vals)

vals

ph <- pheatmap(vals, cluster_rows=FALSE,display_numbers = vals,fontsize_number = 12, show_rownames=TRUE,scale = "row",
               fontsize_row = 10,fontsize_col = 0.1,
               cluster_cols=FALSE, annotation_col=sampd, annotation_colors = ann_colors)

ph
