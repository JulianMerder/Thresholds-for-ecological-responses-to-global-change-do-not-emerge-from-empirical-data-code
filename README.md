# Ecological responses to global change are rarely characterized by thresholds (code)

This repository inherits code supplementary to the publication:

**"Ecological responses to global change are rarely characterized by thresholds"**

*Authors:  Helmut Hillebrand, Ian Donohue, W. Stanley Harpole, Dorothee Hodapp, Michal Kucera , Aleksandra M. Lewandowska, Julian Merder, Jose M. Montoya, Jan A. Freund*


Data and main functions: 

**m1_1 - m24_1**: datasets as ".csv" representing meta studies used within the study

`artidata.R`: [..] creates simulated artificial meta-analyses combining prototypical response~stressor relationships with (normally distributed) random fluctuations reflecting natural variability [...]

`meta_pvalues.R`: performs the three tests (Hartigan's dip (HD), Kullback-Leibler divergence (KL), weighted quantile ratio (QR)) to find anomalies in the data indicating thresholds. For details see publication and code file. 

`meta_estimates.R`: calculates quantiles based on a gaussian kernel density estimation.

`meta_plot.R`: plots marginal and calculated quantiles along the stressor

(all other functions within this repository are subroutines of the functions shown above for a better traceability of how the code works)

