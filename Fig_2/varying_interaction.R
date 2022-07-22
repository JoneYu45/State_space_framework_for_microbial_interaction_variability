#Environment setup
library(ggplot2)

#Parameter setup
tht <- 1

#Data input
data_loc <- '../Output/output_demo/coefs'
coefs_files <- dir(data_loc)
wanted_coefs_files_loc <- grep(paste('_', tht,'_coefs.csv', sep = ''), coefs_files)
wanted_coefs_files <- coefs_files[wanted_coefs_files_loc]

#Make input
input <- as.data.frame(array(0, dim = c(1,4)))
colnames(input) <- c('Source', 'Target', 'State', 'Jacobian_elements')
for (wanted_coef_file in wanted_coefs_files) {
  #Input coefs data
  coefs_file <- paste(data_loc, wanted_coef_file, sep = '/')
  coefs <- read.csv(coefs_file, row.names = 1)
  
  #Make add input 
  add_input <- as.data.frame(array(0, dim = c(nrow(coefs)*ncol(coefs),4)))
  colnames(add_input) <- c('Source', 'Target', 'State', 'Jacobian_elements')
  
  #Fill add input
  ##Fill target
  add_input[,2] <- sub(paste('_', tht,'_coefs.csv', sep = ''), '', wanted_coef_file)
  for (i in 1:ncol(coefs)) {
    ##Fill Source
    add_input[1:nrow(coefs)+nrow(coefs)*(i-1), 1] <- sub('X', '', colnames(coefs)[i])
    ##Fill day
    add_input[1:nrow(coefs)+nrow(coefs)*(i-1), 3] <- 1:nrow(coefs)
    ##Fill Jacobian elements
    add_input[1:nrow(coefs)+nrow(coefs)*(i-1), 4] <- coefs[,i]
  }
  add_input <- add_input[-1,]
  
  input <- rbind(input, add_input)
}
input$Source <- factor(input$Source, levels = c(as.character(0:(ncol(coefs)-1))))
input$Target <- factor(input$Target, levels = c(as.character(0:(ncol(coefs)-1))))

input <- input[-1*which(input$Source == input$Target),]
input <- input[-1*which(input$Jacobian_elements == 0),]

#Make color
colors <- array('Zero', dim = nrow(input))
for (i in 1:length(colors)) {
  if (input$Jacobian_elements[i] < 0) {
    colors[i] <- 'Negative'
  }
  if (input$Jacobian_elements[i] > 0) {
    colors[i] <- 'Positive'
  }  
}
col <- c('Zero' = '#F7F7F7', 'Negative' = 'blue', 'Positive' = 'red')

#Plot
ggplot(input, aes(x=State, y=Jacobian_elements))+
  theme(axis.text.y = element_blank(),
        axis.text.x = element_text(angle = 45, vjust = 1, hjust = 1),
        axis.title = element_text(size=18),
        legend.text = element_text(size=18), legend.title = element_text(size=18),
        strip.text=element_text(face="bold",size=18))+
  geom_point(aes(fill=colors), shape = 21, size=2.5, alpha=0.5)+
  scale_fill_manual(values = col, name='Interaction\nsign')+
  geom_hline(yintercept = 0, size=1)+
  facet_grid(Source ~ Target, scales = 'free')#

#Plot sub-graph
##Make input
target <- 0
source <- 1
loc_target <- which(input$Target == target)
loc_source <- which(input$Source == source)
loc <- intersect(loc_source, loc_target)
input2 <- input[loc,]
colors2 <- colors[loc]

##Plot
ggplot(input2, aes(x=State, y=Jacobian_elements))+
  theme(axis.text.y = element_blank(),
        axis.text.x = element_text(angle = 45, vjust = 1, hjust = 1),
        axis.title = element_text(size=18),
        legend.text = element_text(size=18), legend.title = element_text(size=18),
        strip.text=element_text(face="bold",size=18))+
  geom_point(aes(fill=colors2), shape = 21, size=2.5, alpha=0.5)+
  scale_fill_manual(values = col, name='Interaction\nsign')+
  geom_hline(yintercept = 0, size=1)+
  facet_grid(Source ~ Target, scales = 'free')
