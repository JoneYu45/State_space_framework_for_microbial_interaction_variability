# An arbitrary proposal for targeted manipulation of activated sludge community
## Introduction
Due to our inability to culture the microbes for solid validation of our strategy, we used the simulation to verify our framework, in a very arbitrary manner. See the result section and Fig 6 for more info. We really looking forward to some experimental validation of our result in the future. This directory provides the codes for simulation of the target control of varying microbial interaction network.

## Simulation of the target control
Run the python script Control_Simulation.py and its input is the same as Locally_Weighted_Regression_20220121_WOT1.py in the Fig_3.
```
python Control_Simulation.py -I ../Input/demo.csv -R ../Input/reference_demo.csv -O ../Output/control_simulation_demo
```
There is one new parameter, i.e., the control input (-C). It represent the increase in relative abundance of control node. For example, "-C 0.5" means increase the control nodes by 0.5%. Run the following codes to find out
```
python Control_Simulation.py -I ../Input/demo.csv -R ../Input/reference_demo.csv -O ../Output/control_simulation_demo -C 0.5
```
The analysis will return a directory containing the csv file of simulation result. You can select some result for visualization.

