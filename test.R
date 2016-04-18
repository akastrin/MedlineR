termList<- c("STE18", "DIG1", "STE12", "SST2", "HOG1", "pheromone", "cell+cycle")
bla <- getAmatrix(termList)
ig <- graph.adjacency(bla, mode = "undirected", weighted = TRUE)
