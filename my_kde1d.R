my_kde1d <- function (data, grid, weights, tbw=1) 
  {
  n <- length(data)
  if (any(!is.finite(data))) 
    stop("missing or infinite values in the data are not allowed")
  if (missing(weights)) 
    weights <- rep(1,n)           # equal statistical weight to all nx points
  weights <- weights/sum(weights) # normalizes weights
  #
  h <- tbw*bw.SJ(data,method = "ste") # tbw tunes bandwidth
  #
  a <- outer(grid, data, "-")/h
  da <- dnorm(a)
  mw <- matrix(weights,dim(da)[1],dim(da)[2],byrow=T) #replicate the weight list rowwise for each point of gy 
  wda <- mw*da
  dens <- rowSums(wda)/h
  return(dens)
  }