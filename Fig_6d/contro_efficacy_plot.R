#Environment setup
library(ggplot2)

#Data location
path <- 'E:/学习/研究生/研究生课题/大规模污泥群落数据统计/数据/resubmission_data/control_L7_20220228_abd1_Z50_thtps2_C001'
workbook <- paste(path, 'Control_efficacy.csv', sep = '/')

#Input data
input <- read.csv(workbook)
input$`Source-Target` <- paste(input$Source, input$Target, sep = '-')

#Plot
ggplot(input, aes(x=`Source-Target`, y=Probability, fill=Direction))+
  theme(panel.grid.major =element_line(size = 1),
        # axis.title.x = element_blank(),
        axis.title = element_text(size = 14, colour = "black"),
        axis.text = element_text(size = 12, colour = "black"),
        axis.line = element_line(linetype = "solid", size = 0.5),
        panel.background = element_rect(color = "black", size = 0.5),
        panel.grid.minor = element_blank()
  )+
  geom_bar(stat='identity')

#Plot all control input
ggplot(input, aes(x=`Source-Target`, y=Probability, fill=Direction))+
  theme(panel.grid.major =element_line(size = 1),
        # axis.title.x = element_blank(),
        axis.title = element_text(size = 14, colour = "black"),
        axis.text = element_text(size = 12, colour = "black"),
        axis.line = element_line(linetype = "solid", size = 0.5),
        panel.background = element_rect(color = "black", size = 0.5),
        panel.grid.minor = element_blank(),
        strip.text.x = element_text(size=12, face="bold")
  )+
  # facet_grid(. ~ Theta)+
  geom_bar(stat='identity')+
  scale_x_discrete(limits=c('5-10', '9-11','8-4'))+
  ylab('Probability (%)')

#Run the Find_steady_edges.R and then run the following codes
##Make input
input2$`Source-Target` <- paste(input2$Source, input2$Target, sep = '-')
focus_loc <- which(input2$`Source-Target` == '8-4') # '0-8'''4-8''5-10'
input_focus <- input2[focus_loc,]

##Plot
ggplot(input_focus, aes(x=Strength, fill=sign, color=sign))+
  geom_histogram(bins = 15,position='stack', alpha=0.5)+
  theme(axis.text.y = element_blank(),
        axis.text.x = element_text(size=10, angle=45, vjust=1, hjust=1),
        axis.title = element_text(size=18),
        legend.text = element_text(size=18), legend.title = element_text(size=18),
        strip.text=element_text(face="bold",size=18))+
  geom_vline(xintercept = 0, color='red', linetype='dashed')+
  facet_grid(. ~ `Source-Target`, scales = 'free_y')+
  xlim(-1.5,1.5)
