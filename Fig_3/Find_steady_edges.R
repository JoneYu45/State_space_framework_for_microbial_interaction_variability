#Environment setup
library(ggplot2)

Read_analyzed_state_and_coefs_tables <- function(
  i, j, source_node, sub_path, direction,  abund
){
  ###Locate analyzed state
  analyzed_state_loc <- paste(sub_path, 'DD_S-map', direction, sep = '/')
  analyzed_state_files <- dir(analyzed_state_loc)
  
  ###Locate coefs tables
  coef_i_loc <- paste(sub_path, 'DD_S-map', direction, 'coefs', sep = '/')
  coefs_files <- dir(coef_i_loc)
  
  ###Read  analyzed state and coefs tables
  loc_i_j <- grep(paste('^', i-1, '_', j-1, '_', sep = ''), analyzed_state_files)
  analyzed_state <- read.csv(paste(analyzed_state_loc, analyzed_state_files[loc_i_j], 
                                   sep = '/'), 
                             row.names = 1)
  
  loc_i_j <- grep(paste('^', i-1, '_', j-1, '_', sep = ''), coefs_files)
  coef <- read.csv(paste(coef_i_loc, coefs_files[loc_i_j], sep = '/'), row.names = 1)
  
  ###Remove the last state
  if (nrow(abund)-1 %in% analyzed_state[,1]) {
    remove_loc <- which(analyzed_state[,1] == nrow(abund)-1)
    analyzed_state <- analyzed_state[-1*remove_loc, ]
    coef <- coef[-1*remove_loc, ]
  }
  
  ###Ouput according to analyzed state
  add <- as.data.frame(array(Inf, dim = c(nrow(abund)-1,1)))
  add[analyzed_state+1, 1] <- coef[,source_node]
  
  return(add)
}

Find_coef_when_i_change <- function(
  i, A, B, abund
){
  ###Prepare individual sub table
  add1 <- as.data.frame(array(Inf, dim = c(nrow(abund)-1,5)))
  colnames(add1) <- c('state', 'Changing node A', 'direction A-B', 'A+-B', 'A--B')
  add2 <- add1
  add1[,1] <- 1:(nrow(abund)-1)
  add2[,1] <- 1:(nrow(abund)-1)
  add1[,2] <- i-1
  add2[,2] <- i-1
  add1[,3] <- paste(A-1, B-1, sep = '-')
  add2[,3] <- paste(B-1, A-1, sep = '-')
  
  ###Find coef when node i change
  add1[,4] <- Read_analyzed_state_and_coefs_tables(i, B, A, sub_path, 'increase', abund)
  add1[,5] <- Read_analyzed_state_and_coefs_tables(i, B, A, sub_path, 'decrease', abund)
  add2[,4] <- Read_analyzed_state_and_coefs_tables(i, A, B, sub_path, 'increase', abund)
  add2[,5] <- Read_analyzed_state_and_coefs_tables(i, A, B, sub_path, 'decrease', abund)
  
  ###Combine results
  add <- rbind(add1, add2)
  
  return(add)
}

#Find the steady interaction according to the global pattern
#Data location
path <- 'E:/学习/研究生/研究生课题/大规模污泥群落数据统计/数据/DaDa_analysis/Midas_analysis/HKD_DD_S_map'

#Summarize DD S-map results
##Locate subpath and input abund
sub_path <- paste(path, 'HKD_manifold_abd1_tht1_thtps2_Z50', sep = '/')
abund <- read.csv(paste(sub_path, 'abund.csv', sep = '/'), row.names = 1)

##Collect coefs with increasing and decreasing node
###Make collect table to see how node A and B interact with each other when A or B are changing
DD_S_map_coefs <- as.data.frame(array(NA, dim = c(1,5)))
colnames(DD_S_map_coefs) <- c('state', 'Changing node A', 'direction A-B', 'A+-B', 'A--B')

###Collect one by one
for (i in 1:(ncol(abund)-1)) {
  for (j in (i+1):ncol(abund)) {
    ###Find coef when node i change
    add <- Find_coef_when_i_change(i, i, j, abund)
    DD_S_map_coefs <- rbind(DD_S_map_coefs, add)
    
    ###Find coef when node j change
    add <- Find_coef_when_i_change(j, i, j, abund)
    DD_S_map_coefs <- rbind(DD_S_map_coefs, add)
  }
}
DD_S_map_coefs <- DD_S_map_coefs[-1,]

#Plot
##Make input
input <- as.data.frame(array(NA, dim = c(2*nrow(DD_S_map_coefs),3)))
colnames(input) <- c('Source', 'Target', 'Strength')
pair <- t(matrix(unlist(strsplit(DD_S_map_coefs[,3], split = '-')), nrow = 2))
for (i in 1:2) {
  loc <- (i-1)*nrow(DD_S_map_coefs)+1:nrow(DD_S_map_coefs)
  input[loc,1] <- pair[,1]
  input[loc,2] <- pair[,2]
  input[loc,3] <- DD_S_map_coefs[,i+3]
}
input$Source <- factor(input$Source, levels = c(as.character(0:(ncol(abund)-1))))
input$Target <- factor(input$Target, levels = c(as.character(0:(ncol(abund)-1))))

##Plot histogram
input2 <- input
input2$sign <- as.character(sign(input2$Strength))

ggplot(input2, aes(x=Strength, fill=sign, color=sign))+
  geom_histogram(bins = 15,position='stack', alpha=0.5)+
  theme(axis.text.y = element_blank(),
        axis.text.x = element_text(size=10, angle=45, vjust=1, hjust=1),
        axis.title = element_text(size=18),
        legend.text = element_text(size=18), legend.title = element_text(size=18),
        strip.text=element_text(face="bold",size=18))+
  geom_vline(xintercept = 0, color='red', linetype='dashed')+
  facet_grid(Source ~ Target, scales = 'free_y')

##Make input for the nodes of interest
input3 <- input2
wanted_target <- 4
wanted_sources <- c(3, 9)
loc_target <- which(input3$Target == wanted_target)
loc_sources <- which(input3$Source %in% wanted_sources)
wanted_loc <- intersect(loc_target, loc_sources)
input3 <- input3[wanted_loc,]

##Plot histogram for the nodes of interest
ggplot(input3, aes(x=Strength, fill=sign, color=sign))+
  geom_histogram(bins = 15,position='stack', alpha=0.5)+
  theme(axis.text.y = element_blank(),
        axis.text.x = element_text(size=10, angle=45, vjust=1, hjust=1),
        axis.title = element_text(size=18),
        legend.text = element_text(size=18), legend.title = element_text(size=18),
        strip.text=element_text(face="bold",size=18))+
  geom_vline(xintercept = 0, color='red', linetype='dashed')+
  facet_grid(Source ~ Target, scales = 'free_y')

#Can we use the steady interaction to control the network? 
#How will the unsteady ones affect the controllability of network? Prove it.