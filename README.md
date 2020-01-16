# Thresholds for ecological responses to global change do not emerge from empirical data: code

This repository inherits code supplementary to the publication:

**"Thresholds for ecological responses to global change do not emerge from empirical data code"**

*Authors:  Helmut Hillebrand, Ian Donohue, W. Stanley Harpole, Dorothee Hodapp, Michal Kucera , Aleksandra M. Lewandowska, Julian Merder, Jose M. Montoya, Jan A. Freund*


**Data (assembled by Helmut Hillebrand):**

*m1_1 - m24_1*: datasets as ".csv" representing meta studies used within the study

*mall*: combined and scaled meta studies m1_1 - m24_1


**Code (written by Jan A. Freund & Julian Merder):**
**main R scripts**

`artidata.R`: Creates synthetic meta-analysis data combining prototypical response~stressor relationships with random fluctuations reflecting natural variability.

*example: artidata(set=1, np=150, isnr=0.5, r="n", plot="y")*

  - set:  type of dataset: "a" = simple null (no trend, no divergence of variance),
                           "b" = neutral (bimodal but independent),
                           "c" = plain trend (proportionate response), 
                           "d" = gradual trend (diverging variance),
                           "e" = saddle node bifurcation=default, 
                           "f" = strict threshold
                           "g" = variable threshold, 
                           "h" = thresh. & intermed., 
                           "i" = var.threshold + var.response
  - np:   number of data points (default=150)
  - isnr: inverse snr = 1/snr = noise-to-signal ratio (nsr) (default: 0)
  - r:    "n" (normal distribution=default) OR 'u'  (uniform distribution) of stressor samples
  - p:    produce a plot: "y" (yes=default), "n" (no) 



`meta_pvalues.R`: Performs the three tests (Hartigan's dip (HD), Kullback-Leibler divergence (KL), weighted quantile ratio (QR)) to find anomalies in the data indicating thresholds. For details see publication and code file. 

*example: 
Data<-read.csv("m1_1.csv);
meta_pvalues(points=Data,NP=100,reporting="y",tbw=2.5)*

- points: data frame to test (structured as output from artidata.R or one of the meta study files)
- NP: number of resamplings for computing p-values (default 100)
- reporting: print results in console:“y” (yes=default), “n” (no)
- tbw: dimensionless factor tuning bandwith adjustment in kernel density estimation (default 2.5)

`meta_estimate.R`: Calculates quantiles based on a Gaussian kernel density estimation.

*example: meta_estimate(points, qu=c(0.25,0.5,0.75),tbw=2.5,weights=1)*

- points: a dataframe or matrix with two columns, where the first represents the explanatory variable (X), the second the response (LRR)
- qu: a vector of quantiles you want to calculate (default c(0.25,0.5,0.75))
Note: should not be far below 5 % or far above 95% as for these cases the algorithm might not converge
- tbw: dimensionless factor tuning bandwith adjustment in kernel density estimation (default 2.5)
- weights: used in weighted kernel density estimation, vector with the same length as X & LRR (default: 1, i.e. equal weights)



`meta_plot.R`: plots all quantile lines and marginal densities together with original data points (point size scaled by weight, point color by habitat)

*example: meta_plot( Data=meta_pvalues( artidata()), ... )*

- Data: list similar to result of meta_pvalues()
- show: for the original data use 'original' (default); for the last permuted surrogate use 'surrogate'
- pointsize: size of the points (numeric, default: 7)
- weights: should pointsizes be based on weights? TRUE or FALSE, ignores pointsize
- title: your plot title (string)
- xname: your label for x (string)
- yname: your label for y (string)
- showleg: should a legend be shown? TRUE or FALSE
- useyd: should a density in y be added? TRUE or FALSE
- name_(blue/cyan/darkblue/green): four names assigned to four colors in plot legend (four strings)


**All other R scripts in this repository are subroutines called by the above main routines**

The following R packages must be installed: 
	plotly, dplyr, diptest, spatstat
  
  Hadley Wickham, Romain François, Lionel Henry and Kirill Müller (2019). dplyr: A Grammar of Data Manipulation. R
  package version 0.8.0.1. https://CRAN.R-project.org/package=dplyr
  
   Carson Sievert (2018) plotly for R. https://plotly-r.com
   
   Martin Maechler (2016). diptest: Hartigan's Dip Test Statistic for Unimodality - Corrected. R package version
   0.75-7. https://CRAN.R-project.org/package=diptest
   
   Adrian Baddeley, Rolf Turner (2005). spatstat: An R Package for Analyzing Spatial Point Patterns. Journal of
   Statistical Software 12(6), 1-42. URL http://www.jstatsoft.org/v12/i06/.


