my_kde2d <- function (x, y, grid, weights, tbw=1){
  nx <- length(x)
  if (length(y) != nx) 
    stop("data vectors must be the same length")
  if (any(!is.finite(x)) || any(!is.finite(y))) 
    stop("missing or infinite values in the data are not allowed")
  if (missing(weights)) 
    weights <- rep(1,nx)                          # equal statistical weight to all nx points
  weights <- weights/sum(weights)                 # normalizes weights
 
  h <- tbw*c(bw.SJ(x,method = "ste"),bw.SJ(y,method = "ste"))# tbw tunes bandwidth
 
  ax <- outer(grid$gx, x, "-")/h[1]
  ay <- outer(grid$gy, y, "-")/h[2]
  dax <- dnorm(ax)
  day <- dnorm(ay)
  mw <- matrix(weights,dim(dax)[1],dim(dax)[2],byrow=T) #replicate the weight list rowwise for each point of gx  
  wdax <- mw*dax
  dens <- tcrossprod(wdax, day)/(h[1] * h[2])
  return(dens)
}