# Validation of the Methodology
## Introduction
This directory provides the codes for ploting the accuracy of our framework to predict the real-time meicrobial interaction strength.

## Data preparation
After the regularized S-map and locally weighted regression analysis, you will get two directories in ../Output. Now let's see if the real time interaction strength will lie within the maximum and minimum partial slopes at the local state of discrete manifold. Run the Interaction_prediction_accuracy_plot.R. Change the path in Line 66, 76, and 103 if you have saved and renamed your results differently. Meanwhile, if you have used different θ in you analysis, remember to change θ list the Line 73.
