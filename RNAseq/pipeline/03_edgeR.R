library(edgeR)

#fc <- read.table("counts.txt", sep='\t', header=TRUE)
#fc <- read.delim("counts.txt", row.names=1)

rawCountTable <- read.delim("counts.txt", header=TRUE, sep = "\t", row.names=1)

rawCountTable$Length
rownames(rawCountTable)
#rawCountTable <- rawCountTable[-c(1,2), -c(1,2,3,4,5)] 

rawCountMaxtrix <- as.matrix(rawCountTable, select=3:8)

#rawCountMaxtrix

#dge <- DGEList(counts=rawCountMaxtrix, genes=data.frame(Length=Length))
dge <- DGEList(counts=rawCountMaxtrix, genes=data.frame(rawCountTable$Length))
dge

#y <- readDGE( "counts.txt", columns=c(1,8) )

y <- readDGE( "counts.txt",columns=c(1,3,4,5,6,7,8))

#y

y$genes <- read.delim( "counts.txt"[1], row.names=1 )[,-6]

#y$genes

#RPKM <- rpkm(y)

#RPKM

#TPM <- t( t(RPKM) / colSums(RPKM) ) * 1e6

#TPM

#y <- readDGE( fc, columns=c(1,7) )
#y$genes <- read.delim( fc[1], row.names=1 )[,-6]

#RPKM <- rpkm(fc)

#RPKM

RPKM <- rpkm(dge)
#RPKM

TPM <- t( t(RPKM) / colSums(RPKM) ) * 1e6

write.table(TPM, "hisat2_JEL423_ref.TPM.tsv", row.names=TRUE, sep="\t")
