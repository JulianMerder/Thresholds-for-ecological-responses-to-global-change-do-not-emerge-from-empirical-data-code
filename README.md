# Ecological responses to global change are rarely characterized by thresholds (code)

**Code written by: Jan A. Freund & Julian Merder**

This repository inherits code supplementary to the publication:

**"Ecological responses to global change are rarely characterized by thresholds"**

*Authors:  Helmut Hillebrand, Ian Donohue, W. Stanley Harpole, Dorothee Hodapp, Michal Kucera , Aleksandra M. Lewandowska, Julian Merder, Jose M. Montoya, Jan A. Freund*



Data and main functions: 

*m1_1 - m24_1*: datasets as ".csv" representing meta studies used within the study

*mall*: combined and scaled meta studies m1_1 - m24_1

`artidata.R`: [..] creates simulated artificial meta-analyses combining prototypical response~stressor relationships with random fluctuations reflecting natural variability [...]

*example: 
artidata(set=0,np=150,isnr=0.5,r="n",plot="y")*

  - set:  type of dataset (1: sn bifurcation=default, 2: neutral, 3: plain trend, 4: gradual, 5: strict threshold
                         6: variable threshold, 7: thresh. & intermed., 8: var.threshold + var.response )
  - np:   number of data points (default=1000)
  - isnr: inverse snr = 1/snr = noise-to-signal ratio (nsr) (default: 0)
  - r:    "n" (normal distribution=default) OR 'u'  (uniform distribution) of stressor samples
  - p:    produce a plot: "y" (yes=default), "n" (no) 



`meta_pvalues.R`: performs the three tests (Hartigan's dip (HD), Kullback-Leibler divergence (KL), weighted quantile ratio (QR)) to find anomalies in the data indicating thresholds. For details see publication and code file. 

*example: 
Data<-read.csv("m1_1.csv);
meta_pvalues(points=Data,NP=100,reporting="yes",tbw=2.5)*

- points: data frame to test (output from artidata.R or one of the meta study files)
- NP: number of repetitions
- reporting: should results be printed?
- tbw: multiplicator for bandwith adjustment in kernel density estimation

`meta_estimate.R`: calculates quantiles based on a gaussian kernel density estimation.
- points: a dataframe or matrix with two columns, where the first represents the explanatory variable (X), the second the response (LRR)
- qu: a vector of quantiles you want to calculate. Note: should not be far below 5 % or far above 95% as for these cases the algorithm might not converge
- tbw: a tuning factor for the bandwidth in kernel density estimations
- weights: a vector of weights used in density estimation of the same length as X & LRR



`meta_plot.R`: plots marginal and calculated quantiles along the stressor

- Data: your meta_pvalues() result
- show: for the original data use 'original'; for the last permuted surrogate use 'surrogate'
- pointsize: size of the points
- weights: should pointsizes be based on weights? TRUE or FALSE, ignores pointsize
- title: your plot title
- xname: your label for x
- yname: your label for y
- showleg: should a legend be shown? TRUE or FALSE
- useyd: should a density in y be added? TRUE or FALSE
- name_blue .._cyan.._darkblue.._green: give names for point levels


(all other functions within this repository are subroutines of the functions shown above for a better traceability of the code structure and eased comprehension of the algorithm)

