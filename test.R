term_list<- c("STE18", "DIG1", "STE12", "SST2", "HOG1", "pheromone", "cell+cycle")
adj_mat <- getAmatrix(term_list)
g <- graph.adjacency(adj_mat, mode = "undirected", weighted = TRUE)
