# Exploring the changing key player in microbial community network
## Introduction
In current study, FINDER (FInding key players in Networks through DEep Reinforcement learning) was used to estimate the roles of microbes in the varying interaction network. This directory provides the codes for transferring the regularized S-map results to the FINDER input and visualizing the FINDER result.

## Data preparation
After the calculation of real time interaction strengths among microbes, you will get the regularized S-map result (output_demo) in ../Output. We cannot use this directory as the input for FINDER, so we have developed a python script to transfer our result to the input format of FINDER. Run the J_abd-FINDER_input.py and you will get the FINDER input directory. You can change the J_abd_pah in Line 62 if you have saved you regularized S-map result elsewhere. Meanwhile, you should change index of the for loop in Line 66-81 if you have different sample number in your own analysis. Forgive the author's laziness because he is so occupied by other research.

## Estimation of the changing roles in network using FINDER
The tutorial and codes of FINDER is avaialbale at https://github.com/FFrankyy/FINDER. Input the directory we created in the last step.

## Visualize the FINDER result
FINDER will return a directory containing the pairwise connectivity contribution of each microbe in the network. In our study, there are 13 microbes and 259 networks in total. Therefore, we have used the heatmap to visualize the contribution of each microbe at different states. Run FINDER_Plot.R to recreate the Fig 6a in our paper.
Change data_loc in Line 6 if you have saved the FINDER result somewhere.
