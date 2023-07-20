library(Rsubread)

bam.files <- list.files(path = "./hisat/JEL423_ref", pattern = ".bam$", full.names = TRUE)
bam.files

#props <- propmapped(files=bam.files)

#props

#fc <- featureCounts(bam.files, annot.inbuilt="mm10")

fc <- featureCounts(files=bam.files,isPairedEnd=TRUE,nthreads=5,annot.ext="GCA_000149865.1.gtf",
isGTFAnnotationFile=TRUE,GTF.featureType="CDS",GTF.attrType="gene_id")

fc

#write.table(fc, file = "HISAT2_FeatureCounts.tsv", sep = "\t")

write.table(
  x=data.frame(fc$annotation[,c("GeneID","Length)],
    fc$counts,
    stringsAsFactors=FALSE),
  file="counts.txt",
  quote=FALSE,
  sep="\t",
  row.names=FALSE)
