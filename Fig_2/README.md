# Explore the Varying Microbial Interaction Network
## Introduction
This directory provides the codes for creating the scatter plots of varying microbial interaction strength.

## Data preparation
A time series is required for the analysis. The time series of activated sludge community in current study was created by QIIME2 using the raw sequences from NCBI accession number PRJNA324303 <sup>1</sup>. After preparing the time series data, use the regularized S-map to calculate the varying microbial interaction strengths by the following codes:
```
python Regularized_S-map_new.py -I ../Input/demo.csv -O ../Output/output_demo
```
The code for regularized S-map could be download from https://github.com/JoneYu45/Regularized_S-map_Python <sup>2</sup>.

After calculation, a directory named "output_demo" will be created under the Output directory, which contains the csv tables of interaction strengths among different microbes. 

## Visualization of the varying micorbial interaction
We have used ggplot in R to visualize the varying micorbial interaction. Please run the varying_interaction.R for visualization. You can change different theta (0.1, 0.5, 1, 2, 5, or 10) to explore the effect of theta on S-map analysis (Line 5). Furthermore, you can focus on different target (Line 72) and source (Line 73) nodes.

## References
1. Jiang, X.-T.; Ye, L.; Ju, F.; Wang, Y.-L.; Zhang, T., Toward an Intensive Longitudinal Understanding of Activated Sludge Bacterial Assembly and Dynamics. Environmental Science & Technology 2018, 52, (15), 8224-8232.
2. Yu, Z.; Gan, Z.; Huang, H.; Zhu, Y.; Meng, F., Regularized S-Map Reveals Varying Bacterial Interactions. Applied and Environmental Microbiology 2020, 86, (20), e01615-20.
