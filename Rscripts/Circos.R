#install.packages("circlize")
library(circlize)
circos.clear()
bed = generateRandomBed(nc = 2)
head(bed, n = 2)
circos.initializeWithIdeogram(plotType = NULL)
circos.genomicTrackPlotRegion(bed, panel.fun = function(region, value, ...) {
  if(CELL_META$sector.index == "chr1") {
    print(head(region, n = 2))
    print(head(value, n = 2))
  }
})

set.seed(123)
bed1 = generateRandomBed(nr = 100)
bed1 = bed1[sample(nrow(bed1), 20), ]
bed2 = generateRandomBed(nr = 100)
bed2 = bed2[sample(nrow(bed2), 20), ]

circos.initializeWithIdeogram()
circos.genomicLink(bed1, bed2, col = rand_color(nrow(bed1), transparency = 0.5), 
                   border = NA)
head(bed1)
head(bed2)

bed1 <- read_bed("synteny_PAF.txt", col_names = c("seq_id", "start", "end"))
bed2 <- read_bed("synteny_PAV2.txt", col_names = c("seq_id", "start", "end"))
head(bed1)
head(bed2)


cytoband.file = read.table("chroms.txt", header = TRUE)
circos.initializeWithIdeogram(cytoband.file)

cytoband.file

circos.genomicLink(bed1, bed2, col = rand_color(nrow(bed1), transparency = 0.5), 
                   border = NA)


