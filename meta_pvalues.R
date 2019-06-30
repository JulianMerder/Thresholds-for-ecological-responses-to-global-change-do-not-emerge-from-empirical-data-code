meta_pvalues <- function(points, NP=100, reporting="yes",tbw=2.5){
  #prepare results in a list and initialize original$points
  results <- list()
  results$original <- list()
  results$original$points <- points
  rm(points)
  #
  source("meta_prepare.R")  # prepare range for 2d-density, 2d grid and statistical weights   
  source("meta_marginal.R") # use weighted 1-d kernel density estimate to compute marginal distributions
  results$original$facy=1.2
  results$original$checkfacy="not passed"
  while(results$original$checkfacy=="not passed"){
  results$original <- meta_prepare(results$original,facy=results$original$facy)
  results$original <- meta_marginal(results$original,tbw)
  }
  source("meta_2dkde.R")    # use weighted 2-d kernel density estimate to compute joint distribution
  results$original <- meta_2dkde(results$original,tbw)
  source("meta_norm.R")     # step from joint distribution p(x,y) to conditional distribution p(y|x)
  # NOTICE THAT jont p(x~rows,y~cols) BUT conditional p(y~rows | x~cols) !!!
  results$original <- meta_norm(results$original)
  # use marginal_y distribution as reference distribution q for KL[p,q]
  results$original$q <- results$original$marg$y
  source("meta_quant.R")    # compute (conditional) qunatiles
  results$original <- meta_quant(results$original)
  source('meta_vartest.R')  # compute test statistic for non-homogeneous variability: max(iqr)/min(iqr)
  results$original$VAR.TS <- VAR.TS <- meta_vartest(results$original)
  source('meta_KLD.R')       # estimate the Kullback Leibler divergence
  results$original$KLD.TS  <- KLD.TS <- meta_KLD(results$original)
  library(diptest)          # perform the diptest for non-unimodal distribution
  results$original$DIP.TS <- dip.test(results$original$points$LRR)
  #
  VAR.NH <- array(0,NP)
  KLD.NH  <- array(0,NP)
  #
  for (np in 1:NP){             
    
    
    results$surrogate$points<-results$original$points
    results$surrogate$points$X<-results$original$points$X[sample(1:length(results$original$points$X))]
    results$surrogate$crange <-  results$original$crange   # copy from original to surrogate data
    results$surrogate$grid   <-  results$original$grid     # copy from original to surrogate data
    results$surrogate$facy=results$original$facy
    results$surrogate$checkfacy="not passed"
    while(results$surrogate$checkfacy=="not passed"){
      results$surrogate <- meta_prepare(results$surrogate,facy=results$surrogate$facy)
      results$surrogate <- meta_marginal(results$surrogate,tbw,np=np)
    }
    
    results$surrogate <- meta_2dkde(results$surrogate,tbw)
    # NOTICE THAT jont p(x~rows,y~cols) BUT conditional p(y~rows | x~cols) !!!
    results$surrogate <- meta_norm(results$surrogate)
    # use marginal_y distribution as reference distribution q for KL[p,q]
    results$surrogate$q <- results$surrogate$marg$y
    results$surrogate <- meta_quant(results$surrogate)
    results$surrogate$VAR.NH <- VAR.NH[np] <- meta_vartest(results$surrogate)
    results$surrogate$KLD.NH  <- KLD.NH[np]  <- meta_KLD(results$surrogate)
  }
  results$pvalues$DIP <- results$original$DIP.TS$p.value
  results$pvalues$VAR <- sum((VAR.NH>=VAR.TS), na.rm=FALSE)/NP
  results$pvalues$KLD  <- sum((KLD.NH>=KLD.TS), na.rm=FALSE)/NP
  results$pvalues$no.replicates <- NP
  #
  if (reporting=="yes"){
    message(paste('p-value of VAR is ',results$pvalues$VAR))
    message(paste('p-value of KLD is ',results$pvalues$KLD))
    message(paste('p-value of DIP is ',results$pvalues$DIP))
    message(paste('number of replicates was',results$pvalues$no.replicates))
  }
  return(results)
}
