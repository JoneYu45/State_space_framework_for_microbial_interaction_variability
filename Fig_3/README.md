# Exploring the manifold geometric properties
## Introduction
This directory provides the codes for analyzing the geometric properties of discrete manifold and exploring the variability of microbial interspecific interaction.

## Data preparation
The Global Water Microbiome Consortium GWMC dataset <sup>1</sup> is used as the reference dataset for the analysis of manifold geometric properties, and the daily time series of activated sludge microbiome from HK city <sup>2</sup> is use for the validation of our framework. The time series is provided as a demo.csv in ../Input. The GWMC dataset is not provided here to avoid copyright violadation according to http://gwmc.ou.edu/data-disclose.html. In this study, the raw sequences were download from  NCBI Sequence Read Archive with the accession number PRJNA509305. The reference dataset was obtain by analyzing these sequences via QIIME2. Detail could be found in the metahod and material section. For illustration, we have use the demo.csv as the reference dataset and rename it as reference_demo.csv.

## Analyze the manifold geometric properties via locally weighted regression
A locally weighted regression (LWR) scheme is developed in our study (see metahod and material section for further details). After preparing the time series and reference dataset, you can calculate the partial slopes at a target state of the discrete manifold by running the following python codes
```
python ./Locally_Weighted_Regression/Function/Locally_Weighted_Regression_20220121_WOT1.py -I ../Input/demo.csv -R ../Input/reference_demo.csv -O ../Output/LWR_output_demo 
```

To select domninant taxa (e.g., average abundance > 80%, absence frequncy < 20%) in your dataset, you can run the following code
```
python ./Locally_Weighted_Regression/Function/Locally_Weighted_Regression_20220121_WOT1.py -I ../Input/demo.csv -R ../Input/reference_demo.csv -O ../Output/LWR_output_demo -D 80 -Z 20
```

It should be mentioned that we have tried our code with the sparse matrix but it did not go well. So the analysis without rare species is recommended. We are now working on this issue.
The analysis can take a long time (weeks or even months), depending on the taxa number and sample number in your dataset. Here we provided a speedup solution. After running the aforementioned code, you can also runs the reversed version of LWR
```
python ./Locally_Weighted_Regression/Function/Locally_Weighted_Regression_20220121_WOT1_R.py -I ../Input/demo.csv -R ../Input/reference_demo.csv -O ../Output/LWR_output_demo -D 80 -Z 20
```
This should shorten the analysis time by half. Moreover, if you have a powerful computer, simply change the num_cores in Line 143 of Locally_Weighted_Regression_20220121_WOT1.py. It should help to speed up your analysis, too.

There are many other parameters needed adjustment, e.g., theta (θ), thetaps (θps). You can refer to our paper for further details. If you still have any question, don't hesitate to send me an email.

## Quality control for  the LWR results
In our study, different θps and θ were used to obtain the best characterization of manifold geometric properties. In order to find the best fit, we can run the Inference_QC.R. You can change the path and subpath in Line 6-7 if you have saved and named your output differently. Here, the RMSE/STD is used to estimate the inference quality <sup>3</sup>. In brief, the smaller RMSE/STD, the better inference. See our paper for further details.

## Visualize the LWR results
The R code Find_steady_edges.R can help you recreate the Fig 3 in our paper. Simply change the path in Line 66 if you have saved and named your output differently. This plot help you to explore the interaction range boundary between two interacting microbes.

## References
1.	Wu, L.; Ning, D.; Zhang, B.; Li, Y.; Zhang, P.; Shan, X.; Zhang, Q.; Brown, M. R.; Li, Z.; Van Nostrand, J. D.; Ling, F.; Xiao, N.; Zhang, Y.; Vierheilig, J.; Wells, G. F.; Yang, Y.; Deng, Y.; Tu, Q.; Wang, A.; Acevedo, D.; Agullo-Barcelo, M.; Alvarez, P. J. J.; Alvarez-Cohen, L.; Andersen, G. L.; de Araujo, J. C.; Boehnke, K. F.; Bond, P.; Bott, C. B.; Bovio, P.; Brewster, R. K.; Bux, F.; Cabezas, A.; Cabrol, L.; Chen, S.; Criddle, C. S.; Etchebehere, C.; Ford, A.; Frigon, D.; Sanabria, J.; Griffin, J. S.; Gu, A. Z.; Habagil, M.; Hale, L.; Hardeman, S. D.; Harmon, M.; Horn, H.; Hu, Z.; Jauffur, S.; Johnson, D. R.; Keller, J.; Keucken, A.; Kumari, S.; Leal, C. D.; Lebrun, L. A.; Lee, J.; Lee, M.; Lee, Z. M. P.; Li, M.; Li, X.; Liu, Y.; Luthy, R. G.; Mendonça-Hagler, L. C.; de Menezes, F. G. R.; Meyers, A. J.; Mohebbi, A.; Nielsen, P. H.; Oehmen, A.; Palmer, A.; Parameswaran, P.; Park, J.; Patsch, D.; Reginatto, V.; de los Reyes, F. L.; Rittmann, B. E.; Noyola, A.; Rossetti, S.; Sidhu, J.; Sloan, W. T.; Smith, K.; de Sousa, O. V.; Stahl, D. A.; Stephens, K.; Tian, R.; Tiedje, J. M.; Tooker, N. B.; De los Cobos Vasconcelos, D.; Wagner, M.; Wakelin, S.; Wang, B.; Weaver, J. E.; West, S.; Wilmes, P.; Woo, S.-G.; Wu, J.-H.; Wu, L.; Xi, C.; Xu, M.; Yan, T.; Yang, M.; Young, M.; Yue, H.; Zhang, T.; Zhang, Q.; Zhang, W.; Zhang, Y.; Zhou, H.; Zhou, J.; Wen, X.; Curtis, T. P.; He, Q.; He, Z.; Global Water Microbiome, C., Global diversity and biogeography of bacterial communities in wastewater treatment plants. Nature Microbiology 2019, 4, (7), 1183-1195.
2.	Jiang, X.-T.; Ye, L.; Ju, F.; Wang, Y.-L.; Zhang, T., Toward an Intensive Longitudinal Understanding of Activated Sludge Bacterial Assembly and Dynamics. Environmental Science & Technology 2018, 52, (15), 8224-8232.
3.	Perretti, C. T.; Munch, S. B.; Sugihara, G., Model-free forecasting outperforms the correct mechanistic model for simulated and experimental data. Proceedings of the National Academy of Sciences 2013, 110, (13), 5253-5257.
