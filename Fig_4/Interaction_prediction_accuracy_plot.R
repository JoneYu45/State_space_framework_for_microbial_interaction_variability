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

###########################################################################################
#Data location
path <- 'E:/学习/研究生/研究生课题/大规模污泥群落数据统计/数据/DaDa_analysis/Midas_analysis'

###########################################################################################
#Summarize different theta
results <- array(0, dim = c(1,2))
colnames(results) <- c('tht', 'Accuracy')

for (focus_tht in c(0.1, 0.5, 1, 2, 10)) {
  #Summarize S-map results
  ##Locate subpath
  sub_path <- paste(path, 'HKD_Midas_L7/coefs', sep = '/')
  coefs_files <- dir(sub_path)
  
  ##Setting theta and find wanted coef files
  focus_file <- paste('_', focus_tht, '_coefs.csv', sep = '')
  wanted_coefs_files <- coefs_files[grep(focus_file, coefs_files)]
  
  ##Make collection table
  S_map_coefs <- array(0, dim = c(1, length(wanted_coefs_files)+2))
  colnames(S_map_coefs) <- c('state', 'target', 1:length(wanted_coefs_files)-1)
  
  ##Input wanted coef files
  for (i in 1:length(wanted_coefs_files)) {
    target <- sub(focus_file, '', wanted_coefs_files[i])
    workbook <- paste(sub_path, wanted_coefs_files[i], sep = '/')
    coef <- read.csv(workbook, row.names = 1)
    coef <- cbind(1:nrow(coef),target, coef)
    
    ##Combine all coefs
    colnames(coef) <- colnames(S_map_coefs)
    S_map_coefs <- rbind(S_map_coefs, coef)
  }
  S_map_coefs <- S_map_coefs[-1,]
  
  ###########################################################################################
  #Summarize DD S-map results
  ##Locate subpath and input abund
  sub_path <- paste(path, 'HKD_DD_S_map/HKD_manifold_abd1_tht1_thtps01_Z50', sep = '/')
  abund <- read.csv(paste(sub_path, 'abund.csv', sep = '/'), row.names = 1)
  
  ##Collect coefs with increasing and decreasing node
  ###Make collect table to see how node A and B interact with each other when A or B are changing
  DD_S_map_coefs <- as.data.frame(array(NA, dim = c(1,5)))
  colnames(DD_S_map_coefs) <- c('state', 'Changing node A', 'direction A-B', 'A+-B', 'A--B')
  
  ###Collect one by one
  for (i in 1:(length(wanted_coefs_files)-1)) {
    for (j in (i+1):length(wanted_coefs_files)) {
      ###Find coef when node i change
      add <- Find_coef_when_i_change(i, i, j, abund)
      DD_S_map_coefs <- rbind(DD_S_map_coefs, add)
      
      ###Find coef when node j change
      add <- Find_coef_when_i_change(j, i, j, abund)
      DD_S_map_coefs <- rbind(DD_S_map_coefs, add)
    }
  }
  DD_S_map_coefs <- DD_S_map_coefs[-1,]
  
  ###########################################################################################
  #Matching the two results
  ##The real interaction should be within the range of 
  ##maximum and minimum coefs according to the DD_S-map calculation
  for (state in 1:(nrow(abund)-1)) {
    n=0
    for (target in (1:ncol(abund)-1)) {
      for (source in (1:ncol(abund)-1)) {
        if (target != source) {
          ##Locate the coef in S-map result
          target_loc <- which(S_map_coefs$target == target)
          S_map_coef <- S_map_coefs[target_loc[state], source+3]
          
          ##Locate the coef in DD_S-map result
          target_state_loc <- which(DD_S_map_coefs$state == state)
          pair_loc <- grep(paste(source, target, sep = '-'), DD_S_map_coefs$`direction A-B`)
          ###Intersect
          intersect_loc <- intersect(target_state_loc, pair_loc)
          DD_S_map_coef <- unlist(DD_S_map_coefs[intersect_loc, 4:5])
          
          ##Test our hypothesis
          if (Inf %in% DD_S_map_coef) {
            DD_S_map_coef <- DD_S_map_coef[-1*which(DD_S_map_coef == Inf)]
          }
          if ({min(DD_S_map_coef) <= S_map_coef} & {S_map_coef <= max(DD_S_map_coef)}) {
            n = n + 1
          }
        } 
      }
    }
    ##Calculate accuracy for each state
    accuracy <- n/(ncol(abund)*(ncol(abund)-1))*100
    print(accuracy)
    
    ##Collect results
    add_result <- array(0, dim = c(1,2))
    colnames(add_result) <- colnames(results)
    add_result[1,1] <- focus_tht
    add_result[1,2] <- accuracy
    results <- rbind(results, add_result) 
  }
}
results <- results[-1, ]

#Output
write.csv(results,
          file = paste(path, 'thtps_01_Acc.csv', sep = '/'))

#Plot
results <- as.data.frame(results)
results$tht <- as.character(results$tht)
ggplot(results, aes(x=tht, y=Accuracy))+
  theme(panel.grid.major =element_line(size = 1),
        axis.title.y = element_text(size = 16, colour = "black"),
        axis.title.x = element_blank(),
        axis.text = element_text(size = 14, colour = "black"),
        axis.text.y = element_text(size = 14, colour = "black"),
        axis.line = element_line(linetype = "solid", size = 0.5),
        panel.background = element_rect(color = "black", size = 0.5),
        panel.grid.minor = element_blank()
  )+
  geom_boxplot(fill='#C52427')+
  ylim(20,100)+
  scale_x_discrete(limits=as.character(c(0.1,0.5,1,2,10)))+
  ylab('Accuracy (%)')


