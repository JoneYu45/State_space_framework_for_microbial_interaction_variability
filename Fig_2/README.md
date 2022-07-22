# Explore the Varying Microbial Interaction Network
## Introduction
This directory provides the codes and for creating the scatter plots of varying microbial interaction strength.

## Data preparation
A time series is required for the analysis. The time series of activated sludge community in current study was created by QIIME2 using the raw sequences from NCBI accession number PRJNA324303 <sup>1</sup>. After preparing the time series data, use the regularized S-map to calculate the varying microbial interaction strengths by the following codes:
```
python Regularized_S-map_new.py -I ../Input/demo.csv -O ../Output/output_demo
```
The code for regularized S-map could be download from https://github.com/JoneYu45/Regularized_S-map_Python.

## References
1. Jiang, X.-T.; Ye, L.; Ju, F.; Wang, Y.-L.; Zhang, T., Toward an Intensive Longitudinal Understanding of Activated Sludge Bacterial Assembly and Dynamics. Environmental Science & Technology 2018, 52, (15), 8224-8232.
2. Yu, Z.; Gan, Z.; Huang, H.; Zhu, Y.; Meng, F., Regularized S-Map Reveals Varying Bacterial Interactions. Applied and Environmental Microbiology 2020, 86, (20), e01615-20.
