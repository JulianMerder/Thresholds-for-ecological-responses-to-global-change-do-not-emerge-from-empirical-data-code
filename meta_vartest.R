meta_vartest <- function(data) {
  piqr <- data$pquant[, 3] - data$pquant[, 1] # compute the central 90%-percentile (95%-5% interquantile)
  library(spatstat)
  quantico <- weighted.quantile(piqr, data$marg$x, probs = c(0.01, 0.99)) # compute the 1% and 99% quantile
                                    # of the central 90%percentile weighted by the marginal stressor distribution 
  vartest <- quantico[2] / quantico[1]
  return(vartest)
}