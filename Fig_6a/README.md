# Exploring the changing key player in microbial community network
## Introduction
In current study, FINDER (FInding key players in Networks through DEep Reinforcement learning) was used to estimate the roles of microbes in the varying interaction network. This directory provides the codes for transferring the regularized S-map results to the FINDER input and visualizing the FINDER result.

## Data preparation
After the calculation of real time interaction strengths among microbes, you will get the regularized S-map result (output_demo) in ../Output. We cannot use this directory as the input for FINDER, so we have developed a python script to transfer our result to the input format of FINDER. 
https://github.com/FFrankyy/FINDER
