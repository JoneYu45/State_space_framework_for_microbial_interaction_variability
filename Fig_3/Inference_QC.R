#Environment setup
library(ggplot2)
setwd('../')

#Data input
path <- 'Output'
sub_path <- c('LWR_output_demo')

##########################################################################
#Collect info
for (m in 1:length(sub_path)) {
  fit_result_files <- dir(paste(path, sub_path[m], 'fit_result', sep = '/'))
  info <- array(0, dim = c(1,8))
  ##Collect in sequence
  for (i in 1:length(fit_result_files)) {
    file_info <- unlist(strsplit(fit_result_files[i], split = '_'))
    workbook <- paste(path, sub_path[m], 'fit_result', fit_result_files[i], sep = '/')
    fit_result <- read.csv(workbook)
    info <- rbind(info, cbind(file_info[1], file_info[2], fit_result$X, 
                              fit_result$RMSE_o, fit_result$RMSE_o/fit_result$Std_o,#log(fit_result$RMSE_o/fit_result$Std_o), 
                              fit_result$Test.set.score, fit_result$ymax_test, fit_result$ymin_test))
  }
  
  ##Make input
  info <- info[-1,]
  colnames(info) <- c('target_otu', 'Theta', 'State', 'RMSE', 
                      'RMSE/STD', 'Test_score', 'max', 'min')
  info <- as.data.frame(info)
  for (i in 1:ncol(info)) {
    info[,i] <- as.numeric(as.character(info[,i]))
  }
  info$Theta <- as.character(info$Theta)
  
  ##Plot
  p <- 
    ggplot(info, aes(x=Theta, y=RMSE))+
    theme(panel.grid.major =element_line(size = 1),
          axis.title = element_text(size = 16, colour = "black"),
          axis.text = element_text(size = 14, colour = "black"),
          axis.line = element_line(linetype = "solid", size = 0.5),
          panel.background = element_rect(color = "black", size = 0.5),
          panel.grid.minor = element_blank()
    )+
    geom_boxplot(fill=c('#C52427', '#87AED6', '#7BAC53')[1])+
    scale_x_discrete(limits=c('0.1', '0.5', '1', '2', '5', '10'))+
    ylim(0,2)
  
  print(p)
  
  p <- 
    ggplot(info, aes(x=Theta, y=`RMSE/STD`))+
    theme(panel.grid.major =element_line(size = 1),
          axis.title = element_text(size = 16, colour = "black"),
          axis.text = element_text(size = 14, colour = "black"),
          axis.line = element_line(linetype = "solid", size = 0.5),
          panel.background = element_rect(color = "black", size = 0.5),
          panel.grid.minor = element_blank()
    )+
    geom_boxplot(fill=c('#C52427', '#87AED6', '#7BAC53')[1])+
    scale_x_discrete(limits=c('0.1', '0.5', '1', '2', '10'))+
    # ylim(0,10)+
    # geom_hline(yintercept=0, linetype='dashed', color='red', size=1.5)+
    geom_hline(yintercept=1, linetype='dashed', color='red', size=1.5)+
    ylab('RMSE/STD')+
    ylim(0,5)
    # ylab('log(RMSE/STD)')
  
  print(p)
  
  ##Select best theta
  best_theta <- array(NA, dim = c(nrow(fit_result)*(max(info[,1])+1), ncol(info)))
  colnames(best_theta) <- colnames(info)

  for (i in 0:max(info[,1])) {
    loc_otu <- which(info[,1] == i)
    focus <- info[loc_otu,]

    for (j in 1:nrow(fit_result)) {
      loc_state <- which(focus$State == (j-1))
      state_info <- focus[loc_state,]

      best_theta[i*nrow(fit_result)+j,] <- as.matrix(state_info[which.min(state_info[,5]),])
    }
  }

  ##Collect the coefs via best theta
  coefs_file <- dir(paste(path, sub_path[m], 'coefs', sep = '/'))
  best_coefs <- paste(best_theta[1,1], best_theta[1,2], 'coefs.csv', sep = '_')
  workbook <- paste(path, sub_path[m], 'coefs', best_coefs, sep = '/')
  best_coefs <- read.csv(workbook, row.names = 1)
  collected_coefs <- array(NA, dim = c(1, ncol(best_coefs)))

  for (i in 1:nrow(best_theta)) {
    best_coefs <- paste(best_theta[i,1], 2, 'coefs.csv', sep = '_')
    # best_coefs <- paste(best_theta[i,1], best_theta[i,2], 'coefs.csv', sep = '_')
    workbook <- paste(path, sub_path[m], 'coefs', best_coefs, sep = '/')
    best_coefs <- read.csv(workbook, row.names = 1)

    colnames(collected_coefs) <- colnames(best_coefs)
    collected_coefs <- rbind(collected_coefs, best_coefs[as.numeric(best_theta[i,3])+1,])
  }
  collected_coefs <- collected_coefs[-1,]

  ##Output best coefs
  output_name <- paste(sub_path[m], 'best_coefs.csv', sep = '_')
  write.csv(collected_coefs,
            file = paste(path, output_name, sep = '/'))
}

