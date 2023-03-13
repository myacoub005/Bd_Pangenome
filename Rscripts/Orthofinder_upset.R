library(UpSetR)
library(RColorBrewer)

# read in data
y <- read.csv("Orthogroups.GeneCount.csv", header = TRUE, row.names(1), sep = ",", stringsAsFactors=FALSE)

rownames(y) <- c(y$Orthogroup)
colnames(y) <- c("Orthogroup", "CLFT044", "CLFT067", "CLFT071", "RTP6", "JEL423")

# Assign 1 to data larger than 0 (binary presence/absence file)
y[y > 0] <- 1

# Save without correct row names (fix in excel b/c it's frustrating me to figure it out and I can do it quicker that way)
write.csv(y, file = "Orthogroups.GeneCount.binary.csv", append = FALSE, col.names = TRUE)

### IN EXCEL: move "orthogroups" row name to orthogroups column cut column of all 1s, then sort and cut out orthogroups found in ALL strains/species (this is because the number of shared orthogroups in all are likely going to be much larger and you won't be able to see the others well in the plot - BUT - you do not have to do this or you can do both and see the difference)) 

# Read in edited binary file
data <- read.csv("Orthogroups.GeneCount.binary.csv", header = TRUE, row.names(1), sep = ",", stringsAsFactors = FALSE)
data
# Make upset plot
z <- unlist(c("CLFT044", "CLFT067", "CLFT071", "RTP6", "JEL423")) #species/strains you want to look at

#x <- as.matrix(data)
brew.colors <- brewer.pal(6,"Dark2") #this just gets a list of default colors for me to put in for "col1, col2" etc. below - the default colors sometimes look too similar)

col1 <- "skyblue4"
col2 <- "#FF5768"
col3 <- "#FF96C5"
col4 <- "#00A5E3"
col5 <- "goldenrod"

upset(data, keep.order = TRUE, nsets=5, nintersects = 80,mb.ratio = c(0.7, 0.3), sets = NULL, matrix.color = "black", show.numbers = FALSE, point.size = 2,  line.size = 0.5,query.legend = "top", mainbar.y.label = "Shared Orthogroups", order.by = c('freq'), decreasing = c(TRUE, TRUE), text.scale = c(1.3, 1.3, 1.3, 1.5, 2, 1), sets.bar.color=c("skyblue4","skyblue4","skyblue4","goldenrod","goldenrod"), 
      queries = list(
        list(query = intersects, params = list("CLFT044", "CLFT067", "CLFT071"),color = col1, active = T, query.name = "BRAZIL"), 
        list(query = intersects, params = list("JEL423"), color = col2, active = T, query.name = "JEL423 reference only"), 
        list(query = intersects, params = list("RTP6"), color = col3, active = T, query.name = "RTP6"),
        list(query = intersects, params = list("RTP6","JEL423"), color = col5, active = T, query.name = "GPL"),
        list(query = intersects, params = list("CLFT044", "CLFT067", "CLFT071","RTP6"), color = col4, active = T, query.name = "Bd in all But Reference")))

#note: text.scale = c(intersection size title, intersection size tick labels, set size title, set size tick labels, set names, numbers above bars)
