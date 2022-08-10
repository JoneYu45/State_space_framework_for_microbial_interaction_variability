# Visualize the Varying Microbial Interaction Network
## Introduction
This directory provides the codes and for creating the network plots of varying microbial interaction strength.

## Data preparation
Run the Regularized S-map analysis according to the README.md in ../Fig_2, and you will get a directory containing the varying interaction strength between every two microbes in Output/output_demo.

## Draw your varying network plot
Run the python file Draw_Varying_Network_from_J_2022-02-24.py, and you will get the varying network plot like Fig S1. If you want to draw the plot with your own data, simply change the data path in Line 54. You can also change the apperance of your figure (e.g., node size, node color, edge color, etc) by changing the parameters in Line 37-50.
