#Environment setup
library(pheatmap)
library(ggplot2)

#Locate data
data_loc <- 'somewhere_you_save_the_FINDER_results/HKD_FINDER'

#Prepare collection table
collection_table <- array(0, dim = c(259, 14))
colnames(collection_table) <- c(0:(ncol(collection_table)-1))
rownames(collection_table) <- 1:nrow(collection_table)

for (i in 0:(nrow(collection_table)-1)) {
  #Make file names
  key_nodes_file <- paste(data_loc, paste('HK', i, '.txt', sep = ''), sep = '/')
  MaxCC_file <- paste(data_loc, paste('MaxCCList_Strategy_HK', i, '.txt', sep = ''), sep = '/')
  
  #Input data
  key_nodes_seq <- read.table(key_nodes_file)
  MaxCC_seq <- read.table(MaxCC_file)
  
  for (j in 1:nrow(key_nodes_seq)) {
    collection_table[i+1,key_nodes_seq[j,1]+1] <- MaxCC_seq[j,1] - MaxCC_seq[j+1,1]
  }
}

#Heatmap plot
annotation_row = data.frame(State = 1:nrow(collection_table))
rownames(annotation_row) <- 1:nrow(collection_table)
colnames(annotation_row) <- ' '

pheatmap(collection_table, cluster_row = F, cluster_cols = F, cellwidth = 18, 
         angle_col = '0', labels_row = '', fontsize = 14,
         annotation_row = annotation_row, annotation_legend = F)

pheatmap(t(collection_table), cluster_row = F, cluster_cols = F, cellheight = 18, 
         angle_col = '0', labels_col = '', fontsize = 14,
         annotation_row = annotation_row, annotation_legend = F)

