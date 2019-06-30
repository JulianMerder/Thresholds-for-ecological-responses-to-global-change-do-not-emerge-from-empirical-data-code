
## function to compute quantiles of a response and one explanatory variable

#points: a dataframe or matrix with two columns, where the first represents the explanatory variable (X), the second the response (LRR)
# qu: a vector of quantiles you want to calculate. Note: should not be far below 5 % or far above 95% as for these cases the algorithm might not converge
#tbw: a tuning factor for the bandwidth in kernel density estimations
#weights: a vector of weights used in density estimation of the same length as X & LRR


meta_estimate <- function(points, qu=c(0.25,0.5,0.75),tbw=2.5,weights=1){
  #prepare results in a list and initialize original$points
  results <- list()
  results$original <- list()
  results$original$points <- data.frame(X=points[,1],LRR=points[,2],var.LRR=(1/(exp(weights)-1))) #because of scaling in meta_prepare.R
  rm(points)
  qu<-sort(qu, decreasing = FALSE)
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
  
  nx <- length(results$original$grid$gx)
  srange <- results$original$crange[3:4]
  #firstly, for all p distributions  
  p <- results$original$p
  pgrid <- results$original$grid$gy
  pquant <- matrix(NA,nrow=nx,ncol=length(qu))
  colnames(pquant)<-paste0("Q",qu)
  pcdf <- apply(p, 2, cumsum)
  for (i in 1:nx){
    pf <- approxfun(pgrid, pcdf[,i])
    for(j in 1:length(qu)){
    pquant[i,j] <- uniroot(function(x) pf(x)-qu[j], srange)$root
    }
  }
  #add this to the data structure
  results$pcdf <- pcdf
  results$pquant <- pquant
  
  return(cbind(data.frame(x=results$original$grid$gx),as.data.frame(results$pquant)))
}
  
  
  
  