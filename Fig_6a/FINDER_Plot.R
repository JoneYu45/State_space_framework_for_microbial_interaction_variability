#Environment setup
library(pheatmap)
library(ggplot2)

#Locate data
data_loc <- 'E:/学习/研究生/研究生课题/大规模污泥群落数据统计/数据/resubmission_data/HKD_FINDER'

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

#Boxplot
input <- data.frame(array(NA, dim = c(nrow(collection_table)*ncol(collection_table), 2)))
colnames(input) <- c('OTU', 'Closeness Centrality')
for (i in 1:ncol(collection_table)) {
  input[1:nrow(collection_table)+(i-1)*nrow(collection_table),1] <- as.character(i-1)
  input[1:nrow(collection_table)+(i-1)*nrow(collection_table),2] <- collection_table[,i]
}

ggplot(input, aes(x=OTU, y=`Closeness Centrality`))+
  theme(panel.grid.major =element_line(size = 1),
        axis.title.x = element_blank(),
        axis.title.y = element_text(size = 14, colour = "black"),
        axis.text.x = element_text(size = 12, colour = "black"),
        axis.text.y = element_text(size = 12, colour = "black"),
        axis.line = element_line(linetype = "solid", size = 0.5),
        panel.background = element_rect(color = "black", size = 0.5),
        panel.grid.minor = element_blank(),
        legend.position = 'none'
  )+
  geom_boxplot()+
  scale_x_discrete(limits=c(as.character(0:(ncol(collection_table)-1))))
